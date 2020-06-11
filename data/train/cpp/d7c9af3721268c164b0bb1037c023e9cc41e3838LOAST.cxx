//
// Created by secondwtq <lovejay-lovemusic@outlook.com> 2015/09/12.
// Copyright (c) 2015 SCU ISDC All rights reserved.
//
// This file is part of ISDCNext.
//
// We have always treaded the borderland.
//

#include "LOAST.hxx"
#include "LOASTVisitor.hxx"
#include "LOType.hxx"

namespace Olivia {
namespace AST {

void Node::dump() const {
    dump_output("Node - Base");
}

void NodeIdentifier::dump() const {
    dump_output("Identifier - " + name);
}

void NodeStatementVar::dump() const {
    dump_output("Statement - 'var'");
    if (list) {
        list->dump();
    }
}

void NodeDeclarationVar::dump() const {
    dump_output("Declaration - 'var'");
    if (name) {
        name->dump();
    }
    if (type) {
        type->dump();
    }
    if (initializer) {
        initializer->dump();
    }
}

void NodeTypeSpec::dump() const {
    dump_output(std::string("Node - Type - ") + convertValueTypeToString(base_type));
    if (concrete_type) {
        concrete_type->dump();
    }
}

void NodeDeclarationClassElement::dump() const {
    dump_output("Declaration - element of 'class'");
    if (name) {
        name->dump();
    }
    if (type) {
        type->dump();
    }
}

void NodeDeclarationClass::dump() const {
    dump_output("Decleartion - 'class'");
    if (name) {
        name->dump();
    }
    for (auto member : members) {
        member->dump();
    }
}

void MiscVarDeclarationList::dump() const {
    dump_output("Misc - 'var' declearation list");
    for (auto var : vars) {
        var->dump();
    }
}

void Node::dump_output(const std::string& msg) const {
    if (!this->parent()) {
        printf("%s\n", msg.c_str());
    } else {
        this->parent()->dump_output(' ' + msg);
    }
}

void NodeDeclarationClassElementState::dump() const {
    dump_output("Declaration - class element state");
    if (name) {
        name->dump();
    }
    if (type) {
        type->dump();
    }
}

void NodeDeclarationClassElementMethod::dump() const {
    dump_output("Declaration - class element method");
    if (name) {
        name->dump();
    }
    if (type) {
        type->dump();
    }
}

void NodeDeclarationParameter::dump() const {
    dump_output("Declaration - parameter");
    if (name) {
        name->dump();
    }
    if (ptype) {
        ptype->dump();
    }
}

void NodeDeclarationSignature::dump() const {
    dump_output("Declaration - signature");
    for (auto parameter : parameters) {
        parameter->dump();
    }
    if (return_type) {
        return_type->dump();
    }
}

void NodeDeclarationFunction::dump() const {
    dump_output("Declaration - 'function'");
    if (name) {
        name->dump();
    }
    if (signature) {
        signature->dump();
    }
    if (body) {
        body->dump();
    }
}

void NodeBlock::dump() const {
    dump_output("Statement - block");
    for (auto statement : statements) {
        statement->dump();
    }
}

void NodeDeclarationExternFunction::dump() const {
    dump_output("Declaration - 'extern function'");
    if (name) {
        name->dump();
    }
    if (signature) {
        signature->dump();
    }
}

void NodeBinaryExpression::dump() const {
    std::string ret = "Expression - Binary - <";
    ret += op;
    ret += ">";
    dump_output(ret);
    if (lhs) {
        lhs->dump(); }
    if (rhs) {
        rhs->dump(); }
}

void NodeParenthesisExpression::dump() const {
    dump_output("Expression - Parenthesis");
    if (expression) {
        expression->dump(); }
}

void NodeCallExpression::dump() const {
    dump_output("Expression - Call");
    if (callee) {
        callee->dump(); }
    for (auto argument : arguments) {
        argument->dump(); }
}

void NodeMemberExpression::dump() const {
    dump_output("Expression - Member Access");
    if (expression) {
        expression->dump(); }
    if (name) {
        name->dump(); }
}

void NodeStatementExpression::dump() const {
    dump_output("Statement - Expression");
    if (expression) {
        expression->dump(); }
}

void NodeStatementReturn::dump() const {
    dump_output("Statement - 'return'");
    if (expression) {
        expression->dump(); }
}

void NodeStatementIf::dump() const {
    dump_output("Statement - If");
    if (cond_) {
        cond_->dump(); }
    if (then_) {
        then_->dump(); }
    if (else_) {
        else_->dump(); }
}

void NodeStatementWhile::dump() const {
    dump_output("Statement - While");
    if (cond) {
        cond->dump(); }
    if (body) {
        body->dump(); }
}

std::shared_ptr<OliveType> NodeIdentifier::type() const {

}

std::shared_ptr<OliveType> NodeMemberExpression::type() const {

}

std::shared_ptr<OliveType> NodeBinaryExpression::type() const {

}

std::shared_ptr<OliveType> NodeCallExpression::type() const {

}

std::shared_ptr<OliveType> NodePrefixUnaryExpression::type() const {

}

}
}
