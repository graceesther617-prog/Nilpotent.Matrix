# Nilpotent.Matrix

Modélisation de la dégradation et de la maintenance prédictive par chaînes de Markov absorbantes nilpotentes, appliquée au jeu de données **AI4I 2020** (`Tool_wear_min` et modes de défaillance `TWF`, `HDF`, `PWF`, `OSF`).

## Principe méthodologique

- **Discrétisation de l'usure :** découpage de la variable continue (`Tool_wear_min`) en `n_bins = 4` stades d'usure d'amplitude égale (`cut(..., breaks = n_bins, labels = FALSE)`).
- **Matrice de transition canonique $P$ :** sépare les transitions internes entre stades transitoires (bloc $Q$), les transitions vers les modes de panne absorbants (bloc $R$) et les états absorbants permanents.
- **Nilpotence et série de Neumann finie :** lorsque $Q^k = 0$ (indice de nilpotence $k$, par exemple $k = 4$), la matrice fondamentale se calcule exactement par :
  $$N = I + Q + Q^2 + \dots + Q^{k-1}$$
- **Indicateurs de décision :** survie moyenne restante par stade (`rowSums(N)`) et mode de défaillance dominant (`dominant_failures` via le bloc $R$).

## Installation (en développement)

```r
# Depuis le dossier racine du package Nilpotent.Matrix
devtools::load_all()
# Ou installation locale :
# install.packages(".", repos = NULL, type = "source")
