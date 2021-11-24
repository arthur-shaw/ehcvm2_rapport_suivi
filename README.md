
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ehcvm2\_rapport\_suivi

<!-- badges: start -->
<!-- badges: end -->

# Objectif

Le programme a pour vocation de créer un rapport de suivi pour deux
groupes d’indicateurs de suivi:

-   Progrès
-   Qualité

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

#### Dates du rapport

Mettre les dates de début et de fin dans `rapport_debut` et
`rapport_fin`, respectivement.

Pour les dates, suivre le format ISO 8601: `AAAA-MM-JJ`.

``` r
  # PÉRIODE DU RAPPORT: DÉBUT ET FIN
  # pour les dates,  mettre dans le format ISO 8601: AAAA-MM-JJ
  # par exemple, "2021-11-25" pour le 25 novembre, 2021
  rapport_debut   = "",
  rapport_fin     = "",
```

#### Répertoire du programme de rejet

Comme le rapport va puiser dans les bases du programme de rejet, il faut
indiquer le chemin du répertoire racine du programme de rejet.

Le rapport se sert de ces bases, entre autres. Dans le répertoire des
bases fusionnées:

-   menage.dta
-   membres.dta
-   parcelles.dta
-   interview\_\_comments.dta

Dans le répertoire des bases dérivées:

-   calories\_totales.dta
-   calories\_par\_item.dta

Dans le répertoire des sorties:

-   to\_reject\_issues.dta

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

### Utiliser le programme de rejet

Comme le rapport utilise les bases acquises et créées par le programme
de rejet, lancer le programme de rejet avant de lancer créer le rapport.
Ceci fournira au rapport les données les plus récentes.

### Modifier les dates du rapport

Avant de créer le rapport, modifier les dates du début et de fin de la
période du rapport. Ces informations servent à trier les informations du
rapport et ainsi n’inclure que des informations de la période indiquée.
