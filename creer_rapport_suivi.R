# =============================================================================
# Fournir les paramètres du projet
# =============================================================================

rapport_dir <- ""

rapport_params <- list(
    # PÉRIODE DU RAPPORT: DÉBUT ET FIN
    # pour les dates,  mettre dans le format ISO 8601: AAAA-MM-JJ
    # par exemple, "2021-11-25" pour le 25 novembre, 2021
    rapport_debut   = "",
    rapport_fin     = "",
    # RÉPERTOIRE DU PROGRAMME DE REJET
    # le rapport puise les données du programme de rejet
    rejet_proj_dir  = "",
    # NOM DU FICHIER PRINCIPAL
    # normalement, ça doit être "menage.dta", comme la valeur de défaut ici-bas
    # tâcher d'inclure l'exentension  .dta.
    main_file_dta   = "menage.dta",
    workspace       = "primary",
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
