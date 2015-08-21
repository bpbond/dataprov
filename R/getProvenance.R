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
provenance <- function(x, n = NULL, env = .GlobalEnv) {

  if(is.null(attr(x, "provenance"))) {
    stop("No provenance found")
  }

  # Get the relevant provenance
  provlist <- get(".provenance_list", env = env)
  assert_that(is.list(provlist))
  prov <- provlist[[attr(x, "provenance")]]

  # Return the whole data frame, or just a row
  if(is.null(n)) {
    prov
  } else {
    assert_that(n > 0)
    as.list(prov[n,])
  }
} # provenance



#' List provenances.
#'
#' List provenances.
#'
#' @param env Environment to look in for provenances (optional)
#' @return A data frame listing any provences found
#' @export
listProvenances <- function(env = .GlobalEnv) {
  if(exists(".provenance_list", env = env)) {
    provlist <- get(".provenance_list", env = env)
    d <- data.frame(do.call('rbind', strsplit(names(provlist), '_', fixed=TRUE)))
    names(d) <- c("Object", "Creation")
    #d$Creation <- as.POSIXct(d$Creation, origin="1970-01-01")
    d$Entries <- unlist(lapply(provlist, nrow))
    d
  }
} # listProvenances
