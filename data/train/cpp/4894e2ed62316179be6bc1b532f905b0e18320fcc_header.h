/*
 * File automatically generated by
 * gengen 1.0 by Lorenzo Bettini 
 * http://www.gnu.org/software/gengen
 */

#ifndef C_HEADER_GEN_CLASS_H
#define C_HEADER_GEN_CLASS_H

#include <string>
#include <iostream>

using std::string;
using std::ostream;

class c_header_gen_class
{
 protected:
  string author;
  string externfunctions;
  string fields;
  string funbody;
  string genconv;
  string genname;
  string genparameters;
  string genstring;
  string headernameinclude;
  string othercomments;
  string package;
  string structname;
  string version;

 public:
  c_header_gen_class()
  {
  }
  
  c_header_gen_class(const string &_author, const string &_externfunctions, const string &_fields, const string &_funbody, const string &_genconv, const string &_genname, const string &_genparameters, const string &_genstring, const string &_headernameinclude, const string &_othercomments, const string &_package, const string &_structname, const string &_version) :
    author (_author), externfunctions (_externfunctions), fields (_fields), funbody (_funbody), genconv (_genconv), genname (_genname), genparameters (_genparameters), genstring (_genstring), headernameinclude (_headernameinclude), othercomments (_othercomments), package (_package), structname (_structname), version (_version)
  {
  }

  virtual ~c_header_gen_class()
  {
  }

  static void
  generate_string(const string &s, ostream &stream, unsigned int indent)
  {
    if (!indent || s.find('\n') == string::npos)
      {
        stream << s;
        return;
      }

    string::size_type pos;
    string::size_type start = 0;
    string ind (indent, ' ');
    while ( (pos=s.find('\n', start)) != string::npos)
      {
        stream << s.substr (start, (pos+1)-start);
        start = pos+1;
        if (start+1 <= s.size ())
          stream << ind;
      }
    if (start+1 <= s.size ())
      stream << s.substr (start);
  }

  void set_author(const string &_author)
  {
    author = _author;
  }

  virtual void generate_externfunctions(ostream &stream, unsigned int indent) = 0;

  void set_externfunctions(const string &_externfunctions)
  {
    externfunctions = _externfunctions;
  }

  virtual void generate_fields(ostream &stream, unsigned int indent) = 0;

  void set_fields(const string &_fields)
  {
    fields = _fields;
  }

  virtual void generate_funbody(ostream &stream, unsigned int indent) = 0;

  void set_funbody(const string &_funbody)
  {
    funbody = _funbody;
  }

  virtual void generate_genconv(ostream &stream, unsigned int indent) = 0;

  void set_genconv(const string &_genconv)
  {
    genconv = _genconv;
  }

  void set_genname(const string &_genname)
  {
    genname = _genname;
  }

  virtual void generate_genparameters(ostream &stream, unsigned int indent) = 0;

  void set_genparameters(const string &_genparameters)
  {
    genparameters = _genparameters;
  }

  virtual void generate_genstring(ostream &stream, unsigned int indent) = 0;

  void set_genstring(const string &_genstring)
  {
    genstring = _genstring;
  }

  void set_headernameinclude(const string &_headernameinclude)
  {
    headernameinclude = _headernameinclude;
  }

  void set_othercomments(const string &_othercomments)
  {
    othercomments = _othercomments;
  }

  void set_package(const string &_package)
  {
    package = _package;
  }

  void set_structname(const string &_structname)
  {
    structname = _structname;
  }

  void set_version(const string &_version)
  {
    version = _version;
  }

