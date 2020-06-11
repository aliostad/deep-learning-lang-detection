package yamldict
import fileIO._

class OutputYamlDict(outfile: String) {
	val INDENT = "  "

	def output(dict: AnyRef) {
		dict match {
			case _: NounDict#NounDict =>
				this.outputNounYaml(dict.asInstanceOf[NounDict#NounDict])
			case _: VerbDict#Dict =>
				this.outputVerbYaml(dict.asInstanceOf[VerbDict#Dict])
      case _: VerbArgDict#Dict =>
        this.outputVerbArgYaml(dict.asInstanceOf[VerbArgDict#Dict])
			case _ =>
		}
	}

	def outputNounYaml(dict: NounDict#NounDict) {
		val file = new OutputFiles(outfile)
		file.write(INDENT * 0 + "---")
		file.write(INDENT * 0 + "dict:")
		for (frame <- dict.frames) {
			file.write(INDENT * 0 + "- head: " + frame.head)
			file.write(INDENT * 0 + "  support: " + frame.support)
			file.write(INDENT * 0 + "  instance: ")
			for (instance <- frame.instances) {
				file.write(INDENT * 1 + "- cases:")
				for (ncase <- instance.cases) {
					file.write(INDENT * 2 + "- noun: " + ncase.noun)
					file.write(INDENT * 2 + "  part: " + ncase.part)
					file.write(INDENT * 2 + "  category: " + ncase.category)
					file.write(INDENT * 2 + "  semrole: " + ncase.semrole)
					file.write(INDENT * 2 + "  arg: " + ncase.arg)
				}
				if (instance.agents.nonEmpty) {
					file.write(INDENT * 1 + "  agent:")
					for (agent <- instance.agents) {
						file.write(INDENT * 2 + "- agentive: " + agent.agentive)
						file.write(INDENT * 2 + "  semantic: " + agent.semantic)
						file.write(INDENT * 2 + "  arg0: " + agent.arg0)
						file.write(INDENT * 2 + "  arg1: " + agent.arg1)
						file.write(INDENT * 2 + "  arg2: " + agent.arg2)
					}
				}
			}
		}
		file.close
	}

	def outputVerbYaml(dict: VerbDict#Dict) {
		val file = new OutputFiles(outfile)
		file.write("---")
		file.write("dict:")
		for (frame <- dict.frames) {
			file.write("- verb: " + frame.verb)
			file.write("  frame: ")
			for (semantic <- frame.semantics) {
				file.write("  - semantic: " + semantic.semantic)
				file.write("    instance: ")
				for (instance <- semantic.instances) {
					if (instance.cases.nonEmpty) file.write("    - cases: ")
					for (cas <- instance.cases) {
						file.write("      - part: " + cas.part)
						if (cas.causative_part.nonEmpty) file.write("        causative_part: " + cas.causative_part)
						if (cas.passive_part.nonEmpty) file.write("        passive_part: " + cas.passive_part)
						file.write("        noun: " + cas.noun)
						file.write("        category: " + cas.category)
						file.write("        semrole: " + cas.semrole)
						file.write("        weight: " + cas.weight)
					}
				}
			}
		}
		file.close
	}
  
  def outputVerbArgYaml(dict: VerbArgDict#Dict) {
    val file = new OutputFiles(outfile)
    file.write("---")
    file.write("dict:")
    for (frame <- dict.frames) {
      file.write("- verb: " + frame.verb)
      file.write("  frame: ")
      for (semantic <- frame.semantics) {
        file.write("  - semantic: " + semantic.semantic)
        file.write("    instance: ")
        for (instance <- semantic.instances) {
          if (instance.cases.nonEmpty) file.write("    - cases: ")
          for (cas <- instance.cases) {
            file.write("      - part: " + cas.part)
            if (cas.causative_part.nonEmpty) file.write("        causative_part: " + cas.causative_part)
            if (cas.passive_part.nonEmpty) file.write("        passive_part: " + cas.passive_part)
            file.write("        noun: " + cas.noun)
            file.write("        category: " + cas.category)
            file.write("        semrole: " + cas.semrole)
            file.write("        arg: " + cas.arg)
            file.write("        weight: " + cas.weight)
          }
        }
      }
    }
    file.close
  }
}