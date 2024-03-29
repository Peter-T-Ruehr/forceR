% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/peak_finding.R
\name{peak_duration_max_force}
\alias{peak_duration_max_force}
\title{Peak Duration and Maximum Force}
\usage{
peak_duration_max_force(
  df.peaks,
  df.data,
  path.data = NULL,
  show.progress = FALSE
)
}
\arguments{
\item{df.peaks}{The resulting tibble of the function \code{find_peaks()}. See \code{?find_peaks} for more details.}

\item{df.data}{A data frame or tibble in the below format. The columns \code{t} (time), \code{force}, \code{measurement}, and \code{specimen}.
(measurement ID) must be present. This will usually be the same table that was used before in \code{find_peaks()}.}

\item{path.data}{A string character defining where to save the results. If \code{NULL} (default),
data is not stored in a file.}

\item{show.progress}{A logical value indicating if progress should be
printed to the console. Default: \code{FALSE}.}
}
\value{
Changes values within \code{df.peaks} and returns the changed tibble.
}
\description{
Calculate duration and maximum force for each individual peak.
}
\section{\code{df.data} needs to contain the following columns:}{
\tabular{ccc}{
   \strong{\code{t}} \tab \strong{\code{force}} \tab \strong{\code{measurement}} \cr
   \code{t.1} \tab \code{force.1} \tab \code{measurement.1} \cr
   \code{...} \tab \code{...} \tab \code{...} \cr
   \code{t.n} \tab \code{force.n} \tab \code{measurement.m} \cr
}
}

\examples{
# Using the forceR::df.all.200.tax dataset:
\donttest{
# This function needs user input.
peaks.df <- correct_peak(df.peaks = forceR::peaks.df,
                        df.data = forceR::df.all.200.tax,
                        measurement = "m_01",
                        peak = 1,
                        additional.msecs = 5)
}
}
