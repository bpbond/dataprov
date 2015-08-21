#' Easy Data Provenance Tracking
#'
#' *Data provenance* broadly refers to a description of the origins of a piece
#' of data and the process by which it arrived in a database or analysis.
#' This package implements a simple system for tracking operations performed
#' on any R object.
#'
#' @import digest assertthat
#' @docType package
#' @name dataprov
NULL

#' The 'dataprov' class
#'
#' Constructor.
#'
#' @return A dataprov object, which is a data frame with the following fields for each entry (row):
#'  \item{timestamp}{A timestamp of the entry; see \code{\link{DateTimeClasses}}}
#'  \item{caller}{Name of the function that added this entry}
#'  \item{message}{Message describing the operation}
#'  \item{digest}{MD5 hash of the parent object as entry was made}
#' @docType class
#' @keywords internal
dataprov <- function() {
  d <- data.frame(
    timestamp = as.POSIXct(character()),
    caller = character(),
    message = character(),
    digest = character(),
    stringsAsFactors = F
  )
  class(d) <- c("provenance", class(d))
  d
} # dataprov

#' Print a 'dataprov' class object.
#'
#' @param x A \code{\link{dataprov}} object
#' @param ... Other parameters passed to cat
#' @details Prints a one-line summary of the object
#' @method print provenance
#' @export
#' @keywords internal
print.provenance <- function(x, ...) {

  # Pretty print - shorten fields that are likely to be long
  shorten <- function(x, maxc, term = "...") {
    if(nchar(x) > maxc) paste0(substr(x, 1, maxc - nchar(term)), term)
    else x
  }

  x$caller <- unlist(lapply(x$caller, shorten, maxc = 20))
  x$message <- unlist(lapply(x$message, shorten, maxc = 30))
  x$digest <- unlist(lapply(x$digest, shorten, maxc = 8, term=""))

  print(as.data.frame(x))
} # print.dataprov
