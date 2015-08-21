#' Easy Data Provenance Tracking
#'
#' *Data provenance* broadly refers to a description of the origins of a piece
#' of data and the process by which it arrived in a database or analysis.
#' This package implements a simple system for tracking operations performed
#' on any R object.
#'
#' ...
#'
#' @references Todd-Brown and Bond-Lamberty, 2014: (in prep).
#' @import digest assertthat
#' @docType package
#' @name dataprov
NULL

#' The 'dataprov' class
#'
#' Constructor.
#'
#' @return A dataprov object, which is a data frame with the following fields:
#'  \item{files}{Array of strings containg the file(s) included in this dataset}
#'  \item{variable}{String containg the variable name described by this dataset}
#'  \item{model}{String containing the model name of this dataset}
#'  \item{experiment}{String containing the experiment name of this dataset}
#'  \item{ensembles}{Array of strings containg the ensemble(s) included in this dataset}
#'  \item{domain}{String containing the domain name of this dataset}
#'  \item{val}{Data frame holding data, with fields lon, lat, Z, time}
#'  \item{valUnit}{String containing the value units}
#'  \item{lon}{Numeric vector containing longitude values; may be \code{NULL}}
#'  \item{lat}{Numeric vector containing latitude values; may be \code{NULL}}
#'  \item{Z}{Numeric vector Z values; may be \code{NULL}}
#'  \item{time}{Numeric vector containing time values; may be \code{NULL}}
#'  \item{dimNames}{Array of strings containing the original (NetCDF) dimension names}
#'  \item{calendarStr}{String defining the calendar type; may be \code{NULL}}
#'  \item{debug}{List with additional data (subject to change)}
#'  \item{provenance}{Data frame with the object's provenance. See \code{\link{addProvenance}}}
#'  \item{numPerYear}{Numeric vector; only present after \code{\link{makeAnnualStat}}}
#'  \item{numYears}{Numeric vector; only present after \code{\link{makeMonthlyStat}}}
#'  \item{numCells}{Numeric vector; only present after \code{\link{makeGlobalStat}}}
#'  \item{filtered}{Logical; only present after \code{\link{filterDimensions}}}
#' @docType class
#' @internal
dataprov <- function() {
  data.frame(
    timestamp=as.Date(character()),
    caller=character(),
    message=character(),
    digest=character(),
    stringsAsFactors=F
  )
}

#' Print a 'dataprov' class object.
#'
#' @param x A \code{\link{dataprov}} object
#' @param ... Other parameters passed to cat
#' @details Prints a one-line summary of the object
#' @method print dataprov
#' @export
#' @keywords internal
print.dataprov <- function(x, ...) {
  print(dataprov) # TODO
} # print.dataprov

#' Summarize a 'dataprov' class object.
#'
#' @param object A \code{\link{dataprov}} object
#' @param ... ignored
#' @details Prints a short summary of the object.
#' @return A summary structure of the object.
#' @method summary dataprov
#' @export
#' @keywords internal
summary.dataprov <- function(object, ...) {
  summary(object)  # TODO
} # summary.dataprov
