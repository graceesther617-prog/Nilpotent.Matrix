#==========RESULTATS============

results <- analyze_advanced_markov(nasa_clean,wear_col = "Tool_wear_min", failure_cols = c("TWF", "HDF", "PWF", "OSF"))
analyze_advanced_markov <- function(df, wear_col = "Tool_wear_min", failure_cols = c("TWF", "HDF", "PWF", "OSF"), n_bins = 4)

cat("--- RÉSULTATS DE L'ANALYSE MARKOVIENNE ---\n\n")
cat("1. Sous-matrice Q :\n")
print(round(results$Q_matrix, 4))

cat("\n2. Matrice R des risques compétitifs :\n")
print(round(results$R_matrix, 4))

cat("\n3. Nilpotence de Q :", results$is_nilpotent, "| Indice k :", results$nilpotency_index, "\n")

cat("\n4. Temps moyen de survie estimé :\n")
print(round(results$expected_survival_time, 2))

cat("\n5. Panne dominante par stade :\n")
print(results$dominant_failures)
