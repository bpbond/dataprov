#' Get provenance.
#'
#' Get provenance information of an object.
#'
#' @param x An object
#' @param n The line of the provenance to return as a list (optional)
#' @return A provenance object, as a data frame, with one row for each operation and four columns:
#'  \item{timestamp}{Date and time entry was added}
#'  \item{caller}{The function that added this entry, including its parameter values}
#'  \item{message}{Description of action(s) taken}
#'  \item{digest}{Hash of the data when this entry was added; see \code{\link{digest}}}
#' @export
#' @examples
#' d <- updateProvenance(cars, "first message")
#' d <- updateProvenance(d, "second message")
#' provenance(d)
provenance <- function(x, n = NULL) {
  p <- attr(suppressWarnings(x), "provenance")

  if(is.null(n)) {
    p
  } else {
    assert_that(n > 0)
    as.list(p[n,])
  }
} # getProvenance

#' Replace entire provenance.
#'
#' Replace entire provenance.
#'
#' @param x An object.
#' @param p A data frame that includes the required provenance fields (see \code{\link{provenance}}):
#' @return x, with provenance set to contents of p
#' @export
#' @examples
#' d1 <- updateProvenance(cars, "first d1 message")
#' d2 <- updateProvenance(cars, "first d2 message")
#' d1 <- replaceProvenance(d1, provenance(d2))
#' provenance(d)
replaceProvenance <- function(x, p) {
  # Check that p is a valid data frame
  reqfields <- c("timestamp", "caller", "message", "digest")
  if(!all(reqfields %in% names(p))) {
    stop(paste("'p' must have required fields:", paste(reqfields, collapse=", ")))
  }

  # Create new provenance data frame and associate with x
  p$timestamp = as.POSIXct(p$timestamp)
  p$caller = as.character(p$caller)
  p$message = as.character(p$message)
  p$digest = as.character(p$digest)
  attr(x, "provenance") <- rbind(dataprov(), p)
  x
} # replaceProvenance
