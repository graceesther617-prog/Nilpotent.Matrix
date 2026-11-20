\name{analyze_advanced_markov}
\alias{analyze_advanced_markov}
\title{Advanced Markov Chain Analysis for Predictive Maintenance}
\usage{
analyze_advanced_markov(df, wear_col, failure_cols, n_bins = 4)
}
\arguments{
\item{df}{A data frame containing the dataset.}

\item{wear_col}{Character string for the continuous wear column. Default is "Tool_wear_min".}

\item{failure_cols}{Character vector of absorbing failure columns. Default is c("TWF", "HDF", "PWF", "OSF").}

\item{n_bins}{Integer specifying the number of discrete wear stages. Default is 4.}
}
\value{
A list containing matrices (P, Q, R), nilpotency test results, fundamental matrix N, survival times, and dominant failures.
}
\description{
Advanced Markov Chain Analysis for Predictive Maintenance
}
