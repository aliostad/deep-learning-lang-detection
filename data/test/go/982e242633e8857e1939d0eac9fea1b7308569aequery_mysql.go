package montage

import (
	"strings"
	"strconv"
	"bytes"
)

type MySQLQueryBuilder struct {
	buffer bytes.Buffer
}

func (sql *MySQLQueryBuilder) Select(field ...string)  QueryBuilder{
	sql.buffer.WriteString("SELECT")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(strings.Join(field,INTERVAL))
	return sql
}

func (sql *MySQLQueryBuilder) From(table string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("FROM")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(table)
	return sql
}

func (sql *MySQLQueryBuilder) LeftJoin(table string,left string,right string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("LEFTJOIN")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(table)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("ON")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(left)
	sql.buffer.WriteString("=")
	sql.buffer.WriteString(right)
	return sql
}

func (sql *MySQLQueryBuilder) RightJoin(table string,left string,right string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("RIGHTJOIN")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(table)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("ON")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(left)
	sql.buffer.WriteString("=")
	sql.buffer.WriteString(right)
	return sql
}

func (sql *MySQLQueryBuilder) InnerJoin(table string,left string,right string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("INNERJOIN")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(table)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("ON")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(left)
	sql.buffer.WriteString("=")
	sql.buffer.WriteString(right)
	return sql
}

func (sql *MySQLQueryBuilder) Where(condition string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("WHERE")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(condition)
	return sql
}

func (sql *MySQLQueryBuilder) AndWhere(condition string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(condition)
	return sql
}

func (sql *MySQLQueryBuilder) OrWhere(condition string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("OR")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(condition)
	return sql
}

func (sql *MySQLQueryBuilder) Limit(limit int)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("LIMIT")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(strconv.Itoa(limit))
	return sql
}

func (sql *MySQLQueryBuilder) Offset(offset int)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("OFFSET")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(strconv.Itoa(offset))
	return sql
}

func (sql *MySQLQueryBuilder) Between(field string,min string,max string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(field)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("BETWEEN")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(min)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(max)
	return sql
}

func (sql *MySQLQueryBuilder) NotBetween(field string,min string,max string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(field)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("NOT BETWEEN")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(min)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(max)
	return sql
}


func (sql *MySQLQueryBuilder) LessThan(field string,value string,equal bool)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(field)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("<")
	if equal {
		sql.buffer.WriteString("=")
	}
	sql.buffer.WriteString(value)
	return sql
}

func (sql *MySQLQueryBuilder) GreaterThan(field string,value string,equal bool)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("AND")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(field)
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(">")
	if equal {
		sql.buffer.WriteString("=")
	}
	sql.buffer.WriteString(value)
	return sql
}

func (sql *MySQLQueryBuilder) GroupBy(field ...string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("GROUP BY")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(strings.Join(field,INTERVAL))
	return sql
}

func (sql *MySQLQueryBuilder) Having(condition string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("HAVING")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(condition)
	return sql
}

func (sql *MySQLQueryBuilder) OrderBy(order ...string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("ORDER BY")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(strings.Join(order,INTERVAL))
	return sql
}

func (sql *MySQLQueryBuilder) Union(s string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("UNION")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(s)
	return sql
}

func (sql *MySQLQueryBuilder) UnionAll(s string)  QueryBuilder{
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString("UNION ALL")
	sql.buffer.WriteString(BLANK)
	sql.buffer.WriteString(s)
	return sql
}

func (sql *MySQLQueryBuilder) Build()  string{
	return sql.buffer.String()
}
