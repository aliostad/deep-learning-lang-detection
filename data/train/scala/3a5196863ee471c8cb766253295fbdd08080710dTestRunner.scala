package org.seacourt.pacatoon

object TestRunner extends App
{
    override def main( args : Array[String] ) =
    {
        val typeCheck = true
        
        for ( f <- args )
        {
            println( "Evaluation: " + f )
            val file = scala.io.Source.fromFile( f )
            val str = file.mkString
            file.close()
            val parsed = CalculatorDSL.parse( str )
            val ssaResolved = NameAliasResolution( parsed )
            
            if (typeCheck)
            {
                //DumpAST( parsed )
                println( "  Checking types" )
                buTypeAST( ssaResolved )
                println( "    (passed)" )
                //DumpAST( parsed )
            }
            
            println( "********** SSA resolved **********" )
            //DumpAST( ssaResolved )
            val lifted = LiftAllFunctions( ssaResolved )
            
            // Lazy: should keep the types updated when transforming AST
            buTypeAST( lifted )
            
            println( "********** Lifted **********" )
            //DumpAST( lifted )
            
            val execContext = new ValueExecutionContext()
            val evaluator = new DynamicASTEvaluator( execContext )
            evaluator.eval( lifted )
        }
    }
}


