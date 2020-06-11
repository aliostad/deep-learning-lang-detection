package goflow

import (
	"time"
	"fmt"
)

//流程服务
type ProcessService struct {
	ProcessCache           map[string]*Process     //Process缓存，KEY为[名称.版本]
	NameCache              map[string]string       //ProcessName缓存，KEY为ID
	InnerInterceptorCache  map[string]IInterceptor //内置拦截器
	CustomInterceptorCache map[string]IInterceptor //自定义拦截器
}

//初始化服务对象和加入内置拦截器
func (p *ProcessService) InitProcessService() {
	p.ProcessCache = make(map[string]*Process)
	p.NameCache = make(map[string]string)
	p.InnerInterceptorCache = make(map[string]IInterceptor)
	p.CustomInterceptorCache = make(map[string]IInterceptor)

	p.SetInnerInterceptor(&SurrogateInterceptor{})
}

//使用自定义拦截器缓存
func (p *ProcessService) SetCustomInterceptor(interceptor IInterceptor) {
	p.CustomInterceptorCache[interceptor.GetName()] = interceptor
}

//获取自定义缓存拦截器
func (p *ProcessService) GetCustomInterceptor(name string) IInterceptor {
	if interceptor, ok := p.CustomInterceptorCache[name]; ok {
		return interceptor
	}
	return nil
}

//使用拦截器缓存
func (p *ProcessService) SetInnerInterceptor(interceptor IInterceptor) {
	fmt.Println("ProcessService 使用拦截器缓存")
	p.InnerInterceptorCache[interceptor.GetName()] = interceptor
}

//获取缓存拦截器
func (p *ProcessService) GetInnerInterceptor(name string) IInterceptor {
	fmt.Println("ProcessService 获取缓存拦截器")
	if interceptor, ok := p.InnerInterceptorCache[name]; ok {
		return interceptor
	}
	return nil
}

//缓存Process
func (p *ProcessService) Cache(process *Process) {
	fmt.Println("ProcessService 缓存Process")
	processName := process.Name + DEFAULT_SEPARATOR + IntToStr(process.Version)
	delete(p.ProcessCache, processName)

	if process.Model == nil {
		processModel := &ProcessModel{}
		processModel.BuildRelationship([]byte(process.Content), p)
		process.SetModel(processModel)
	}

	processName = process.Name + DEFAULT_SEPARATOR + IntToStr(process.Version)
	p.ProcessCache[processName] = process
	p.NameCache[process.Id] = processName
}

//部署Process
func (p *ProcessService) Deploy(input []byte, creator string) string {
	fmt.Println("ProcessService 部署Process")
	processModel := &ProcessModel{}
	processModel.BuildRelationship(input, p)
	fmt.Println("设定model对象->", processModel)
	ver := -1
	oldProcess := GetLatestProcess(processModel.Name)
	fmt.Println("oldProcess->", oldProcess)
	if oldProcess != nil {
		ver = oldProcess.Version
	}

	process := &Process{
		Id:         NewUUID(),
		State:      FS_ACTIVITY,
		Content:    string(input),
		Creator:    creator,
		CreateTime: time.Now(),
		Version:    ver + 1,
	}
	process.SetModel(processModel)  // 设定model对象
	p.Cache(process)  // 缓存process
	Save(process, process.Id) // 保存实体对象

	return process.Id
}

//重新部署Process
func (p *ProcessService) ReDeploy(id string, input []byte) {
	fmt.Println("ProcessService 重新部署Process")
	process := &Process{}
	success := process.GetProcessById(id)

	if success {
		process.Content = string(input)
		p.Cache(process)
		Update(process, process.Id)
	}
}

//卸载部署
func (p *ProcessService) UnDeploy(id string) {
	fmt.Println("ProcessService 卸载部署")
	process := &Process{}
	success := process.GetProcessById(id)

	if success {
		process.State = FS_FINISH
		p.Cache(process)
		Update(process, process.Id)
	}
}

//根据ID得到Process
func (p *ProcessService) GetProcessById(id string) *Process {
	fmt.Println("ProcessService 根据ID得到Process")
	processName := p.NameCache[id]
	process := p.ProcessCache[processName]

	if process == nil {
		process = &Process{}
		if process.GetProcessById(id) {
			p.Cache(process)
			return process
		} else {
			return nil
		}
	} else {
		return process
	}
}

//根据名称、版本得到Process
func (p *ProcessService) GetProcessByVersion(name string, version int) *Process {
	fmt.Println("ProcessService 根据名称、版本得到Process")
	ver := version
	if ver == -1 {
		dbProcess := GetLatestProcess(name)
		if dbProcess == nil {
			return nil
		} else {
			ver = dbProcess.Version
		}
	}

	processName := name + DEFAULT_SEPARATOR + IntToStr(ver)
	process := p.ProcessCache[processName]
	if process == nil {
		process = &Process{
			Name:    name,
			Version: ver,
		}
		success := process.GetProcess()
		if success {
			p.Cache(process)
			return process
		} else {
			return nil
		}
	} else {
		return process
	}
}
