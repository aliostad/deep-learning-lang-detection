package syncapi

//ProcessSyncChangeEnum defines the types of processing that can occur on during sync.
type ProcessSyncChangeEnum int

const (
	//ProcessSyncChangeEnumAddOrUpdate is the add or update processing during sync.
	ProcessSyncChangeEnumAddOrUpdate ProcessSyncChangeEnum = 1
	//ProcessSyncChangeEnumDelete is the add or delete processing during sync.
	ProcessSyncChangeEnumDelete ProcessSyncChangeEnum = 2
)

//ProcessSyncChangeEnumName gives the string name of ProcessSyncChangeEnum.
var ProcessSyncChangeEnumName = map[int]string{
	1: "AddOrUpdate",
	2: "Delete",
}

//ProcessSyncChangeEnumValue gives the int value of ProcessSyncChangeEnum.
var ProcessSyncChangeEnumValue = map[string]int{
	"AddOrUpdate": 1,
	"Delete":      2,
}

//Enum gives the ProcessSyncChangeEnum given one of the constants from ProcessSyncChangeEnum*.
func (x ProcessSyncChangeEnum) Enum() *ProcessSyncChangeEnum {
	p := new(ProcessSyncChangeEnum)
	*p = x
	return p
}
