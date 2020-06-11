package dwt.jport.writers

import dwt.jport.ast.TypeDeclaration

object TypeDeclarationWriter extends WriterObject[TypeDeclaration, TypeDeclarationWriter]

class TypeDeclarationWriter extends BodyDeclarationWriter[TypeDeclaration] with TypeParametersWriter[TypeDeclaration] {
  override def write(importWriter: ImportWriter, node: TypeDeclaration): Unit = {
    super.write(importWriter, node)

    writeModifiers
    writeDeclaration
    writeTypeParameters
    writeBases
    writeTemplateConstraints
    writeBody

    importWriter :+ node.imports
    buffer.increaseIndentation
  }

  override def postWrite(): Unit = buffer.decreaseIndentation.append('}', nl, nl)

  private def writeDeclaration = buffer.append(typeName, ' ', node.name)

  private def writeBases = {
    val bases = node.superclass ++ node.interfaces

    if (bases.nonEmpty)
      buffer.append(" : ").join(bases)
  }

  private def typeName = if (node.isInterface) "interface" else "class"

  private def writeBody = {
    if (node.hasMembers) buffer :+ nl else buffer :+ ' '
    buffer :+ '{'
    if (node.hasMembers) buffer :+ nl
  }
}
