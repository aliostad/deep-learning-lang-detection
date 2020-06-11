package com.gray.logic.language

import com.gray.logic.formula.{Formula, Term}
import com.gray.logic.formula._

trait FormulaWriter {

  def apply(formula: Formula): String = write(formula)
  def unapply(formula: Formula): Option[String] = Some(write(formula))

  def write(formula: Formula): String = writeFormula(formula)

  private def writeTerm(term: Term): String = term match {
    case Variable(i) => writeVariable(i)
    case Constant(i) => writeConstant(i)
    case Function(i, terms) => writeFunction(i, terms map writeTerm)
   }

  private def writeFormula(formula: Formula): String = formula match {
    case Sentence(i) => writeSentence(i)
    case Relation(i, args) => writeRelation(i, args map writeTerm)
    case Equals(l,r) => writeEquals(writeTerm(l), writeTerm(r))
    case Conjunction(l,r) => writeConjunction(writeFormula(l), writeFormula(r))
    case Disjunction(l,r) => writeDisjunction(writeFormula(l), writeFormula(r))
    case Conditional(l,r) => writeConditional(writeFormula(l), writeFormula(r))
    case Biconditional(l,r) => writeBiconditional(writeFormula(l), writeFormula(r))
    case Negation(f) => writeNegation(writeFormula(f))
    case UniversalQuantifier(Variable(i), f) => writeUniversalQuantifier(writeVariable(i), writeFormula(f))
    case ExistentialQuantifier(Variable(i), f) => writeExistentialQuantifier(writeVariable(i), writeFormula(f))
  }

  def writeSentence(index: Int): String
  def writeRelation(index: Int, args: Seq[String]): String
  def writeEquals(left: String, right: String): String

  def writeConjunction(left: String, right: String): String
  def writeDisjunction(left: String, right: String): String
  def writeConditional(left: String, right: String): String
  def writeBiconditional(left: String, right: String): String
  def writeNegation(formula: String): String

  def writeUniversalQuantifier(variable: String, formula: String): String
  def writeExistentialQuantifier(variable: String, formula: String): String

  def writeConstant(index: Int): String
  def writeVariable(index: Int): String
  def writeFunction(index: Int, terms: Seq[String]): String
}
