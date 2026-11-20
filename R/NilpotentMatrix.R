#' Advanced Markov Chain Analysis for Predictive Maintenance
#'
#' @param df A data frame containing the dataset.
#' @param wear_col Character string for the continuous wear column. Default is "Tool_wear_min".
#' @param failure_cols Character vector of absorbing failure columns. Default is c("TWF", "HDF", "PWF", "OSF").
#' @param n_bins Integer specifying the number of discrete wear stages. Default is 4.
#'
#' @return A list containing matrices (P, Q, R), nilpotency test results, fundamental matrix N, survival times, and dominant failures.

analyze_advanced_markov <- function(df, wear_col, failure_cols, n_bins = 4) {
  # Discretize continuous wear into ordered stages
  df$wear_stage <- as.numeric(cut(df[[wear_col]], breaks = n_bins, labels = FALSE))

  states <- sort(unique(df$wear_stage))
  n_transient <- length(states)
  n_absorbing <- length(failure_cols)
  total_states <- n_transient + n_absorbing

  # Initialize global transition matrix P
  P <- matrix(0, nrow = total_states, ncol = total_states)

  # Fill transitions for all transient stages except the last
  for (i in 1:(n_transient - 1)) {
    current_subset <- dplyr::filter(df, wear_stage == states[i])
    total_count <- nrow(current_subset)

    if (total_count > 0) {
      failures_count <- sapply(failure_cols, function(col) sum(current_subset[[col]] == 1))
      total_failures <- sum(failures_count)

      # Fill competing risks (Matrix R component)
      for (j in 1:n_absorbing) {
        P[i, n_transient + j] <- failures_count[j] / total_count
      }

      # Fill survival transition to the next wear stage (Matrix Q component)
      p_survival <- max(0, 1 - (total_failures / total_count))
      P[i, i + 1] <- p_survival
    }
  }

  # Handle the final most critical transient stage
  last_subset <- dplyr::filter(df, wear_stage == states[n_transient])
  last_total <- nrow(last_subset)

  if (last_total > 0) {
    last_failures <- sapply(failure_cols, function(col) sum(last_subset[[col]] == 1))
    for (j in 1:n_absorbing) {
      P[n_transient, n_transient + j] <- last_failures[j] / max(1, last_total)
    }
    if (sum(P[n_transient, (n_transient + 1):total_states]) == 0) {
      P[n_transient, n_transient + 1] <- 1.0
    }
  }

  # Set absorbing states as permanent barriers (identity block)
  for (j in 1:n_absorbing) {
    row_idx <- n_transient + j
    P[row_idx, row_idx] <- 1.0
  }

  # Extract Q (transient) and R (competing failures) sub-matrices
  Q <- P[1:n_transient, 1:n_transient]
  R <- P[1:n_transient, (n_transient + 1):total_states]

  # Test nilpotency of Q (Q^k = 0) and find index k
  is_nilpotent <- FALSE
  nilpotency_index <- NA
  Q_power <- Q

  for (k in 1:(n_transient + 1)) {
    if (all(abs(Q_power) < 1e-12)) {
      is_nilpotent <- TRUE
      nilpotency_index <- k
      break
    }
    Q_power <- Q_power %*% Q
  }

  # Compute fundamental matrix N (exact sum or inverse)
  I_mat <- diag(1, n_transient)
  N_mat <- I_mat
  if (is_nilpotent && nilpotency_index > 1) {
    Q_curr <- Q
    for (m in 1:(nilpotency_index - 1)) {
      N_mat <- N_mat + Q_curr
      Q_curr <- Q_curr %*% Q
    }
  } else {
    N_mat <- solve(I_mat - Q)
  }

  # Identify the dominant failure mode for each wear stage from R
  dominant_failure_indices <- apply(R, 1, which.max)
  dominant_failure_names <- failure_cols[dominant_failure_indices]

  return(list(
    P_matrix = P,
    Q_matrix = Q,
    R_matrix = R,
    is_nilpotent = is_nilpotent,
    nilpotency_index = nilpotency_index,
    fundamental_matrix = N_mat,
    expected_survival_time = rowSums(N_mat),
    dominant_failures = dominant_failure_names
  ))
}
