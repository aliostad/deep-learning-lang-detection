package ljsp

import ljsp.AST._
import ljsp.util._

object remove_redundant_assigns_conversion {
  def convert_module_to_rra_ir(m: IModule) : IModule = {
    IModule(m.name, m.functions.map{convert_function_to_rra_ir})
  }

  def convert_function_to_rra_ir(f: IFunction) : IFunction = {
    IFunction(f.name, f.params, convert_statements_to_rra_ir(f.statements))
  }

  def convert_statements_to_rra_ir(statements: List[IStatement]) : List[IStatement] = statements match {
    case Nil => Nil
    case (s::sts) => s match {
      case IVarAssignment(lh, IIdn(rh)) => {
        // TODO Remove this special case (git grep if_var)
        if (lh.startsWith("if_var_"))
          s :: convert_statements_to_rra_ir(sts)
        else
          convert_statements_to_rra_ir(sts.map{rename_var_in_ir_statement(_, lh, rh)})
      }
      case _ => s :: convert_statements_to_rra_ir(sts)
    }
  }

  def rename_var_in_ir_statement(s: IStatement, old_name: Idn, new_name: Idn) : IStatement = s match {
    case IIf(if_var, block1, block2) => {
      val renamed_block1 = block1.map{rename_var_in_ir_statement(_, old_name, new_name)}
      val renamed_block2 = block2.map{rename_var_in_ir_statement(_, old_name, new_name)}

      IIf(rename_var(if_var, old_name, new_name), renamed_block1, renamed_block2)
    }
    case IVarAssignment(idn, value) => {
      if (old_name == idn)
        throw new IllegalArgumentException("Renaming a variable that gets assigned to again later")
      else 
        IVarAssignment(idn, rename_var_in_ir_exp(value, old_name, new_name))
    }
    case _ => rename_var_in_ir_exp(s.asInstanceOf[IExp], old_name, new_name)
  }

  def rename_var_in_ir_exp(e: IExp, old_name: Idn, new_name: Idn) : IExp = e match {
    case IIdn(idn) => IIdn(rename_var(idn, old_name, new_name))
    case IStaticValue(_) => e
    case IFunctionCallByName(f_name, params) => {
      IFunctionCallByName(f_name, params.map{rename_var_in_ir_exp(_, old_name, new_name)})
    }
    case IFunctionCallByVar(hl_var, params) => {
      IFunctionCallByVar(rename_var(hl_var, old_name, new_name),
        params.map{rename_var_in_ir_exp(_, old_name, new_name)})
    }
    case IPrimitiveInstruction(op, is) => {
      IPrimitiveInstruction(op, is.map{rename_var_in_ir_exp(_, old_name, new_name)})
    }
    case IMakeEnv(idns) => IMakeEnv(idns.map{rename_var(_, old_name, new_name)})
    case IHoistedLambda(f_name, env) => IHoistedLambda(f_name, rename_var(env, old_name, new_name))
    case IArrayAccess(a, index) => IArrayAccess(rename_var(a, old_name, new_name), index)
    
    case _ => throw new IllegalArgumentException()
  }
}
