# dataprov
**Lightweight** data provenance tracking.

*Data provenance* broadly refers to a description of the origins of a piece of data and the process by which it arrived in a database or analysis (see e.g. http://db.cis.upenn.edu/DL/fsttcs.pdf). This package implements a simple system for tracking operations performed on any R object. It's not automatic though--you have to call `updateProvenance()` each time you want to put a new entry into the provenance.

The provenance is stored as an object attribute (currently a data frame, but don't depend on this--use the accessor functions below!). Available functions include:

**Public**
* `updateProvenance(x, message, caller = NULL)` - add a provenance entry
* `provenance(x, n = NULL)` - gets the entire data frame, with attribute "dataprov". If `n` is supplied, return a list corresponding to the *nth* entry
* `replaceProvenance(x, p)` - replace entire provenance of `x` with a data frame `p` (must have correct fields)
* `summary.dataprov()` - summarize data provenance - abbreviating all fields (digest, message, etc) for easy reading

**Private**
* dataprov() - object creation

**???**
* `mergeProvenance(a, b)` - merge provenance of b into that of a. Ugh. Useful?
* `print.dataprov()` - no, this would just be printing of data.frame
* Could offer an option to save `x` each time the provenance is updated? Not a version 1.0 feature I don't think
