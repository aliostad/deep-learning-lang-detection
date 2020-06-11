package eliaslevy.samza.job.kubernetes

import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory
import java.io.StringWriter

object KubernetesReplicationController {

	def toYAML(
		name: 					String, 
		containerId: 		Integer, 
		containerImage: String,
		nodeSelector:		Map[String, String],
		memoryLimit:		String,
		cpuLimit:				String,
		javaOpts: 			String,
		jobConfig: 			String
	): String = {
    val factory = new YAMLFactory()
    val writer  = new StringWriter()
    val gen     = factory.createGenerator(writer)
    val newname = name.replace('_', '-')

		gen.writeStartObject()
    gen.writeStringField("apiVersion", "v1")
    gen.writeStringField("kind", "ReplicationController")
    writeRCMetadata(gen, newname, containerId)
    writeRCSpec(gen, newname, containerId, containerImage, nodeSelector, memoryLimit, cpuLimit, javaOpts, jobConfig)
    gen.writeEndObject()
    gen.close()

    writer.toString()
	}

	private def writeRCMetadata(gen: JsonGenerator, name: String, containerId: Integer): Unit = {
		gen.writeFieldName("metadata")
		gen.writeStartObject()
		gen.writeStringField("name", name + "-" + containerId.toString())
		gen.writeEndObject()
	}

	private def writeRCSpec(
		gen: 						JsonGenerator, 
		name: 					String, 
		containerId: 		Integer, 
		containerImage: String, 
		nodeSelector:		Map[String, String],
		memoryLimit:		String,
		cpuLimit:				String,
		javaOpts: 			String,
		jobConfig: 			String
	): Unit = {
		gen.writeFieldName("spec")
		gen.writeStartObject()
    gen.writeNumberField("replicas", 1)
    writePodTemplate(gen, name, containerId, containerImage, nodeSelector, memoryLimit, cpuLimit, javaOpts, jobConfig)
		gen.writeEndObject()
	}

	private def writePodTemplate(
		gen: 						JsonGenerator, 
		name: 					String, 
		containerId: 		Integer, 
		containerImage: String, 
		nodeSelector:		Map[String, String],
		memoryLimit:		String,
		cpuLimit:				String,
		javaOpts: 			String,
		jobConfig: 			String
	): Unit = {
		gen.writeFieldName("template")
		gen.writeStartObject()
		writePodMetadata(gen, name, containerId)
    writePodSpec(gen, name, containerId, containerImage, nodeSelector, memoryLimit, cpuLimit, javaOpts, jobConfig)
		gen.writeEndObject()
	}

	private def writePodMetadata(gen: JsonGenerator, name: String, containerId: Integer): Unit = {
		gen.writeFieldName("metadata")
		gen.writeStartObject()
		gen.writeFieldName("labels")
		gen.writeStartObject()
		gen.writeStringField("app", name)
		gen.writeStringField("container-id", containerId.toString())
		gen.writeEndObject()
		gen.writeEndObject()
	}

	private def writePodSpec(
		gen: 						JsonGenerator, 
		name: 					String,
		containerId: 		Integer,
		containerImage: String,
		nodeSelector:		Map[String, String],
		memoryLimit:		String,
		cpuLimit:				String,
		javaOpts: 			String,
		jobConfig: 			String
	): Unit = {
		gen.writeFieldName("spec")
		gen.writeStartObject()
		writePodNodeSelector(gen, nodeSelector)
		writePodVolumes(gen)
		writePodContainers(gen, name, containerId, containerImage, memoryLimit, cpuLimit, javaOpts, jobConfig)
		gen.writeEndObject()
	}

	private def writePodNodeSelector(gen: JsonGenerator, nodeSelector: Map[String, String]): Unit = {
		if (!nodeSelector.isEmpty) {
			gen.writeFieldName("nodeSelector")
			gen.writeStartObject()

			nodeSelector.foreach { tagVal => gen.writeStringField(tagVal._1, tagVal._2) }

			gen.writeEndObject
		}
	}

	private def writePodContainers(
		gen: 						JsonGenerator, 
		name: 					String,
		containerId: 		Integer, 
		containerImage: String, 
		memoryLimit: 		String, 
		cpuLimit: 			String, 
		javaOpts: 			String,
		jobConfig: 			String
	): Unit = {
		gen.writeFieldName("containers")
		gen.writeStartArray()

		gen.writeStartObject()
		gen.writeStringField("name", name)
		gen.writeStringField("image", containerImage)
		writeContainerEnv(gen, containerId, javaOpts, jobConfig)
		writeContainerVolumeMounts(gen)
		writeContainerResources(gen, memoryLimit, cpuLimit)
		gen.writeEndObject()

		gen.writeEndArray()
	}

	private def writePodVolumes(gen: JsonGenerator): Unit = {
		gen.writeFieldName("volumes")
		gen.writeStartArray()

		gen.writeStartObject()
		gen.writeStringField("name", "log")
		gen.writeFieldName("emptyDir")
		gen.writeStartObject()
		gen.writeEndObject()
		gen.writeEndObject()

		gen.writeStartObject()
		gen.writeStringField("name", "state")
		gen.writeFieldName("emptyDir")
		gen.writeStartObject()
		gen.writeEndObject()
		gen.writeEndObject()

		gen.writeEndArray()
	}

	private def writeContainerEnv(
		gen: 					JsonGenerator, 
		containerId: 	Integer, 
		javaOpts: 		String, 
		jobConfig: 		String
	): Unit = {
		gen.writeFieldName("env")
		gen.writeStartArray()

		gen.writeStartObject()
		gen.writeStringField("name", "SAMZA_CONTAINER_ID")
		gen.writeStringField("value", containerId.toString())
		gen.writeEndObject()

		gen.writeStartObject()
		gen.writeStringField("name", "SAMZA_JOB_CONFIG")
		gen.writeStringField("value", jobConfig)
		gen.writeEndObject()

		gen.writeStartObject()
		gen.writeStringField("name", "JAVA_OPTS")
		gen.writeStringField("value", javaOpts)
		gen.writeEndObject()

		gen.writeEndArray()
	}

	private def writeContainerVolumeMounts(gen: JsonGenerator): Unit = {
		gen.writeFieldName("volumeMounts")
		gen.writeStartArray()

		gen.writeStartObject()
		gen.writeStringField("mountPath", "/log")
		gen.writeStringField("name", "log")
		gen.writeEndObject()

		gen.writeStartObject()
		gen.writeStringField("mountPath", "/samza/state")
		gen.writeStringField("name", "state")
		gen.writeEndObject()

		gen.writeEndArray()
	}

	private def writeContainerResources(gen: JsonGenerator, memoryLimit: String, cpuLimit: String): Unit = {
		gen.writeFieldName("resources")
		gen.writeStartObject()

		gen.writeFieldName("limits")
		gen.writeStartObject()
		gen.writeStringField("memory", memoryLimit)
		gen.writeStringField("cpu", cpuLimit)
		gen.writeEndObject()

		gen.writeEndObject()
	}
}