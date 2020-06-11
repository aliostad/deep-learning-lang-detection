#include <omega.hh>

namespace omega {

CodeMethodInvokeExpression::~CodeMethodInvokeExpression() {}

CodeMethodInvokeExpression::CodeMethodInvokeExpression() : CodeExpression() {
  this->m_method = nullptr;
  this->m_parameters = new CodeExpressionCollection();
}

CodeExpressionCollection* CodeMethodInvokeExpression::parameters() {
  return this->m_parameters;
}

CodeMethodReferenceExpression* CodeMethodInvokeExpression::method() {
  return this->m_method;
}

void CodeMethodInvokeExpression::method(CodeMethodReferenceExpression* value) {
  this->m_method = value;
}

void CodeMethodInvokeExpression::accept(ICodeObjectVisitor* visitor) {
  visitor->visit(this);
}

bool CodeMethodInvokeExpression::type_of(CodeObjectKind kind) {
  return kind == CodeObjectKind::CodeMethodInvokeExpression ||
         CodeExpression::type_of(kind);
}

void CodeMethodInvokeExpression::scope(CodeScope* scope) {
  CodeExpression::scope(scope);

  if (this->m_method != nullptr) this->m_method->scope(scope);

  for (auto x : *this->m_parameters) x->scope(scope);
}
}
