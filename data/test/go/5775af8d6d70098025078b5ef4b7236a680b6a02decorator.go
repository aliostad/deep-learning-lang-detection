// decorator
package main

type Process interface {
	addProcess(processName string)
	showAllProcess()
}

type AbstractProcess struct {
	processList []string
}

func (process *AbstractProcess) addProcess(processName string) {
	process.processList = append(process.processList, processName)
}

func (process *AbstractProcess) showAllProcess() {
	for _, v := range process.processList {
		print(v + "  ")
	}
	println()
}

type AdditionalProcess struct {
	AbstractProcess
	actualProcess Process
}

func (additionalProcess *AdditionalProcess) setActualProcess(actualProcess Process) {
	additionalProcess.actualProcess = actualProcess
}

type StandardProcess struct {
	AbstractProcess
}

func (process *StandardProcess) initize() {
	process.initizeProcess()
}

func (process *StandardProcess) initizeProcess() {
	process.addProcess("需求分析过程")
	process.addProcess("设计过程")
	process.addProcess("编码过程")
	process.addProcess("测试过程")
	process.addProcess("部署过程")
	process.addProcess("维护过程")
}

type DesignCheckProcess struct {
	AdditionalProcess
}

func (designCheckProcess *DesignCheckProcess) ConcreteActualProcess() {
	designCheckProcess.actualProcess.addProcess("设计检查")
}

type RequestVerificationProcess struct {
	AdditionalProcess
}

func (requestVerificationProcess *RequestVerificationProcess) ConcreteActualProcess() {
	requestVerificationProcess.actualProcess.addProcess("需求验证")
}

func main() {
	println("——————程序开始运行.————————")

	projectProcess := &StandardProcess{}
	projectProcess.initize()

	println("———项目的标准过程———")
	projectProcess.showAllProcess()

	println("———增加需求验证过程后的项目过程———")
	projectAddProcess1 := RequestVerificationProcess{}
	projectAddProcess1.setActualProcess(projectProcess)
	projectAddProcess1.ConcreteActualProcess()
	projectProcess.showAllProcess()

	println("———再增加设计检查过程后的项目过程———")
	projectAddProcess2 := DesignCheckProcess{}
	projectAddProcess2.setActualProcess(projectProcess)
	projectAddProcess2.ConcreteActualProcess()
	projectProcess.showAllProcess()

	println("——————程序运行结束.————————")
}
