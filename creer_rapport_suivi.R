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
# Vérifier les paramètres
# =============================================================================

# TODO
# - dates dans le bon format
# - fin après début
# - rejet_proj_dir existe
# - main_file_dta existe
# - dispose d'accès à l'espace de travail
# - sup_exclus est vide ou suit le bon format

# =============================================================================
# Créer le rapport avec les paramètres indiqués ci-haut
# =============================================================================

rmarkdown::render(
    input = paste0(rapport_dir, "R/rapport.Rmd"),
    output_dir = rapport_dir,
    params = rapport_params,
    encoding = "UTF-8"
)
