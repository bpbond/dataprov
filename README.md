# dataprov
Easy data provenance tracking.

*Data provenance* broadly refers to a description of the origins of a piece of data and the process by which it arrived in a database or analysis (see http://db.cis.upenn.edu/DL/fsttcs.pdf).

The plan here is to store a provenance as an objection attribute. Available functions will include:

**Public**
* `updateProvenance(message, caller, etc.)` - add a provenance entry (follows the RCMIP5 function)
* `getProvenance(n = NULL)` - gets the entire data frame (or the nth entry)
* `mergeProvenance(a, b)` - merge provenance of b into that of a
* `replaceProvenance()` - mass replacement with a data frame

**Private**
* dataprov() - object creation
* print.dataprov() - ?
* summary.dataprov() - summarize data provenance
