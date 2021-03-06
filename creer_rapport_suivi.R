# =============================================================================
# Fournir les paramètres du projet
# =============================================================================

rapport_dir <- ""

rapport_params <- list(

    # RÉPERTOIRE DU PROJET
    proj_dir = rapport_dir,

    # PÉRIODE DU RAPPORT: DÉBUT ET FIN
    # pour les dates,  mettre dans le format ISO 8601: AAAA-MM-JJ
    # par exemple "2021-11-25" pour le 25 novembre 2021
    rapport_debut   = "",
    rapport_fin     = "",

    # ENTRETIENS À INCLURE SELON LE STATUT
    # Notez ce à quoi correspond chaque valeur de statut
    # 65 RejectedBySupervisor
    # 100 Completed
    # 120 ApprovedBySupervisor
    # 125 RejectedByHeadquarters
    # 130 ApprovedByHeadquarters
    statuses_to_review = c(100, 120, 130),

    # ECHANTILLONAGE
    # Veuillez fournir quelques informations qui permettront d'informer
    # le progrès global de l'enquête et le progrès au niveau de chaque DR
    # nombre de DR attendu
    n_dr            = ,
    # nombre de ménages attendu par DR selon le plan d'échantillonnage
    n_menages_dr    = ,
    # nombre de ménages de remplacement (plafond)
    n_menages_remplacement = ,

    # ACCES AU SERVEUR
    serveur         = "",
    utilisateur_api = "",
    passe_api       = "",
    workspace       = "",

    # APPLICATIONS DE COLLECTE
    # Nom des masques
    masque_menage   = "",
    masque_comm     = "",

    # FICHIERS PRINCIPAUX PAR APPLI: NOM ET VARIABLES
    # tâcher d'inclure l'exentension .dta.
    # MENAGE
    # normalement, ça doit être "menage.dta", comme la valeur de défaut ici-bas
    menage_fichier  = "",
    # COMMUNAUTAIRE
    comm_fichier    = "",
    grappe_var      = "grappe",
    region_var      = "s00q01", # s00q01
    departement_var = "s00q02", # s00q02
    commune_var     = "s00q03", # s00q03
    milieu_var      = "s00q04", # s00q04
    dr_var          = "s00q06", # s00q06

    # CALCUL DES CALORIES
    # fichier calories
    nom_fichier_calories = "",
    # fichier facteurs
    nom_fichier_facteurs = "",
    facteurs_niv        = "", # valeurs: "national", "strate"
    facteurs_prod_id    = "",
    facteurs_region     = "", # si niveau national, mettre NULL (sans guillemets)
    facteurs_milieu     = "", # si niveau national, mettre NULL (sans guillemets)
    facteurs_unite      = "",
    facteurs_taille     = "",
    facteurs_poids      = "",

    # CHEFS D'ÉQUIPE À EXCLURE DU RAPPORT
    # parfois, il existe des chefs fictifs ou des rélicats de la formation
    # si tel et le cas, fournir une liste délimitée par virgule des noms (e.g., "Chef1, Chef2")
    # si tel n'est pas le cas, laisser la valeur de défaut ici-bas: ""
    sup_exclus      = ""

)

# =============================================================================
# Charger les packages
# =============================================================================

renv::restore()

# =============================================================================
# Enregistrer la clé d'accès au serveur
# =============================================================================

susoapi::set_credentials(
    server = rapport_params$serveur,
    user = rapport_params$utilisateur_api,
    password = rapport_params$passe_api
)

# =============================================================================
# Vérifier les paramètres fournis ci-haut
# =============================================================================

# -----------------------------------------------------------------------------
# Période du rapport
# -----------------------------------------------------------------------------


# dates dans le bon format
invalid_start_date  <- is.na(lubridate::ymd(rapport_params$rapport_debut))
invalid_end_date    <- is.na(lubridate::ymd(rapport_params$rapport_fin))

if (invalid_start_date == TRUE | invalid_end_date == TRUE) {
    stop(paste0(
        "L'un des éléments de la période de suivi",
        "--`rapport_debut` ou `rapport_fin`--ne suit pas le format voulu. ",
        "Veuillez corriger."
    ))
}

# date de fin intervient après la date de début
date_start  <- lubridate::ymd(rapport_params$rapport_debut) 
date_end    <- lubridate::ymd(rapport_params$rapport_fin)
order_right <- (date_start < date_end)

if (order_right == FALSE) {
    stop(paste0(
        "La période du rapport a des bornes incorrectes. ",
        "Soit la date de début, `rapport_debut`, intervient apès la date de fin. ",
        "Soit la date de fin, `rapport_fin`, intervient avant la date début. ",
        "Veuillez corriger"
    ))
}

# -----------------------------------------------------------------------------
# Accès au serveur
# -----------------------------------------------------------------------------

verification_acces <- susoapi::check_credentials(
    workspace = rapport_params$workspace, 
    verbose = TRUE
)

if (verification_acces == FALSE) {
    stop(paste0(
        "Les détails d'accès au serveur ne permettent pas d'accéder ",
        "au serveur et/ou l'espace de travail. ",
        "Veuillez corriger."
    ))
}

# -----------------------------------------------------------------------------
# Misc
# -----------------------------------------------------------------------------

