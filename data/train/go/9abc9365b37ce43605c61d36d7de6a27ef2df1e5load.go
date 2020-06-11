package node_types
import (
	"database/sql"
)

func(*NodeTypeArrayType) Load(v sql.NullInt64) {}
func(*NodeTypeFieldDecl) Load(v sql.NullInt64) {}
func(*NodeTypeFunctionDecl) Load(v sql.NullInt64) {}
func(*NodeTypeFunctionType) Load(v sql.NullInt64) {}
func(*NodeTypeIdentifierNode) Load(v sql.NullInt64) {}
func(*NodeTypeIntegerCst) Load(v sql.NullInt64) {}
func(*NodeTypeIntegerType) Load(v sql.NullInt64) {}
func(*NodeTypeParamList) Load(v sql.NullInt64) {}
func(*NodeTypePointerType) Load(v sql.NullInt64) {}
func(*NodeTypeRecordType) Load(v sql.NullInt64) {}
func(*NodeTypeTreeList) Load(v sql.NullInt64) {}
func(*NodeTypeTypeDecl) Load(v sql.NullInt64) {}
func(*NodeTypeUnionType) Load(v sql.NullInt64) {}
func(*NodeTypeVoidType) Load(v sql.NullInt64) {}
