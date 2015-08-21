#' Add provenance information to an object
#'
#' It's important to track data provenance, the steps taken to produce a particular
#' dataset.
#'
#' @param x An R object
#' @param message A string (message to be added to the provenance)
#' @param caller The calling function name (automatically filled in if NULL)
#' @return The original object, with an updated provenance containing:
#'  \item{timestamp}{Date and time entry was added}
#'  \item{caller}{The function that added this entry, including its parameter values}
#'  \item{message}{Description of action(s) taken}
#'  \item{digest}{Hash of the data when this entry was added; see \code{\link{digest}}}
#' This function logs information from the caller to a 'provenance' data structure that is
#' attached as an attribute of \code{x}.
#' @examples
#' d <- updateProvenance(cars, "first message")
#' d <- updateProvenance(d, "second message")
#' provenance(d)
#' @export
updateProvenance <- function(x, message, caller=NULL) {

  # Sanity checks
  assert_that(is.character(message))
  assert_that(is.null(caller) | is.character(caller))

  prov <- provenance(deparse(substitute(x)), env = parent.frame())
  if(is.null(prov)) { # then create a new provenance
    prov <- dataprov()
  }

  # Calculate necessary information for a new provenance entry
  assert_that(is.data.frame(prov))
  nr <- nrow(prov) + 1

  # Get calling function's call (its name and parameters) if available
  if(is.null(caller)) {
    caller <- NA
    try({
      caller <- match.call(definition = sys.function(-1), call = sys.call(-1))
      caller <- gsub(" ", "", paste(capture.output(caller), collapse=""))
      caller <- gsub("\\\"", "'", caller)
    }, silent = TRUE)
  }

  # Trim multiple spaces
  # from http://stackoverflow.com/questions/14737266/removing-multiple-spaces-and-trailing-spaces-using-gsub
  msg <- gsub("^ *|(?<= ) | *$", "", message, perl = TRUE)

  # Remove artifacts for prettier code in message
  msg <- gsub("{;", "{", msg, fixed = TRUE)
  msg <- gsub("; }", " }", msg, fixed = TRUE)

  dg <- NA
  try({
    dg <- digest::digest(x)
  } , silent = TRUE)

  # Add new entry to provenance and return
  prov[nr, "timestamp"] <- Sys.time()
  prov[nr, "digest"] <- dg
  prov[nr, "caller"] <- caller
  prov[nr, "message"] <- msg

#  provenance(x) <- prov
  replaceProvenance(deparse(substitute(x)), prov, env = parent.frame())
} # updateProvenance
