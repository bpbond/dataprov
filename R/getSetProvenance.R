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
provenance <- function(x, n = NULL, env = parent.frame()) {

  # If the provenance list doesn't exist in parent frame, create it
  if(!exists(".provenance", env = env)) {
    assign(".provenance", list(), env = env)
  }

  # Get the relevant provenance
  provlist <- get(".provenance", env = env)
  if(!is.character(x)) {
    x <- deparse(substitute(x))
  }
  prov <- provlist[[x]]

  # Return the whole data frame, or just a row
  if(is.null(n)) {
    prov
  } else {
    assert_that(n > 0)
    as.list(prov[n,])
  }
} # provenance

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
#' provenance(d1) <- provenance(d2)
#' provenance(d1)
`provenance<-` <- function(x, value) {
  replaceProvenance(deparse(substitute(x)), value, env = parent.frame())
  x
}

#' Replace entire provenance.
#'
#' Replace entire provenance.
#'
#' @param x An object.
#' @param p A data frame that includes the required provenance fields (see \code{\link{provenance}}):
#' @return x, with provenance set to contents of p
#' @keywords internal
replaceProvenance <- function(x, newp, env = parent.frame()) {

  # Check that newp is a valid data frame
  assert_that(is.data.frame(newp))
  pnames <- names(dataprov())
  if(!all(pnames %in% names(newp))) {
    stop(paste("Must have required fields:", paste(pnames, collapse=", ")))
  }

  # Create new provenance data frame and associate with x
  newp$timestamp = as.POSIXct(newp$timestamp)
  newp$caller = as.character(newp$caller)
  newp$message = as.character(newp$message)
  newp$digest = as.character(newp$digest)

  if(!is.character(x)) {
    x <- deparse(substitute(x, env = env))
  }

  provlist <- get(".provenance", env = env)
  provlist[[x]] <- newp
  assign(".provenance", provlist, env = env)
} # replaceProvenance
