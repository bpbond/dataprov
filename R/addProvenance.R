#' Add provenance information to an object
#'
#' It's important to track data provenance, the steps taken to produce a particular
#' dataset.
#'
#' @param x An R object
#' @param message A string (message to be added to the provenance)
#' @param caller The calling function (automatically filled in if NULL)
#' @return The original object, with an updated provenance containing:
#'  \item{timestamp}{Date and time entry was added}
#'  \item{caller}{The function that added this entry, including its parameter values}
#'  \item{message}{Description of action(s) taken}
#'  \item{digest}{Hash of the data when this entry was added; see \code{\link{digest}}}
#' This function logs information from the caller to a 'provenance' data structure.
#' @export
addProvenance <- function(x, message, caller=NULL) {

  # Sanity checks
  assert_that(is.character(message))

  prov <- attr(x, "provenance")
  if(is.null(prov)) { # then create a new provenance
    prov <- dataprov()
  }

  # Add to the provenance data structure. Two cases: msg is a string containing
  # actual message; or it's another cmip5 data object, in which case we want to
  # append its provenance to that of x.
  assert_that(is.data.frame(prov))
  nr <- nrow(prov) + 1

  # Get calling function's call (its name and parameters)
  if(is.null(caller)) {
    caller <- NA
    try({
      caller <- match.call(definition=sys.function(-1), call=sys.call(-1))
      caller <- gsub(" ", "", paste(capture.output(caller), collapse=""))
      caller <- gsub("\\\"", "'", caller)
    }, silent=TRUE)
  }

  # Trim multiple spaces
  # from http://stackoverflow.com/questions/14737266/removing-multiple-spaces-and-trailing-spaces-using-gsub
  msg <- gsub("^ *|(?<= ) | *$", "", message, perl=T)

  # Remove artifacts for prettier code in message
  msg <- gsub("{;", "{", msg, fixed = TRUE)
  msg <- gsub("; }", " }", msg, fixed = TRUE)

  dg <- "<digest unavailable>"
  try({
    dg <- digest::digest(x$val)
  } , silent=TRUE)

  # Add new entry to provenance and return
  prov[nr, "timestamp"] <- Sys.time()
  prov[nr, "digest"] <- dg
  prov[nr, "caller"] <- caller
  prov[nr, "message"] <- msg

  attr(x, "provenance") <- prov
  x
} # addProvenance