# sup_exclus est vide ou suit le bon format
sups_vide   <- rapport_params$sup_exclus == ""
sups_list   <- unlist(strsplit(
        x = rapport_params$sup_exclus,
        split = ",[ ]*"
    ))
sups_format <- length(sups_list) >= 1

if (sups_vide != TRUE & sups_format != TRUE) {
    stop(paste0(
        "Le paramètre `sup_exclus` ni n'est vide ni ne suit le format voulu. ",
        "Veuillez corriger"
    ))
}

# =============================================================================
# Télécharger les données nécessaires
# =============================================================================

# -----------------------------------------------------------------------------
# Définir les dossiers pour le téléchargement
# -----------------------------------------------------------------------------

# scripts
script_dir <- paste0(rapport_params$proj_dir, "R/")
# données
data_dir <- paste0(rapport_params$proj_dir, "data/") # /data/
hhold_dir <- paste0(data_dir, "hhold/")
comm_dir <- paste0(data_dir, "community/")
sync_dir <- paste0(data_dir, "sync/")
# ménage
hh_resource_dir <- paste0(hhold_dir, "00_resource/")  # /00_resource/
hh_download_dir <- paste0(hhold_dir, "01_downloaded/")  # /01_downloaded/
hh_combined_dir <- paste0(hhold_dir, "02_combined/")  # /02_combined/
hh_derived_dir <- paste0(hhold_dir, "03_derived/")   # /03_derived/
# communautaire
comm_download_dir <- paste0(comm_dir, "01_downloaded/")  # /01_downloaded/
comm_combined_dir <- paste0(comm_dir, "02_combined/")  # /02_combined/

# -----------------------------------------------------------------------------
# Ménage
# -----------------------------------------------------------------------------

# Accomplit les tâches suivants:
# - purger les anciennes données
# - télécharger la version actuelle de toutes les données
# - décomprimer les archives zip
# - joindre toutes les bases du même nom
# - sauvegarder le résultat
source(paste0(script_dir, "get_hhold_data.R"))
source(paste0(script_dir, "unpack_and_combine_hhold.R"))

# -----------------------------------------------------------------------------
# Communautaire
# -----------------------------------------------------------------------------

# Accomplit les tâches suivants:
# - purger les anciennes données
# - télécharger la version actuelle de toutes les données
# - décomprimer les archives zip
# - joindre toutes les bases du même nom
# - sauvegarder le résultat
source(paste0(script_dir, "get_community_data.R"))
source(paste0(script_dir, "unpack_and_combine_community.R"))

# -----------------------------------------------------------------------------
# Synchronisation
# -----------------------------------------------------------------------------

# obtenir les métadonnées concernant la dernière mise à jour de chaque entretien
interview_sync_dates <- susoapi::get_interviews(workspace = rapport_params$workspace)

# sauvegarder pour utilisation ultérieure
writexl::write_xlsx(
    x = interview_sync_dates,
    path = paste0(sync_dir, "interview_sync_dates.xlsx")
)

# =============================================================================
# Vérifier les bases et leur contenu
# =============================================================================

# -----------------------------------------------------------------------------
# Ménage
# -----------------------------------------------------------------------------

# base existe
chemin_menage <- paste0(hh_combined_dir, rapport_params$menage_fichier)
if (!file.exists(chemin_menage)) {
    stop(paste0(
        "Le fichier du paramètre `menage_fichier` n'existe pas dans le répertoire `hh_combined_dir`. ",
        "Veuillez corriger le paramètre."
    ))
}

# base contient les colonnes d'identification DR
hhold <- haven::read_dta(chemin_menage)

if (!"grappe" %in% names(hhold)) {
    stop("La colonne `grappe` n'existe pas dans la base désigné dans le paramètre `menage_fichier`")
}

# -----------------------------------------------------------------------------
# Communautaire
# -----------------------------------------------------------------------------

# base existe
chemin_comm <- paste0(comm_combined_dir, rapport_params$comm_fichier)
if (!file.exists(chemin_comm)) {
    stop(paste0(
        "Le fichier du paramètre `comm_fichier` n'existe pas dans le répertoire `comm_combined_dir`. ",
        "Veuillez corriger le paramètre."
    ))
}

# base contient les colonnes d'identification DR
community <- haven::read_dta(chemin_comm)

# check that columns in community data
geo_id_vars <- c(
    rapport_params$grapp_var,
    rapport_params$region_var, 
    rapport_params$departement_var, 
    rapport_params$commune_var, 
    rapport_params$milieu_var, 
    rapport_params$dr_var
)

columns_not_community <- !geo_id_vars %in% names(community)

if (any(columns_not_community == TRUE)) {
    missing_cols <- geo_id_vars[columns_not_community]
    stop(paste0(
        glue::glue("Les colonnes suivantes n'existent pas dans la base communautaire {params$comm_fichier}: "), 
        glue::glue_collapse(missing_cols, sep = ", "), ". ",
        "Veuillez spécifier les noms de colonne dans le fichier `creer_rapport_suivi.R` ",
        "chez les paramètres `region_var`, `departement_var`, `commune_var`, `milieu_var`, `dr_var`"
    ))
}

# =============================================================================
# Créer le rapport avec les paramètres indiqués ci-haut
# =============================================================================

rmarkdown::render(
    input = paste0(rapport_dir, "R/rapport.Rmd"),
    output_dir = rapport_dir,
    params = rapport_params,
    encoding = "UTF-8"
)
