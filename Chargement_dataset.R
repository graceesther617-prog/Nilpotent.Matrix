library(dplyr)

# 1. Chargement du dataset AI4I 2020 (ou simulation de secours)
if (file.exists("ai4i2020.csv")) {
  ai4i_raw <- read.csv("ai4i2020.csv")
} else {
  set.seed(42)
  n_rows <- 10000
  ai4i_raw <- data.frame(
    Tool_wear_min = sample(0:250, n_rows, replace = TRUE),
    TWF = sample(c(0, 1), n_rows, replace = TRUE, prob = c(0.99, 0.01)),
    HDF = sample(c(0, 1), n_rows, replace = TRUE, prob = c(0.98, 0.02)),
    PWF = sample(c(0, 1), n_rows, replace = TRUE, prob = c(0.99, 0.01)),
    OSF = sample(c(0, 1), n_rows, replace = TRUE, prob = c(0.99, 0.01))
  )
}

# 2. Harmonisation des noms de colonnes et nettoyage
clean_ai4i_data <- function(df) {
  names(df) <- gsub("\\.+", "_", names(df))
  names(df) <- sub("_$", "", names(df))

  df_clean <- subset(df, !is.na(Tool_wear_min) &
                       !is.na(TWF) & !is.na(HDF) &
                       !is.na(PWF) & !is.na(OSF))
  return(df_clean)
}

nasa_clean <- clean_ai4i_data(ai4i_raw)
