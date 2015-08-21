# dataprov
**Lightweight** data provenance tracking.

Currently this works as follows:
* Each object to be tracked has an attribute `provenance` attached to it **once** via `createProvenance`. This attribute essentially holds the provenance lookup name, and is a combination of the object's name and date/time.
* The lookup name is used to pull out an element from a `.provenance_list` list, currently stored by default in the global environment. For example if object `x` has a `provenance` attribute of "x_12345", then `.provenance_list[["x_12345"]] holds the provenance record.
* This record is a data frame with timestamp, caller, message, and digest (MD5). `updateProvenance` only changes this, not the original object `x`, so avoiding (I hope) expensive copies.


*Data provenance* broadly refers to a description of the origins of a piece of data and the process by which it arrived in a database or analysis (see e.g. http://db.cis.upenn.edu/DL/fsttcs.pdf). This package implements a simple system for tracking operations performed on any R object. It's not automatic though--you have to call `updateProvenance()` each time you want to put a new entry into the provenance.

The provenance is stored as an object attribute (currently a data frame, but don't depend on this--use the accessor functions below!). Available functions include:

**Public**
* `updateProvenance(x, message, caller = NULL)` - add a provenance entry
* `provenance(x, n = NULL)` - gets the entire data frame, with attribute "dataprov". If `n` is supplied, return a list corresponding to the *nth* entry
* `provenance(x) <- p` - replaces entire provenance of `x` with `p` (must be data.frame with correct fields)
* `print.dataprov()` - summarize data provenance - abbreviating all fields (digest, message, etc) for easy reading

**Private**
* dataprov() - object creation
* `replaceProvenance(x, p)` - replace entire provenance of `x` with `p` 

**???**
* `mergeProvenance(a, b)` - merge provenance of b into that of a. Ugh. Useful?
* Could offer an option to save `x` each time the provenance is updated? Not a version 1.0 feature I don't think
