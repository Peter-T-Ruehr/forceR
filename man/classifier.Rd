% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{classifier}
\alias{classifier}
\title{Classifier}
\format{
A data frame with 24 rows and 5 columns:
\describe{
\item{species}{species names}
\item{specimen}{specimen names}
\item{measurement}{measurement names}
\item{amp}{amplifier values, in V/N}
\item{lever.ratio}{ration of on-lever to out-lever of mesaurement setup}
}
}
\usage{
classifier
}
\description{
Start and end time values of the 5 strongest peaks per species of \code{df.all}
with the names of the measurements in which they occur.
}
\details{
Result of \code{rescale_peaks()}.
}
\keyword{datasets}
