# dataprov
**Lightweight** data provenance tracking.

Currently this works as follows:
* Each object to be tracked has an attribute "provenance" attached to it **once** via `createProvenance`. This attribute essentially holds the provenance lookup name, and is a combination of the object's name and date/time.
* The lookup name is used to pull out an element from a `.provenance_list` list, currently stored by default in the global environment. For example if object `x` gets assigned a "provenance" attribute of "x_12345", then `.provenance_list[["x_12345"]]` holds the provenance record.
* This record is a data frame with timestamp, caller, message, and digest (MD5) of `x` at that point in time. `updateProvenance` only changes this, not the original object `x`, so avoiding (I hope) expensive copies.
* **The disadantage of this approach** is that if `x` is deleted, its record just hangs around; and if `y <- x` then y and x will share the same record. Ugh, hadn't thought about this last case.
* Finally, note that this is opt-in provenance tracking. That is, we have to update the record for `x` manually each time a change is made. This is by design (lightweight...) but worth considering.

```R
> library(dataprov)
> x <- 1
> x <- createProvenance(x)
Creating provenance list
> updateProvenance(x, "created x and its provenance record")
> x <- x + 1
> updateProvenance(x, "added 1")
> provenance(x)
            timestamp caller                        message   digest
1 2015-08-21 14:26:14   <NA> created x and its provenanc... 5fd7a492
2 2015-08-21 14:26:27   <NA>                        added 1 d934fb15
> listProvenances()
  Object         Creation Entries
1      x 1440181552.45085       2
```

*Data provenance* broadly refers to a description of the origins of a piece of data and the process by which it arrived in a database or analysis (see e.g. http://db.cis.upenn.edu/DL/fsttcs.pdf). This package implements a simple system for tracking operations performed on any R object. It's not automatic though--you have to call `updateProvenance()` each time you want to put a new entry into the provenance.

The provenance is stored as an object attribute (currently a data frame, but don't depend on this--use the accessor functions below!). Available functions include:

**Public**
* `createProvenance(x, env = .GlobalEnv)` - attach a "provenance" attribute to `x`, create the provenance_list if necessary, and create an empty provenance record. Necessary before any of the functions below can be called.
* `updateProvenance(x, message, caller = NULL, env = .GlobalEnv)` - add a provenance entry
* `provenance(x, n = NULL, env = .GlobalEnv)` - gets the entire data frame, with attribute "dataprov". If `n` is supplied, return a list corresponding to the *nth* entry
* `print.dataprov()` - summarize a data provenance - abbreviating all fields (digest, message, etc) for easy reading
* `listProvenances(env = .GlobalEnv)` - summary list of current provenances records

**Private**
* dataprov() - object creation
* `replaceProvenance(x, p)` - replace entire provenance of `x` with `p` 

**???**
* `mergeProvenance(a, b)` - merge provenance of b into that of a. Ugh. Useful?
* Could offer an option to save `x` each time the provenance is updated? Not a version 1.0 feature I don't think
* `provenance(x) <- p` - replaces entire provenance of `x` with `p` (must be data.frame with correct fields)
