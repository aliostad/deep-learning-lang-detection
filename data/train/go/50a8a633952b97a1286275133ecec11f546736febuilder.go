// builder
package main

type AbstractProjectProcessBuilder struct {
	processList []string
}

func (builder *AbstractProjectProcessBuilder) showProcess() {
	for _, v := range builder.processList {
		print(v + "  ")
	}
	println()
}

type ConcreteProjectProcessBuilder struct {
	AbstractProjectProcessBuilder
}

//可行性分析过程
func (builder *ConcreteProjectProcessBuilder) buildFeasibility() {
	builder.processList = append(builder.processList, "可行性分析过程")
}

//技术交流过程
func (builder *ConcreteProjectProcessBuilder) buildTechnicalDiscussion() {
	builder.processList = append(builder.processList, "技术交流过程")
}

//投标过程
func (builder *ConcreteProjectProcessBuilder) buildBid() {
	builder.processList = append(builder.processList, "投标过程")
}

//需求调研和分析过程
func (builder *ConcreteProjectProcessBuilder) buildRequirement() {
	builder.processList = append(builder.processList, "需求调研和分析过程")
}

//设计过程
func (builder *ConcreteProjectProcessBuilder) buildDesign() {
	builder.processList = append(builder.processList, "设计过程")
}

//编码过程
func (builder *ConcreteProjectProcessBuilder) buildProgram() {
	builder.processList = append(builder.processList, "编码过程")
}

//测试过程
func (builder *ConcreteProjectProcessBuilder) buildTest() {
	builder.processList = append(builder.processList, "测试过程")
}

//部署和实施过程
func (builder *ConcreteProjectProcessBuilder) buildDeployment() {
	builder.processList = append(builder.processList, "部署和实施过程")
}

//维护过程
func (builder *ConcreteProjectProcessBuilder) buildMaintenance() {
	builder.processList = append(builder.processList, "维护过程")
}

type Project struct {
	builder ConcreteProjectProcessBuilder
}

func (project *Project) setBuilder(builder ConcreteProjectProcessBuilder) {
	project.builder = builder
}

func (project *Project) Construct() {
	project.builder.buildRequirement()
	project.builder.buildDesign()
	project.builder.buildProgram()
	project.builder.buildTest()
	project.builder.buildDeployment()
	project.builder.buildMaintenance()
}

func (project *Project) showProcess() {
	project.builder.showProcess()
}

func main() {
	println("——————程序开始运行.————————")

	bulider := ConcreteProjectProcessBuilder{}
	project := Project{bulider}
	project.Construct()
	project.showProcess()

	println("——————程序运行结束.————————")
}
