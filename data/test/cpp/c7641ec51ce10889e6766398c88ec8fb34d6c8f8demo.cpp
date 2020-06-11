#include "esprima.h"
#include <sys/time.h>
#include <iostream>
#include <fstream>

#define NONE (0)

#define PROP(name) \
  (out << std::string(indent, ' ') << #name " = " << node->name << "\n")

#define DUMP(Node, props) \
  void visit(esprima::Node *node) { \
    out << std::string(indent, ' ') << #Node " { // line " << node->loc->start->line << "\n"; \
    indent += 2; \
    (void)(props); \
    visitChildren(node); \
    indent -= 2; \
    out << std::string(indent, ' ') << "}\n"; \
  }

struct DumpVisitor : esprima::Visitor {
  int indent;
  std::ostream &out;
  DumpVisitor(std::ostream &out) : indent(), out(out) {}
  DUMP(Program, NONE)
  DUMP(Identifier, PROP(name))
  DUMP(BlockStatement, NONE)
  DUMP(EmptyStatement, NONE)
  DUMP(ExpressionStatement, NONE)
  DUMP(IfStatement, NONE)
  DUMP(LabeledStatement, NONE)
  DUMP(BreakStatement, NONE)
  DUMP(ContinueStatement, NONE)
  DUMP(WithStatement, NONE)
  DUMP(SwitchCase, NONE)
  DUMP(SwitchStatement, NONE)
  DUMP(ReturnStatement, NONE)
  DUMP(ThrowStatement, NONE)
  DUMP(CatchClause, NONE)
  DUMP(TryStatement, NONE)
  DUMP(WhileStatement, NONE)
  DUMP(DoWhileStatement, NONE)
  DUMP(ForStatement, NONE)
  DUMP(ForInStatement, NONE)
  DUMP(DebuggerStatement, NONE)
  DUMP(FunctionDeclaration, NONE)
  DUMP(VariableDeclarator, NONE)
  DUMP(VariableDeclaration, PROP(kind))
  DUMP(ThisExpression, NONE)
  DUMP(ArrayExpression, NONE)
  DUMP(Property, PROP(kind))
  DUMP(ObjectExpression, NONE)
  DUMP(FunctionExpression, NONE)
  DUMP(SequenceExpression, NONE)
  DUMP(UnaryExpression, (PROP(operator_), PROP(prefix)))
  DUMP(BinaryExpression, PROP(operator_))
  DUMP(AssignmentExpression, PROP(operator_))
  DUMP(UpdateExpression, PROP(operator_))
  DUMP(LogicalExpression, PROP(operator_))
  DUMP(ConditionalExpression, NONE)
  DUMP(NewExpression, NONE)
  DUMP(CallExpression, NONE)
  DUMP(MemberExpression, PROP(computed))
  DUMP(NullLiteral, NONE)
  DUMP(RegExpLiteral, (PROP(pattern), PROP(flags)))
  DUMP(StringLiteral, PROP(value))
  DUMP(NumericLiteral, PROP(value))
  DUMP(BooleanLiteral, PROP(value))
};

int64_t microseconds() {
  struct timeval time;
  gettimeofday(&time, NULL);
  return time.tv_sec * (int64_t)1000000 + time.tv_usec;
}

void compile(const std::string &path, std::istream &input, std::ostream &output) {
  std::string code((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
  std::cout << "parsing " << path << std::endl;
  try {
    esprima::Pool pool;
    int64_t start = microseconds();
    esprima::Program *program = esprima::parse(pool, code);
    int64_t end = microseconds();

    std::cout << "parsed in " << (end - start) / 1000 << "ms" << std::endl;
    DumpVisitor visitor(output);
    program->accept(&visitor);
  } catch (const esprima::ParseError &error) {
    std::cout << "parse error: " << error.description << std::endl;
  }
}

int main(int argc, char *argv[]) {
  if (argc == 1) {
    std::cout << "enter JavaScript code below:" << std::endl;
    compile("<stdin>", std::cin, std::cout);
    return 0;
  }

  for (int i = 1; i < argc; i++) {
    std::ifstream input(argv[i]);
    if (!input) continue;
    std::ofstream output((std::string(argv[i]) + ".dump.txt").c_str());
    compile(argv[i], input, output);
  }
  return 0;
}
