package mysql

import (
	"github.com/go-qbit/model"
)

var exprProcessor = &ExprProcessor{}

type ExprProcessor struct{}

type WriteFunc func(*SqlBuffer)

func (p *ExprProcessor) Eq(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)

		if op2 == nil {
			buf.WriteString(" IS NULL")
		} else {
			buf.WriteByte('=')
			op2.GetProcessor(p).(WriteFunc)(buf)
		}
	})
}

func (p *ExprProcessor) Ne(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)

		if op2 == nil {
			buf.WriteString(" IS NOT NULL")
		} else {
			buf.WriteString("<>")
			op2.GetProcessor(p).(WriteFunc)(buf)
		}
	})
}

func (p *ExprProcessor) Lt(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)
		buf.WriteByte('<')
		op2.GetProcessor(p).(WriteFunc)(buf)
	})
}

func (p *ExprProcessor) Le(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)
		buf.WriteString("<=")
		op2.GetProcessor(p).(WriteFunc)(buf)
	})
}

func (p *ExprProcessor) Gt(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)
		buf.WriteByte('>')
		op2.GetProcessor(p).(WriteFunc)(buf)
	})
}

func (p *ExprProcessor) Ge(op1, op2 model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op1.GetProcessor(p).(WriteFunc)(buf)
		buf.WriteString(">=")
		op2.GetProcessor(p).(WriteFunc)(buf)
	})
}

func (p *ExprProcessor) In(op model.IExpression, values []model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		op.GetProcessor(p).(WriteFunc)(buf)
		buf.WriteString(" IN (")
		for i, value := range values {
			if i > 0 {
				buf.WriteByte(',')
			}
			value.GetProcessor(p).(WriteFunc)(buf)
		}
		buf.WriteByte(')')
	})
}

func (p *ExprProcessor) And(ops []model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		for i, op := range ops {
			if i > 0 {
				buf.WriteString("AND")
			}
			buf.WriteByte('(')
			op.GetProcessor(p).(WriteFunc)(buf)
			buf.WriteByte(')')
		}
	})
}

func (p *ExprProcessor) Or(ops []model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		for i, op := range ops {
			if i > 0 {
				buf.WriteString("OR")
			}
			buf.WriteByte('(')
			op.GetProcessor(p).(WriteFunc)(buf)
			buf.WriteByte(')')
		}
	})
}

func (p *ExprProcessor) Any(localModel, extModel model.IModel, filter model.IExpression) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		relation := localModel.GetRelation(extModel.GetId())
		if relation.RelationType == model.RELATION_MANY_TO_MANY {
			buf.WriteIdentifiersList(relation.LocalFieldsNames)
			buf.WriteString("=ANY(SELECT ")
			buf.WriteIdentifiersList(relation.JunctionLocalFieldsNames)
			buf.WriteString(" FROM ")
			buf.WriteIdentifier(relation.JunctionModel.GetId())
			buf.WriteString(" WHERE (")
			buf.WriteIdentifiersList(relation.JunctionFkFieldsNames)
			buf.WriteString(")=ANY(SELECT ")
			buf.WriteIdentifiersList(relation.FkFieldsNames)
			buf.WriteString(" FROM ")
			buf.WriteIdentifier(extModel.GetId())

			if filter != nil {
				buf.WriteString(" WHERE ")
				filter.GetProcessor(p).(WriteFunc)(buf)
			}

			buf.WriteString("))")
		} else {
			buf.WriteRune('(')
			buf.WriteIdentifiersList(relation.LocalFieldsNames)
			buf.WriteString(")=ANY(SELECT ")
			buf.WriteIdentifiersList(relation.FkFieldsNames)
			buf.WriteString(" FROM ")
			buf.WriteIdentifier(extModel.GetId())

			if filter != nil {
				buf.WriteString(" WHERE ")
				filter.GetProcessor(p).(WriteFunc)(buf)
			}

			buf.WriteRune(')')
		}
	})
}

func (p *ExprProcessor) ModelField(m model.IModel, fieldName string) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		/*
			buf.WriteIdentifier(m.GetId())
			buf.WriteRune('.')
		*/
		buf.WriteIdentifier(fieldName)
	})
}

func (p *ExprProcessor) Value(value interface{}) interface{} {
	return WriteFunc(func(buf *SqlBuffer) {
		buf.WriteValue(value)
	})
}
