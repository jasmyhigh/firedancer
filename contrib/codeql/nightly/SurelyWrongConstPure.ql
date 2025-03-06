/**
 * @name Call to a non const/pure function
 * @description Checks for known non-const/non-pure functions being
 * (transitively) called by a function that is marked as const or pure.
 * @id asymmetric-research/sure-call-to-non-const-pure
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 */

import cpp

abstract class RFunc extends Function { }

class PureFunc extends RFunc {
  PureFunc() { this.getAnAttribute().getName() = "pure" }
}

class ConstFunc extends RFunc {
  ConstFunc() { this.getAnAttribute().getName() = "const" }
}

abstract class ShouldBeFunc extends Function { }

class ShouldBePure extends ShouldBeFunc {
  Function off;

  ShouldBePure() {
    (
      off instanceof RFunc or
      off instanceof ShouldBeFunc
    ) and
    not this instanceof RFunc and
    this.getACallToThisFunction().getEnclosingFunction() = off and
    this.getLocation().getFile().getRelativePath().matches("src/%")
  }

  Function getOff() { result = off }
}

string directOrNot(Function off) {
  /* alternativly we could make this query a path-query */
  result = "is" and off instanceof RFunc
  or
  result = "is called by a" and off instanceof ShouldBeFunc
}

from ShouldBePure f, Function off
where
  off = f.getOff() and
  (
    /* for a nightly query, we only want known non-const/non-pure functions */
    f.hasName("fd_log_private_1") or
    f.hasName("fd_log_private_2") or
    f.hasName("fd_log_wallclock()") or
    f.getName().matches("fd_valloc_%")
  )
select off, f + " is called via " + off + " which " + directOrNot(off) + " const/pure function"
