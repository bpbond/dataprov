#' Get provenance.
#'
#' Get provenance.
#'
#' @param x An object
#' @param caller The function name to be recorded. Optional
#' @return A provenance object, as a data frame, with one row for each operation and X columns:
#'  \item{timestamp}{Date and time entry was added}
#'  \item{caller}{The function that added this entry, including its parameter values}
#'  \item{message}{Description of action(s) taken}
#'  \item{digest}{Hash of the data when this entry was added; see \code{\link{digest}}}
#' @export
#' @examples
#' # TODO
provenance <- function(x) {
  attr(suppressWarnings(x), "provenance")
} # getProvenance

#' Set provenance.
#'
#' Set provenance.
#'
#' @param x An object.
#' @param p A data frame with the following required fields: (TODO)
#' @return x, with provenance set to contents of p
#' @export
#' @examples
#' # TODO
replaceProvenance <- function(x, p) {

  # TODO - check that p is a valid data frame

  attr(suppressWarnings(x), "provenance") <- p
  x
} # getProvenance
