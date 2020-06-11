package cn.isaac.code

import java.io.{File, PrintWriter}

import cn.isaac.content.Content

/**
  * Created by isaac on 17-8-17.
  */
object Model {

  def code(content: Content): Unit = {
    val target = new File(content.getModelPath())
    if (!target.exists()) {
      target.mkdirs()
    }

    for (t <- content.tables) {
      val writer = new PrintWriter(new File(content.getModelPath() + "/" + t.className +  ".java"))
      writer.write("package " + content.getProperty("pkg.model") + ";\n\n")

      var imports = t.getImportType()
      imports += "java.util.List"
      imports += "java.util.ArrayList"
      imports = imports.distinct.sorted
      for (v <- imports){
        writer.write("import " + v + ";\n")
      }
      writer.write("\n")

      writer.write("/**\n")
      writer.write(" * " + t.comment + "\n")
      writer.write(" */\n")
      writer.write("public class " + t.className + " {\n")

      for (c <- t.columns) {
        writer.write("    /**\n")
        writer.write("     * " + c.comment + "\n")
        writer.write("     */\n")
        writer.write("    private " + c.shortJavaType + " " + c.fieldName + ";\n\n")
      }

      writer.write("    /**\n")
      writer.write("     * 自定义条件\n")
      writer.write("     */\n")
      writer.write("    private List sqlCondition;\n\n")

      for (c <- t.columns) {
        writer.write("    public " + c.shortJavaType + " " + c.getFieldGetter() + "() {\n")
        writer.write("        return this." + c.fieldName + ";\n")
        writer.write("    }\n\n")

        writer.write("    public void " + c.getFieldSetter() + "(" + c.shortJavaType + " _" + c.fieldName + ") {\n")
        writer.write("        this." + c.fieldName + " = _" + c.fieldName + ";\n")
        writer.write("    }\n\n")
      }

      val str =
        """    public List getSqlCondition() {
        return sqlCondition;
    }

    public void setSqlCondition(List _sqlCondition) {
        this.sqlCondition = _sqlCondition;
    }

    public void addCondition(String condition) {
        if(sqlCondition == null || sqlCondition.isEmpty()) {
             sqlCondition = new ArrayList();
        }
        sqlCondition.add(condition);
    }
    """

      writer.write(str + "\n")

      writer.write("}")

      writer.close()
    }

  }
}
