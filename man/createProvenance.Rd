% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/setProvenance.R
\name{createProvenance}
\alias{createProvenance}
\title{Create provenance for an object.}
\usage{
createProvenance(x, env = .GlobalEnv)
}
\arguments{
\item{x}{An object}

\item{env}{Environment in which to create provenance information (optional)}
}
\value{
x, with a new `provenance` attribute
}
\description{
Create provenance information for an object.
}
\examples{
d <- updateProvenance(cars, "first message")
d <- updateProvenance(d, "second message")
provenance(d)
}

