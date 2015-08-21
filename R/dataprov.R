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
#' @internal
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
#' @method print dataprov
#' @export
#' @keywords internal
print.provenance <- function(x, ...) {
  x$caller <- paste0(substr(x$caller, 1, 12), "...")
  x$message <- paste0(substr(x$message, 1, 20), "...")
  x$digest <- paste0(substr(x$digest, 1, 8), "...")
  print(as.data.frame(x)) # TODO - only add elpises for over-length strings
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
