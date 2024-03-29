% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalization.R
\name{avg_peaks}
\alias{avg_peaks}
\title{Average Curves per Group}
\usage{
avg_peaks(df, path.data = NULL)
}
\arguments{
\item{df}{The resulting tibble of the function \code{red_peaks_100()}. See \code{?red_peaks_100} for more details.}

\item{path.data}{A string character defining where to save the results.
If \code{NULL}, data will not be saved to disk. Default: \code{NULL}.}
}
\value{
This function returns a tibble made of three columns: \code{species} containing the species names, \code{index} ranging from 1 to 100 for each species,
and \code{force.norm.100} containing the averaged and rescaled curve of each species.
}
\description{
Calculates mean curve shape per group (here: species) and rescales result on the y axis to range from 0 to 1.
}
\examples{
# Using the forceR::df.all.200.tax dataset:

# calculate mean curves per species
peaks.df.100.avg <- avg_peaks(df = forceR::peaks.df.norm.100,
                               path.data = NULL)
\donttest{
# plot averaged normalized curves per species
require(ggplot2)
ggplot(peaks.df.100.avg,
          aes(x = index ,
               y = force.norm.100.avg,
               colour=species)) +
  geom_line()
}
}
