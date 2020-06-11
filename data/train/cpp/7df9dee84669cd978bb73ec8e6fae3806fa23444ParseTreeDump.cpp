#include "ParseTree.hpp"

String Decl::dump()
{
    String str = "int ";
    str += this->identifier;
    if(this->array)
    {
        str += "[";
        str += (long)this->arraySize;
        str += "]";
    }
    return str;
}

String Decls::dump()
{
    String str = "";
    for(int i=0; i<decls->getSize();i++)
    {
        Decl *decl = this->decls->getValue(i);
        str += decl->dump();
        
        str += "; ";
    }
    return str;
}

String OpExp::dump()
{
    String str = "";
    if(this->op != NULL && this->exp != NULL)
    {
        str += op->dump();
        str += exp->dump();
    }
    return str; 
}

String Op::dump()
{
    static String items[] = { "+", "-", "*", "/", "<", "=", ">", "<=>", "&", "!" };

    String str = " ";
    str += items[this->type];
    str += " ";
    return str;
}

String Index::dump()
{ 
    if(exp != NULL)
    {
        String str = "[";
        str += exp->dump();
        str += "]";
        return str; 
    }
    return "";
}

String Exp2_1::dump() 
{
    String str = "(";
    str += exp->dump();
    str += ")";
    return str; 
}

String Exp2_2::dump()
{
    String str = this->identifier;
    str += index->dump();
    return str; 
}

String Exp2_3::dump() 
{
    String str = "";
    str += integer;
    return str; 
}

String Exp2_4::dump()
{
    String str = "-";
    str += exp2->dump();
    return str;
}

String Exp2_5::dump()
{
    String str = "!";
    str += exp2->dump();
    return str;
}

String Exp::dump() 
{ 
    String str = exp2->dump();
    str += opexp->dump();
    return str;
}

String Statement_1::dump()
{
    String str = this->identifier;
    if(index != NULL)
        str += index->dump();
    str += " = ";
    str += exp->dump();
    return str; 
}

String Statement_2::dump()
{
    String str = "print( ";
    str += exp->dump();
    str += " )";
    return str; 
}

String Statement_3::dump()
{
    String str = "read( ";
    str += identifier;
    str += " )";
    return str; 
}


String Statement_4::dump() 
{ 
    String str = "{\n";
    str += statements->dump();
    str += "}";
    return str; 
}

String Statement_5::dump() 
{
    String str = "if(";
    str += exp->dump();
    str += ")";
    str += statement1->dump();
    if(this->statement2 != NULL)
    {
        str += " else ";
        str += statement2->dump();
    }
    return str; 
}

String Statement_6::dump() 
{
    String str = "while(";
    str += exp->dump();
    str += ") ";
    str += statement->dump();
    return str; 
}

String Statements::dump() 
{ 
    String str = "";
    for(int i=0; i<statements->getSize();i++)
    {
        Statement *statement = this->statements->getValue(i);
        str += statement->dump();
        
        str += ";\n";
    }
    return str;
}

String Prog::dump() 
{
    String str = "Dumping decls:\n";
    str += this->decls->dump();
    str += "\n";
    str += "Dumping statements:\n";
    str += this->statements->dump();
    str += "\n";
    return str;
}

