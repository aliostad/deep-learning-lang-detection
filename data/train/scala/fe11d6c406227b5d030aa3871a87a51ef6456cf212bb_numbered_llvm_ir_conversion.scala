package ljsp

import ljsp.AST._
import ljsp.util._

object numbered_llvm_ir_conversion {
  def convert_module_to_numbered_llvm_ir(m: LModule) : LModule = {
    LModule(m.name, m.functions.map{convert_function_to_numbered_llvm_ir})
  }

  def convert_function_to_numbered_llvm_ir(f: LFunction) : LFunction = {
    LFunction(f.name, f.params, number_vars(f.statements, 1))
  }

  // TODO also convert labels
  def number_vars(statements: List[LStatement], current_nr: Int) : List[LStatement] = statements match {
    case Nil => Nil
    case (s::sts) => {
      if (s.isInstanceOf[LVarAssignment]) {
        val va = s.asInstanceOf[LVarAssignment]
        val n = current_nr.toString
        LVarAssignment(n, va.e) :: 
        number_vars(sts.map{st => rename_var_in_statement(st, va.v, n)}, current_nr + 1)
      } else {
        s :: number_vars(sts, current_nr)
      }
    }
  }


  def rename_var_in_statement(s: LStatement, old_name: Idn, new_name: Idn) : LStatement = s match {
    case LVarAssignment(v, e) => LVarAssignment(rename_var(v, old_name, new_name), rename_var_in_exp(e, old_name, new_name))
    case LStore(t1, v1, t2, v2) => {
      LStore(t1, rename_var(v1, old_name, new_name), t2, rename_var(v2, old_name, new_name))
    }
    case LStoreFPointer(num_params, fname, t2, v2) => {
      LStoreFPointer(num_params, rename_var(fname, old_name, new_name), t2, rename_var(v2, old_name, new_name))
    }
    case LStoreDouble(d, v) => LStoreDouble(d, rename_var(v, old_name, new_name))
    case LLabel(l) => LLabel(rename_var(l, old_name, new_name))
    case LUnconditionalBr(l) => LUnconditionalBr(rename_var(l, old_name, new_name))
    case LConditionalBr(br_var, l_true, l_false) => {
      LConditionalBr(rename_var(br_var, old_name, new_name),
        rename_var(l_true, old_name, new_name),
        rename_var(l_false, old_name, new_name))
    }
    case LRet(t, v) => LRet(t, rename_var(v, old_name, new_name))

    case _ => rename_var_in_exp(s.asInstanceOf[LExp], old_name, new_name)
  }

  def rename_var_in_exp(e: LExp, old_name: Idn, new_name: Idn) : LExp = e match {
    case LVarAccess(t, v) => LVarAccess(t, rename_var(v, old_name, new_name))
    case LPrimitiveInstruction(op, ls) => LPrimitiveInstruction(op, ls.map{l => rename_var_in_exp(l, old_name, new_name)})
    case LLoad(t, v) => LLoad(t, rename_var(v, old_name, new_name))
    case LBitCast(old_type, v, new_type) => LBitCast(old_type, rename_var(v, old_name, new_name), new_type)
    case LGetElementPtr(t, av, index) => LGetElementPtr(t, rename_var(av, old_name, new_name), index)
    case LCallFName(f_name, params) => {
      LCallFName(rename_var(f_name, old_name, new_name), params.map{p => rename_var(p, old_name, new_name)})
    }
    case LCallFPointer(f_pointer, params) => {
      LCallFPointer(rename_var(f_pointer, old_name, new_name), params.map{p => rename_var(p, old_name, new_name)})
    }
    case LZext(v) => LZext(rename_var(v, old_name, new_name))
    case LIcmpNe(v) => LIcmpNe(rename_var(v, old_name, new_name))
    case LPhi(bs) => LPhi(bs.map{b => (rename_var_in_exp(b._1, old_name, new_name), rename_var(b._2, old_name, new_name))})

    case _ => e
  }
}
