% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/file_sorting.R
\name{sort_files}
\alias{sort_files}
\title{Sorts files after corrections}
\usage{
sort_files(data.folders, results.folder, move = FALSE)
}
\arguments{
\item{data.folders}{Character vector containing full folder paths of folders to check. This list must be sorted
according to the chronology of previous file editing. If a measurement exists in the last folder,
this is copied or moved into the \code{results.folder}, and files of the same measurement located in the
other folders will be ignored. Hence, the one file per measurement that underwent most correction steps
will be stored in the \code{results.folder}, while the rest of the files of the same measurement remain in place.}

\item{results.folder}{Character string defining the full path to the folder where the desired files will be stored.}

\item{move}{A logical value specifying if files should be moved (\code{move = TRUE}) or copied (\code{move = FALSE}). Default: \code{FALSE}.}
}
\value{
This functions does not create new files but sorts existing files. It does, however, create the \code{results.folder}
in case it did not exist before.
}
\description{
The files of each of the various possible correction steps (cropping, amplififer correction, drift correction)
are all located in their own folders. This function gets all files that represent the last correction step of a
given measurement out of all those folders and saves them in the \code{results.folder}.
}
\details{
The function will look for leading numbers in the file names specifying the measurement number to find corresponding
files in the different folders. E.g., it will identify "0001_ABCD.csv", "0001_ABCD_ampdriftcorr.csv", and
"0001_ABCD_ampdriftcorr_baselincorr.csv" as stemming from the same measurement and sort them accordingly.
}
\examples{
# define data.folders
data.folders <- c("./raw",
                   "./cropped",
                   "./ampdriftcorr",
                   "./baselinecorr")

# define the folder in which one corrected file per original raw measurement
#   should be stored.
results.folder <- "./corrected"

# run the file sorting - commented out to pass package tests
# sort_files(data.folders = data.folders,
#               results.folder = results.folder,
#               move = FALSE)
}
