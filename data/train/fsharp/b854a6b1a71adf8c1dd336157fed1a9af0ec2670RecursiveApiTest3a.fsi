(*******************************************************************************
    Copyright 2011, Oracle and/or its affiliates.
    All rights reserved.


    Use is subject to license terms.

    This distribution may include materials developed by third parties.

 ******************************************************************************)

api RecursiveApiTest3a
import RecursiveApiTest3b.{ MaybeBar, Bar, Nada }


trait MaybeFoo comprises { Foo, Zilchness } end

object Foo(x: MaybeBar) extends MaybeFoo
  peek(): MaybeBar
end

object Zilchness extends MaybeFoo end

end
