
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ehcvm2\_rapport\_suivi

<!-- badges: start -->
<!-- badges: end -->

# Objectif

Le programme a pour vocation de créer un rapport de suivi pour deux
groupes d’indicateurs de suivi:

-   Progrès
-   Qualité

Pour en savoir plus, lire:

-   [Paramétrage](#paramétrage)
-   [Exploitation](#exploitation)

# Utilisation

## Paramétrage

Lors de l’installation initiale, fournir les paramètres dont le
programme a besoin. Ces paramètres se trouvent en deux groupes sous le
titre `Fournir les paramètres du projet`:

-   Le répertoire du rapport
-   Les paramètres du rapport

``` r
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
    facteurs_region     = "", # si niveau national, mettre NULL
    facteurs_milieu     = "", # si niveau national, mettre NULL
    facteurs_unite      = "",
    facteurs_taille     = "",
    facteurs_poids      = "",

    # CHEFS D'ÉQUIPE À EXCLURE DU RAPPORT
    # parfois, il existe des chefs fictifs ou des rélicats de la formation
    # si tel et le cas, fournir une liste délimitée par virgule des noms (e.g., "Chef1, Chef2")
    # si tel n'est pas le cas, laisser la valeur de défaut ici-bas: ""
    sup_exclus      = ""

)
```

Ces paramètres sont expliqués en plus de détails ici-bas.

### Répertoire du rapport

Pour créer le rapport, le programme a besoin de savoir où se situe le
répertoire qui est la racine du projet.

Dans le paramètre `rapport_dir`, fournir ce chemin. En ce faisant,
suivre ces consignes:

-   Utiliser les `/` au lieu des `\`
-   Mettre un `/` à la fin du chemin (e.g., `C:/mon/chemin/`)

### Paramètres du rapport

-   [Période du rapport](#période-du-rapport)
-   [Entretiens à inclure](#entretiens-à-inclure)
-   [Plan d’échantillonnage](#plan-déchantillonnage)
-   [Accès au serveur](#accès-au-serveur)
-   [Applications de collecte](#applications-de-collecte)
-   [Fichiers principaux](#fichiers-principaux)
-   [Fichiers de référence pour calculer les
    calories](#fichiers-de-référence-pour-calculer-les-calories)
-   [Chefs d’équipe exclus](#chefs-déquipe-exclus)

#### Période du rapport

Mettre les dates de début et de fin dans `rapport_debut` et
`rapport_fin`, respectivement.

Pour les dates, suivre le format ISO 8601: `AAAA-MM-JJ`.

``` r
  # PÉRIODE DU RAPPORT: DÉBUT ET FIN
  # pour les dates,  mettre dans le format ISO 8601: AAAA-MM-JJ
  # par exemple "2021-11-25" pour le 25 novembre, 2021
  rapport_debut   = ""
  rapport_fin     = ""
```

#### Entretiens à inclure

Indiquer les codes des statuts des entretiens à inclure dans le rapport.

Si l’on veut inclure tous les entretiens sur le serveur, mettre touts
les codes de statut.

Si l’on veut se limiter aux entretiens non-rejetés, retenir les codes de
défaut.

``` r
  # ENTRETIENS À INCLURE SELON LE STATUT
  # Notez ce à quoi correspond chaque valeur de statut
  # 65 RejectedBySupervisor
  # 100 Completed
  # 120 ApprovedBySupervisor
  # 125 RejectedByHeadquarters
  # 130 ApprovedByHeadquarters
  statuses_to_review = c(100, 120, 130)
```

#### Plan d’échantillonnage

Pour mesurer le progrès global ainsi que le progrès par DR, il faut
indiquer le nombre:

-   DRs tirés (i.e., unités primaires)
-   Ménages primaires tirés par DR (i.e., unités secondaires)
-   Ménages de remplacement tirés par DR

Pour le progrès global, on se sert de ces deux premiers paramètres. Avec
le nombre de DRs, on sait combien de DR couvrir. Avec le nombre de DRs
et le nombre de ménages par DR, on sait combien de ménages attendre au
total.

Pour le progrès par DR, on juge un DR achevé s’on remplit l’une des
conditions suivantes:

-   Épuisés tous les ménages tirés pour le DR–c’est à dire, a reçu un
    nombre d’entretiens égal à l’échantillon primaire plus échantillon
    de remplacement
-   Reçu le nombre d’entretiens remplis (selon `s00q08`) égal au nombre
    attendu par DR (i.e., `n_menages_dr`)

``` r
  # ECHANTILLONAGE
  # Veuillez fournir quelques informations qui permettront d'informer
  # le progrès global de l'enquête et le progrès au niveau de chaque DR
  # nombre de DR attendu
  n_dr            = 
  # nombre de ménages attendu par DR selon le plan d'échantillonnage
  n_menages_dr    = 
  # nombre de ménages de remplacement (plafond)
  n_menages_remplacement = 
```

#### Accès au serveur

Fournir les détails pour que l’un utilisateur API puissent se connecter
au serveur de collecte et à l’espace de travail où est logé la présente
vague de collecte.

Veuillez:

-   Fournir dans `serveur` une adresse web avec `/` à la fin.
-   Spécifier dans `utilisateur_api` et `passe_api` un utilisateur
    habilité à accéder à l’espace de travail

``` r
  # ACCES AU SERVEUR
  serveur         = ""
  utilisateur_api = ""
  passe_api       = ""
  workspace       = ""
```

#### Applications de collecte

Pour permettre de télécharger les données associées, fournir le nom–pas
le `questionnaire variable`–des applications visées par ce rapport:

-   l’enquête ménage
-   l’enquête communautaire

Dans la spécification du nom, utiliser un texte ou sous-texte qui
identifie uniquement le masque visé. Ces paramètres admettent des
expressions régulière.

``` r
  # APPLICATIONS DE COLLECTE
  # Nom des masques
  masque_menage   = ""
  masque_comm     = ""
```

#### Fichiers principaux

Chaque application de collecte produit plusieurs bases. Dans ce bloc de
paramètres, il est question de donner le nom–avec extension `.dta`–de la
base “pricipale”.

Pour l’application communautaire, en plus, il faut identifier le nom de
variables clé. Ces variables seront utilisées pour fusionner la base
communautaire avec la base ménage et pour créer un nom de DR à partir
d’identifiants géographiques. Si ces identifiants existent, indiquer le
nom de variable. Si un identifiant n’existe pas, fournir le nom d’une
variable qui exsite dans la base. La même variable peut être citée
plusieurs fois, au besoin.

``` r
  # FICHIERS PRINCIPAUX PAR APPLI: NOM ET VARIABLES
  # tâcher d'inclure l'exentension .dta.
  # MENAGE
  # normalement, ça doit être "menage.dta", comme la valeur de défaut ici-bas
  menage_fichier  = ""
  # COMMUNAUTAIRE
  comm_fichier    = ""
  grappe_var      = "grappe"
  region_var      = "s00q01" # s00q01
  departement_var = "s00q02" # s00q02
  commune_var     = "s00q03" # s00q03
  milieu_var      = "s00q04" # s00q04
  dr_var          = "s00q06" # s00q06
```

#### Fichiers de référence pour calculer les calories

Dans ces paramètres, fournir les mêmes informations que demandées dans
le programme de rejet. Voir
[ici](https://github.com/arthur-shaw/ehcvm2_rejet#d%C3%A9crire-les-fichiers-de-r%C3%A9f%C3%A9rence)
pour plus de détails

Par la même occasion, copier les fichiers de référence du programme de
rejet vers le programme du rapport. En plus de détail, voici les chemins
relatifs:

-   Programme de rejet: `/data/00_resource/`
-   Programme du rapport: `/data/hhold/00_resource/`

``` r
  # CALCUL DES CALORIES
  # fichier calories
  nom_fichier_calories = ""
  # fichier facteurs
  nom_fichier_facteurs = ""
  facteurs_niv        = "" # valeurs: "national", "strate"
  facteurs_prod_id    = ""
  facteurs_region     = "" # si niveau national, mettre NULL (sans guillemets)
  facteurs_milieu     = "" # si niveau national, mettre NULL (sans guillemets)
  facteurs_unite      = ""
  facteurs_taille     = ""
  facteurs_poids      = ""
```

#### Chefs d’équipe exclus

Le rapport crée une base des chefs d’équipe et des agents à partir des
informations qui existent sur le serveur pour l’espace de travail
indiqué dans le paramètre `workspace`. Dans certains cas, cela
correspond à exactement les équipes de terrain. Dans d’autres cas, cela
peut inclure des chefs d’équipe fictifs ou des rélicats de phase
antérieure (e.g., enquête pilote, formation).

Pour prendre en compte ces deux cas de figure, on peut mettre une valeur
appropriée dans le paramètre `sup_exclus`.

Pour les cas où il n’y a aucune modification à faire, laisser la valeur
de défaut `""`.

Pour les cas où il faut appurer la liste des équipes, fournir une liste
délimitée par virgule des chefs d’équipe à exclure. Par exemple:
`"Chef1, Chef2,Chef3"`. La liste peut être avec ou sans espace entre les
virgules et le prochain élément de la liste.

``` r
  # CHEFS D'ÉQUIPE À EXCLURE DU RAPPORT
  # parfois, il existe des chefs fictifs ou des rélicats de la formation
  # si tel et le cas, fournir une liste délimitée par virgule des noms (e.g., "Chef1, Chef2")
  # si tel n'est pas le cas, laisser la valeur de défaut ici-bas: ""
  sup_exclus      = ""
```

## Exploitation

### Modifier les dates du rapport

Avant de créer le rapport, modifier les dates du début et de fin de la
période du rapport. Ces informations servent à trier les informations du
rapport et ainsi n’inclure que des informations de la période indiquée
dans les statiques.

Certaines informations du rapport utiliseront toutes les données
collectées jusqu’au moment de créer le rapport–par exemple, le progrès
de collecte et les tendances dans certains tableaux.

### Lancer le programme

Deux cas de figure se présentent:

-   [Avec téléchargement automatisé des données](#avec)
-   [Sans téléchargement automatisé](#sans)

#### Avec

Si l’on peut (veut) automatiser le téléchargement des données, voici la
procédure:

-   Ouvrir le fichier `ehcvm2_rapport_suivi.Rproj`
-   Ouvrir le fichier `creer_rapport_suivi.R`
-   Lancer le programme en cliquant sur le bouton `Source`

#### Sans

Si l’on ne peut (veut) pas automatiser le télécharment, suivre cette
démarche:

-   Ouvrir le fichier `ehcvm2_rapport_suivi.Rproj`
-   Ouvrir le fichier `creer_rapport_suivi.R`
-   Exécuter le programme `creer_rapport_suivi.R` bloc par bloc

En plus de détail:

-   **Spécifier les paramètres.** Sélectionner les lignes 1 à 182 et
    cliquer sur `Run` dans l’interface de RStudio
-   **Télécharger les bases ménages manuellement.** Sauvgarder les
    fichiers zip dans `/data/hhold/01_downloaded/`
-   **Décomprimer les zip et joindre les bases.** Sélectionner la ligne
    194 et sur `Run` dans l’interface de RStudio. En particulier:
    `source(paste0(script_dir, "unpack_and_combine_hhold.R"))`
-   **Télécharger les bases communautaire manuellement.** Sauvgarder les
    fichiers zip dans `/data/community/01_downloaded/`
-   **Décomprimer les zip et joindre les bases.** Sélectionner la ligne
    20è et sur `Run` dans l’interface de RStudio. En particulier:
    `source(paste0(script_dir, "unpack_and_combine_community.R"))`
