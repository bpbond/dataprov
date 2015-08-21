#' Create provenance for an object.
#'
#' Create provenance information for an object.
#'
#' @param x An object
#' @param env Environment in which to create provenance information (optional)
#' @return x, with a new `provenance` attribute
#' @export
#' @examples
#' d <- updateProvenance(cars, "first message")
#' d <- updateProvenance(d, "second message")
#' provenance(d)
createProvenance <- function(x, env = .GlobalEnv) {

  # If `x` has a 'provenance' attribute, there's an existing provenance
  if(!is.null(attr(x, "provenance")) & exists(".provenance_list", env = env)) {
    stop("Provenance already exists")
  }

  # If not, create an attribute from x's name and current time, hopefully a unique combination
  xname <- deparse(substitute(x))
  provname <- paste(xname, unclass(Sys.time()), sep="_")
  attr(x, "provenance") <- provname

  # If the provenance list doesn't exist in global environment, create it
  if(!exists(".provenance_list", env = env)) {
    message("Creating provenance list")
    assign(".provenance_list", list(), env = env)
  }

  provlist <- get(".provenance_list", env = env)
  assert_that(is.list(provlist))
  assert_that(is.null(provlist[[provname]]))  # shouldn't be anything existing

  provlist[[provname]] <- dataprov()
  assign(".provenance_list", provlist, env = env)
  x
} # createProvenance

#' Replace entire provenance.
#'
#' Replace entire provenance.
#'
#' @param x An object.
#' @param p A data frame that includes the required provenance fields (see \code{\link{provenance}}):
#' @return x, with provenance set to contents of p
#' @keywords internal
replaceProvenance <- function(x, newp, env = .GlobalEnv) {

  oldp <- provenance(x, env = env)
  assert_that(is.data.frame(oldp))

  # Check that newp is a valid data frame
  assert_that(is.data.frame(newp))
  pnames <- names(oldp)
  if(!all(pnames %in% names(newp))) {
    stop(paste("Must have required fields:", paste(pnames, collapse=", ")))
  }

  # Create new provenance data frame and associate with x
  newp$timestamp = as.POSIXct(newp$timestamp)
  newp$caller = as.character(newp$caller)
  newp$message = as.character(newp$message)
  newp$digest = as.character(newp$digest)

  provlist <- get(".provenance_list", env = env)
  provlist[[attr(x, "provenance")]] <- newp

  # TODO: why is this line necessary? I've gotten provlist above, and put a new entry into it...why not reflected in .GlobalEnv?
  assign(".provenance_list", provlist, env = env)
} # replaceProvenance

# ---- I don't think this functionality should be public...
# `provenance<-` <- function(x, value) {
#   replaceProvenance(x, value)
#   x
# }

