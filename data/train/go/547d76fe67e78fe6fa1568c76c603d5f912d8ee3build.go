package jacoco

import (
	"encoding/gob"
	"encoding/xml"
	"path/filepath"

	"github.com/godfried/impendulo/config"
	"github.com/godfried/impendulo/tool"
)

type (
	Project struct {
		XMLName     xml.Name    `xml:"project"`
		Name        string      `xml:"name,attr"`
		Default     string      `xml:"default,attr"`
		Namespace   string      `xml:"xmlns:jacoco,attr"`
		Description string      `xml:"description"`
		Properties  []*Property `xml:"property"`
		Taskdefs    []*Taskdef  `xml:"taskdef"`
		Targets     []*Target   `xml:"target"`
	}
	Property struct {
		Name     string `xml:"name,attr"`
		Value    string `xml:"value,attr,omitempty"`
		Location string `xml:"location,attr,omitempty"`
	}
	Taskdef struct {
		URI       string     `xml:"uri,attr"`
		Resource  string     `xml:"resource,attr"`
		Classpath *Classpath `xml:"classpath"`
	}
	Classpath struct {
		Elements []*PathElement `xml:"pathelement"`
	}
	PathElement struct {
		Path string `xml:"path,attr"`
	}
	Target struct {
		Name             string        `xml:"name,attr"`
		Depends          string        `xml:"depends,attr,omitempty"`
		Touch            *Touch        `xml:"touch"`
		Mkdir            *Mkdir        `xml:"mkdir"`
		Delete           *Delete       `xml:"delete"`
		Javac            *Javac        `xml:"javac"`
		InstrumentHolder *Instrument   `xml:"instrument"`
		InstrumentActual *Instrument   `xml:"jacoco:instrument"`
		JUnit            *JUnit        `xml:"junit"`
		ReportHolder     *JacocoReport `xml:"report"`
		ReportActual     *JacocoReport `xml:"jacoco:report"`
	}
	Javac struct {
		Classpath string `xml:"classpath,attr,omitempty"`
		Srcdir    string `xml:"srcdir,attr,omitempty"`
		Destdir   string `xml:"destdir,attr,omitempty"`
		Debug     bool   `xml:"debug,attr,omitempty"`
		Include   string `xml:"includeantruntime,attr,omitempty"`
	}
	Instrument struct {
		Destdir string     `xml:"destdir,attr,omitempty"`
		Fileset []*Fileset `xml:"fileset"`
	}
	Delete struct {
		Dir string `xml:"dir,attr"`
	}
	Mkdir struct {
		Dir string `xml:"dir,attr"`
	}
	Touch struct {
		File   string `xml:"file,attr"`
		Mkdirs bool   `xml:"mkdirs,attr"`
	}
	JUnit struct {
		Fork        bool        `xml:"fork,attr,omitempty"`
		ForkMode    string      `xml:"forkmode,attr,omitempty"`
		Tests       []*Test     `xml:"test"`
		Classpath   *Classpath  `xml:"classpath"`
		SysProperty SysProperty `xml:"sysproperty"`
		JVMArg      JVMArg      `xml:"jvmarg"`
	}
	JacocoReport struct {
		ExecutionData *ExecutionData `xml:"executiondata"`
		Structure     *Structure     `xml:"structure"`
		HTML          Dest           `xml:"html"`
		XML           Dest           `xml:"xml"`
	}
	ExecutionData struct {
		Files []*File `xml:"file"`
	}
	Structure struct {
		Name        string       `xml:"name,attr"`
		Classfiles  []*Fileset   `xml:"classfiles>fileset"`
		Sourcefiles *Sourcefiles `xml:"sourcefiles"`
	}
	Sourcefiles struct {
		Encoding string     `xml:"encoding,attr"`
		Files    []*Fileset `xml:"fileset"`
	}
	File struct {
		Path string `xml:"file,attr"`
	}
	Dest struct {
		Destdir  string `xml:"destdir,attr,omitempty"`
		Destfile string `xml:"destfile,attr,omitempty"`
	}
	Test struct {
		Name string `xml:"name,attr"`
	}
	SysProperty struct {
		Key  string `xml:"key,attr"`
		File string `xml:"file,attr"`
	}
	Fileset struct {
		Dir      string `xml:"dir,attr"`
		Includes string `xml:"includes,attr"`
	}
	JVMArg struct {
		Value string `xml:"value,attr"`
	}
)

