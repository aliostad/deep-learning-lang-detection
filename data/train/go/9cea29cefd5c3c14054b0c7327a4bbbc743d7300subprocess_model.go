package goflow

//流程定义实体类
type SubProcessModel struct {
	WorkModel
	ProcessName string `xml:"processName,attr"` //子流程名称
	Version     int    `xml:"version,attr"`     //子流程版本号
}

//执行
func (p *SubProcessModel) Exec(execution *Execution) {
	p.RunOutTransition(execution)
}

//开始子流程处理
func StartSubProcessHandle(spm *SubProcessModel, execution *Execution) error {
	process := execution.Engine.GetProcessByVersion(spm.ProcessName, spm.Version)
	child := &Execution{
		Engine:         execution.Engine,
		Process:        process,
		Args:           execution.Args,
		ParentOrder:    execution.Order,
		ParentNodeName: spm.Name,
		Operator:       execution.Operator,
	}
	order := execution.Engine.StartInstanceByExecution(child)
	execution.Tasks = append(execution.Tasks, GetActiveTasksByOrderId(order.Id)...)
	return nil
}
