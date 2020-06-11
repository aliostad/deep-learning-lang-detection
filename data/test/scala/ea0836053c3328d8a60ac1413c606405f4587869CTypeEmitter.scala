package scalapipe.gen

import scalapipe._

private[gen] class CTypeEmitter extends CGenerator {

    private var emitted = Set[ValueType]()

    def emit(vt: ValueType) {
        if (!emitted.contains(vt)) {
            emitted += vt
            vt.dependencies.foreach(emit(_))
            val name = vt.name
            vt match {
                case at: ArrayValueType =>
                    val itype = at.itemType
                    val alength = at.length
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef struct")
                    enter
                    write(s"$itype values[$alength];")
                    leave
                    write(s"$name;")
                    write(s"#endif")
                case td: TypeDefValueType =>
                    val tvalue = td.value
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef $tvalue $name;")
                    write(s"#endif")
                case pt: PointerValueType =>
                    val iname = pt.itemType.name
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef $iname *$name;")
                    write(s"#endif")
                case ft: FixedValueType =>
                    val btype = ft.baseType
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef $btype $name;")
                    write(s"#endif")
                case st: StructValueType =>
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef struct")
                    enter
                    for ((fn, ft) <- st.fieldNames.zip(st.fieldTypes)) {
                        write(s"$ft $fn;")
                    }
                    leave
                    write(s"$name;")
                    write(s"#endif")
                case ut: UnionValueType =>
                    write(s"#ifndef DECLARED_$name")
                    write(s"#define DECLARED_$name")
                    write(s"typedef union")
                    enter
                    for ((fn, ft) <- ut.fieldNames.zip(ut.fieldTypes)) {
                        write(s"$ft $fn;")
                    }
                    leave
                    write(s"$name;")
                    write(s"#endif")
                case _ =>
                    write(s"/* $name */")
            }
        }
    }

}
