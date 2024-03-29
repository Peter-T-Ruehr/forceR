% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/drift_corrections_03.R
\name{amp_drift_corr}
\alias{amp_drift_corr}
\title{Charge Amplifier Drift Correction}
\usage{
amp_drift_corr(
  filename,
  tau = 9400,
  res.reduction = 10,
  plot.to.screen = FALSE,
  write.data = FALSE,
  write.PDFs = FALSE,
  write.logs = FALSE,
  output.folder = NULL,
  show.progress = FALSE
)
}
\arguments{
\item{filename}{Path to file on which amplifier drift correction should be
performed.}

\item{tau}{Numeric time constant of charge amplifier in the same time unit
as the measurement data.
Default: \code{9400}}

\item{res.reduction}{A numeric value to reduce the number of time steps by
during plotting. Speeds up
the plotting process and reduces PDF size. Has no effect on the results,
only on the plots. Default: \code{10}.}

\item{plot.to.screen}{A logical value indicating if results should be
plotted in the current R plot device. Default: \code{FALSE}.}

\item{write.data}{A logical value indicating if drift-corrected file should
be saved. If yes, it will be saved in \code{output.folder}.
Default: \code{FALSE}.}

\item{write.PDFs}{A logical value indicating whether results should be saved
as PDFs. Does not slow
down the process as much as printing to the R plot device and is considered
necessary to quality check the results. If yes, it will be saved in
\code{output.folder/PDFs}. Default: \code{FALSE}.}

\item{write.logs}{A logical value indicating whether a log file with
information on the method and values used to correct the amplifier drift should be
saved. Is considered necessary for reproducibility. If yes, it will be saved
in \code{output.folder/logs}. Default: \code{FALSE}.}

\item{output.folder}{Path to folder where data, PDF and log files should
be stored.}

\item{show.progress}{A logical value indicating if progress should be
printed to the console. Slows down the process. Default: \code{FALSE}.}
}
\value{
Returns a tibble containing the amplifier drift-corrected data in the
following format\tabular{ccc}{
   \code{t} \tab  \tab \code{y} \cr
   \code{t.1} \tab  \tab \code{y.2} \cr
   \code{...} \tab  \tab \code{...} \cr
   \code{t.n} \tab  \tab \code{y.n} \cr
}
}
\description{
Removes the systemic, asymptotical drift of charge amplifiers with
resistor-capacitor (RC) circuits.
}
\details{
forceR generally expects file names to start with a leading number specifying the
measurement number (E.g. "0001_G_maculatus.csv"). The number ("0001") is used to
keep data files, log files, and PDF files of the same measurement associated
with each other.

The input file should be in the following format:\tabular{ccc}{
   \code{t} \tab  \tab \code{y} \cr
   \code{t.1} \tab  \tab \code{y.2} \cr
   \code{...} \tab  \tab \code{...} \cr
   \code{t.n} \tab  \tab \code{y.n} \cr
}
}
\examples{
# define file for amplifier drift correction
filename <- forceR_example(type = "raw")

# Run amplifier drift correction without saving files or printing to screen:
file.ampdriftcorr <- amp_drift_corr(filename = filename,
                                     tau = 9400,
                                     res.reduction = 10,
                                     plot.to.screen = FALSE,
                                     write.data = FALSE,
                                     write.PDFs = FALSE,
                                     write.logs = FALSE,
                                     output.folder,
                                     show.progress = FALSE)
# file.ampdriftcorr

# Run amplifier drift correction with saving files and printing to screen:
#    - commented out to pass package tests
# file.ampdriftcorr <- amp_drift_corr(filename = filename,
#                                       tau = 9400,
#                                       res.reduction = 10,
#                                       plot.to.screen = TRUE,
#                                       write.data = TRUE,
#                                       write.PDFs = TRUE,
#                                       write.logs = TRUE,
#                                       output.folder = "./ampdriftcorr",
#                                       show.progress = TRUE)
#
# file.ampdriftcorr

}