  void generate_c_header(ostream &stream, unsigned int indent = 0)
  {
    string indent_str (indent, ' ');
    indent = 0;
  
    stream << "/*";
    stream << "\n";
    stream << indent_str;
    stream << " * File automatically generated by";
    stream << "\n";
    stream << indent_str;
    stream << " * ";
    generate_string (package, stream, indent + indent_str.length ());
    stream << " ";
    generate_string (version, stream, indent + indent_str.length ());
    stream << " ";
    generate_string (author, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
    stream << " * ";
    generate_string (othercomments, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
    stream << " */";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "#ifndef ";
    generate_string (headernameinclude, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
    stream << "#define ";
    generate_string (headernameinclude, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "#ifdef __cplusplus";
    stream << "\n";
    stream << indent_str;
    stream << "extern \"C\" {";
    stream << "\n";
    stream << indent_str;
    stream << "#endif /* __cplusplus */";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "#include <stdio.h>";
    stream << "\n";
    stream << indent_str;
    stream << "#include <stdlib.h>";
    stream << "\n";
    stream << indent_str;
    stream << "#include <string.h>";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "struct ";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
    stream << "{";
    stream << "\n";
    stream << indent_str;
    indent = 2;
    if (fields.size () > 0)
      generate_string (fields, stream, indent + indent_str.length ());
    else
      generate_fields (stream, indent + indent_str.length ());
    indent = 0;
    stream << indent_str;
    stream << "};";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    if (externfunctions.size () > 0)
      generate_string (externfunctions, stream, indent + indent_str.length ());
    else
      generate_externfunctions (stream, indent + indent_str.length ());
    stream << indent_str;
    stream << "void";
    stream << "\n";
    stream << indent_str;
    stream << "generate_";
    generate_string (genname, stream, indent + indent_str.length ());
    stream << "(FILE *stream, struct ";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << " *record, unsigned int indent);";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "void";
    stream << "\n";
    stream << indent_str;
    stream << "generatep_";
    generate_string (genname, stream, indent + indent_str.length ());
    stream << "(FILE *stream, unsigned int indent";
    if (genparameters.size () > 0)
      generate_string (genparameters, stream, indent + indent_str.length ());
    else
      generate_genparameters (stream, indent + indent_str.length ());
    stream << ");";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "char *";
    stream << "\n";
    stream << indent_str;
    stream << "genstring_";
    generate_string (genname, stream, indent + indent_str.length ());
    stream << "(struct ";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << " *record, unsigned int indent);";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "char *";
    stream << "\n";
    stream << indent_str;
    stream << "genstringp_";
    generate_string (genname, stream, indent + indent_str.length ());
    stream << "(unsigned int indent";
    if (genparameters.size () > 0)
      generate_string (genparameters, stream, indent + indent_str.length ());
    else
      generate_genparameters (stream, indent + indent_str.length ());
    stream << ");";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "int";
    stream << "\n";
    stream << indent_str;
    stream << "strcnt_";
    generate_string (genname, stream, indent + indent_str.length ());
    stream << "(struct ";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << " *record, unsigned int indent);";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "void";
    stream << "\n";
    stream << indent_str;
    stream << "init_";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << "(struct ";
    generate_string (structname, stream, indent + indent_str.length ());
    stream << " *record);";
    stream << "\n";
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    if (genstring.size () > 0)
      generate_string (genstring, stream, indent + indent_str.length ());
    else
      generate_genstring (stream, indent + indent_str.length ());
    stream << indent_str;
    if (genconv.size () > 0)
      generate_string (genconv, stream, indent + indent_str.length ());
    else
      generate_genconv (stream, indent + indent_str.length ());
    stream << indent_str;
    if (funbody.size () > 0)
      generate_string (funbody, stream, indent + indent_str.length ());
    else
      generate_funbody (stream, indent + indent_str.length ());
    stream << indent_str;
    stream << "\n";
    stream << indent_str;
    stream << "#ifdef __cplusplus";
    stream << "\n";
    stream << indent_str;
    stream << "}";
    stream << "\n";
    stream << indent_str;
    stream << "#endif /* __cplusplus */";
    stream << "\n";
    stream << indent_str;
    stream << "#endif // ";
    generate_string (headernameinclude, stream, indent + indent_str.length ());
    stream << "\n";
    stream << indent_str;
  }
};

#endif // C_HEADER_GEN_CLASS_H
