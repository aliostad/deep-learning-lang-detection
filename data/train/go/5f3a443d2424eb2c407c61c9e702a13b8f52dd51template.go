// template
package main

type ProjectProcess interface {
	// 可行性分析过程
	feasibilityProcess(content string)

	// 技术交流过程
	technicalDiscussionProcess(content string)

	// 投标过程
	bidProcess(content string)

	// 需求调研和分析过程
	requirementProcess(content string)

	// 设计过程
	designProcess(content string)

	// 编码过程
	programProcess(content string)

	// 测试过程
	testProcess(content string)

	// 部署和实施过程
	deploymentProcess(content string)

	// 维护过程
	maintenanceProcess(content string)

	// 具体工作
	doActualWork()

	// 展示内容
	showProcess()
}

type ProjectProcessTemplate struct {
	processMap map[string]string
}

func (projectProcessTemplate *ProjectProcessTemplate) init() {
	projectProcessTemplate.processMap = make(map[string]string)
}

// 可行性分析过程
func (projectProcessTemplate *ProjectProcessTemplate) feasibilityProcess(content string) {
	projectProcessTemplate.processMap["feasibilityProcess"] = content
}

// 技术交流过程
func (projectProcessTemplate *ProjectProcessTemplate) technicalDiscussionProcess(content string) {
	projectProcessTemplate.processMap["technicalDiscussionProcess"] = content
}

// 投标过程
func (projectProcessTemplate *ProjectProcessTemplate) bidProcess(content string) {
	projectProcessTemplate.processMap["bidProcess"] = content
}

// 需求调研和分析过程
func (projectProcessTemplate *ProjectProcessTemplate) requirementProcess(content string) {
	projectProcessTemplate.processMap["requirementProcess"] = content
}

// 设计过程
func (projectProcessTemplate *ProjectProcessTemplate) designProcess(content string) {
	projectProcessTemplate.processMap["designProcess"] = content
}

// 编码过程
func (projectProcessTemplate *ProjectProcessTemplate) programProcess(content string) {
	projectProcessTemplate.processMap["programProcess"] = content
}

// 测试过程
func (projectProcessTemplate *ProjectProcessTemplate) testProcess(content string) {
	projectProcessTemplate.processMap["testProcess"] = content
}

// 部署和实施过程
func (projectProcessTemplate *ProjectProcessTemplate) deploymentProcess(content string) {
	projectProcessTemplate.processMap["deploymentProcess"] = content
}

// 维护过程
func (projectProcessTemplate *ProjectProcessTemplate) maintenanceProcess(content string) {
	projectProcessTemplate.processMap["maintenanceProcess"] = content
}

// 展示内容
func (projectProcessTemplate *ProjectProcessTemplate) showProcess() {
	for topic := range projectProcessTemplate.processMap {
		println("过程名称是:" + topic + ",对应的内容是:" + projectProcessTemplate.processMap[topic])
	}
}

type ProjectA struct {
	ProjectProcessTemplate
}

// 具体工作
func (projectA *ProjectA) doActualWork() {
	projectA.feasibilityProcess("定制可行性研究")
	projectA.technicalDiscussionProcess("定制技术交流")
	projectA.bidProcess("定制投标")
	projectA.requirementProcess("定制需求")
	projectA.designProcess("定制设计")
	projectA.programProcess("定制编码")
	projectA.testProcess("定制测试")
	projectA.deploymentProcess("定制部署")
	projectA.maintenanceProcess("定制维护")
}

type ProjectB struct {
	ProjectProcessTemplate
}

// 具体工作
func (projectB *ProjectB) doActualWork() {
	projectB.requirementProcess("定制需求")
	projectB.designProcess("定制设计")
	projectB.programProcess("定制编码")
	projectB.testProcess("定制测试")
	projectB.deploymentProcess("定制部署")
	projectB.maintenanceProcess("定制维护")
}

func main() {
	println("——————程序开始运行.————————")

	println("———projectA的过程———")
	project1 := ProjectA{}
	project1.init()
	project1.doActualWork()
	project1.showProcess()

	println("———projectB的过程———")
	project2 := ProjectB{}
	project2.init()
	project2.doActualWork()
	project2.showProcess()

	println("——————程序运行结束.————————")
}
