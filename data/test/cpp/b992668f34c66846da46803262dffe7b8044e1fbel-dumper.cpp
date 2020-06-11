#include "el-dumper.hpp"
#include "el-syntax.hpp"

#include <iostream>

namespace dcipl
{
namespace el
{
  void
  dumper::dump_prog(const prog* p)
  {
    dump_guard g(*this, p, false);
    os << ' ' << p->nargs;
    print_newline();
    indent();
    dump_num_expr(p->body);
    undent();
  }

  void
  dumper::dump_num_expr(const num_expr* e)
  {
    switch (get_expr_kind(e)) {
      case ek_int:
        return dump_int_lit(static_cast<const int_lit*>(e));
      case ek_arg:
        return dump_arg_expr(static_cast<const arg_expr*>(e));
      case ek_arith:
        return dump_arith_expr(static_cast<const arith_expr*>(e));
      case ek_if:
        return dump_if_expr(static_cast<const if_expr*>(e));
      }
  }

  void
  dumper::dump_int_lit(const int_lit* e)
  {
    dump_guard g(*this, e);
    os << ' ' << e->val;    
  }

  void
  dumper::dump_arg_expr(const arg_expr* e)
  {
    dump_guard g(*this, e);
    os << ' ' << e->ix;    
  }

  void
  dumper::dump_arith_expr(const arith_expr* e)
  {
    dump_guard g(*this, e, false);
    os << ' ' << get_op_name(e->op);
    print_newline();
    indent();
    dump_num_expr(e->e1);
    dump_num_expr(e->e2);
    undent();
  }

  void
  dumper::dump_if_expr(const if_expr* e)
  {
    dump_guard g(*this, e, false);
    print_newline();
    indent();
    dump_bool_expr(e->test);
    dump_num_expr(e->e1);
    dump_num_expr(e->e2);
    undent();
  }

  void
  dumper::dump_bool_expr(const bool_expr* e)
  {
    switch (get_expr_kind(e)) {
      case ek_bool:
        return dump_bool_lit(static_cast<const bool_lit*>(e));
      case ek_rel:
        return dump_rel_expr(static_cast<const rel_expr*>(e));
      case ek_logic:
        return dump_logic_expr(static_cast<const logic_expr*>(e));
    }
  }

  void
  dumper::dump_bool_lit(const bool_lit* e)
  {
    dump_guard g(*this, e);
    os << ' ' << ((e->val) ? "true" : "false");
  }

  void
  dumper::dump_rel_expr(const rel_expr* e)
  {
    dump_guard g(*this, e, false);
    os << ' ' << get_op_name(e->op);
    print_newline();
    indent();
    dump_num_expr(e->e1);
    dump_num_expr(e->e2);
    undent();
  }

  void
  dumper::dump_logic_expr(const logic_expr* e)
  {
    dump_guard g(*this, e, false);
    os << ' ' << get_op_name(e->op);
    print_newline();
    indent();
    dump_bool_expr(e->e1);
    dump_bool_expr(e->e2);
    undent();
  }

  dumper::dump_guard::dump_guard(dumper& d, const prog* p, bool nl)
    : cc::dumper::dump_guard(d, p, get_node_name(p), nl)
  { }

  dumper::dump_guard::dump_guard(dumper& d, const num_expr* e, bool nl)
    : cc::dumper::dump_guard(d, e, get_node_name(e), nl)
  { }

  dumper::dump_guard::dump_guard(dumper& d, const bool_expr* e, bool nl)
    : cc::dumper::dump_guard(d, e, get_node_name(e), nl)
  { }

  void 
  dump(const prog* p)
  {
    dumper d(std::cerr);
    d(p);
  }

  void 
  dump(const num_expr* e)
  {
    dumper d(std::cerr);
    d(e);
  }

  void 
  dump(const bool_expr* e)
  {
    dumper d(std::cerr);
    d(e);
  }

} // namespace el
} // namespace dcipl