const (
	BUILD_TEMPLATE = `<project name="" default="rebuild">
	<description>
	</description>
	<property name="data" value=""/>
        <property name="title" value="" />
	<property name="usertest" value="" />
	<property name="jacoco" location="" />
	<property name="junit" location="" />
	<property name="test.dir" location="" />
	<property name="src.dir" location="" />
	<property name="result.dir" location="" />
	<property name="result.test.classes.dir" location="${result.dir}/test-classes" />
	<property name="result.test.classes.instr.dir" location="${result.dir}/test-classes-instr" />
	<property name="result.src.classes.dir" location="${result.dir}/src-classes" />
	<property name="result.src.classes.instr.dir" location="${result.dir}/src-classes-instr" />
	<property name="result.report.dir" location="${result.dir}/report" />
	<property name="result.exec.file" location="${result.dir}/jacoco.exec" />
	<taskdef uri="antlib:org.jacoco.ant" resource="org/jacoco/ant/antlib.xml">
	<classpath>
		<pathelement path="${jacoco}/lib/jacocoant.jar" />
	</classpath>
	</taskdef>
	<target name="clean">
		<delete dir="${result.dir}" />
	</target>
	<target name="compile_src">
		  <mkdir dir="${result.src.classes.dir}" />
		  <javac classpath="${junit}" srcdir="${src.dir}" destdir="${result.src.classes.dir}" debug="true" includeantruntime="false" />
	</target>
	<target name="compile_test" depends="compile_src">
                <mkdir dir="${result.test.classes.dir}" />
		<javac classpath="${junit}:${result.src.classes.dir}" srcdir="${test.dir}" destdir="${result.test.classes.dir}" debug="true" includeantruntime="false" />
	</target>
	<target name="instrument_src" depends="compile_test">
                <instrument destdir="${result.src.classes.instr.dir}">
                        <fileset dir="${result.src.classes.dir}" includes="**/*.class" />
		</instrument>
	</target>
	<target name="instrument_test" depends="compile_test">
		<instrument destdir="${result.test.classes.instr.dir}">
		        <fileset dir="${result.test.classes.dir}" includes="**/*.class" />
		</instrument>
	</target>
	<target name="test" depends="instrument_src,instrument_test">
		<junit fork="true" forkmode="once">
                        <test name="${usertest}" />
			<classpath>
				<pathelement path="${jacoco}/lib/jacocoagent.jar" />
				<pathelement path="${result.test.classes.instr.dir}" />
				<pathelement path="${result.src.classes.instr.dir}" />
				<pathelement path="${junit}" />
			</classpath>
                        <sysproperty key="jacoco-agent.destfile" file="${result.exec.file}" />
			<jvmarg value="-Ddata.location=${data}"/>	
		</junit>
	</target>
	<target name="report" depends="test">
		<mkdir dir="${result.report.dir}/html" />
		<report>
			<executiondata>
			  <file file="${result.exec.file}" />
			</executiondata>
			<structure name="${title}">
			  <classfiles>
			  <fileset dir="${result.src.classes.dir}"/>
			  </classfiles>
			  <sourcefiles encoding="UTF-8">
			  <fileset dir="${src.dir}" />
			  </sourcefiles>
			</structure>
			<html destdir="${result.report.dir}/html" />
			<xml destfile="${result.report.dir}/report.xml" />
		</report>
	</target>
	<target name="rebuild" depends="clean,compile_test,compile_src,instrument_test,instrument_src,test,report" />
</project>
`
)

func init() {
	gob.Register(new(Project))
}

func NewProject(name, srcDir, resDir string, test *tool.Target) (*Project, error) {
	var e error
	var p *Project
	if e = xml.Unmarshal([]byte(BUILD_TEMPLATE), &p); e != nil {
		return nil, e
	}
	p.Namespace = "antlib:org.jacoco.ant"
	p.Name = name
	for _, t := range p.Targets {
		if t.ReportHolder != nil {
			t.ReportActual = t.ReportHolder
			t.ReportHolder = nil
		} else if t.InstrumentHolder != nil {
			t.InstrumentActual = t.InstrumentHolder
			t.InstrumentHolder = nil
		}
	}
	for _, pr := range p.Properties {
		switch pr.Name {
		case "data":
			pr.Value = filepath.Join(test.PackagePath(), "data")
		case "title":
			pr.Value = name
		case "usertest":
			pr.Value = test.Executable()
		case "jacoco":
			pr.Location, e = config.JACOCO_HOME.Path()
			if e != nil {
				return nil, e
			}
		case "junit":
			pr.Location, e = config.JUNIT.Path()
			if e != nil {
				return nil, e
			}
		case "src.dir":
			pr.Location = srcDir
		case "test.dir":
			pr.Location = test.Dir
		case "result.dir":
			pr.Location = resDir
		}
	}
	return p, nil
}
