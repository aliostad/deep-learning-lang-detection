package com.simplesys.isc.system

import com.simplesys.json.{JsonList, UnquotedString, JsonObject}
import com.simplesys.isc.system.misc._

object FileLoaderDyn {
    implicit def FileLoaderDyn2JsonObject(in: FileLoaderDyn): JsonObject = in json
}

class FileLoaderDyn(override val useSelfName: Boolean = false) extends ClassDyn with ClassDynInit {
    override val selfName = "FileLoader"

    override val fabriqueClass: Boolean = true

    def loadJSFiles(value: JsonList, onLoad: FunctionExpression) {
        setClassCommandEnqueue(s"loadJSFiles(${value.toString()}, ${onLoad.getExpr})")
    }

    def loadISC(skin: String = "", modules: JsonList = JsonList(), onLoad: FunctionExpression) {
        setClassCommandEnqueue(s"loadISC(${skin.toString()}, ${modules.toString()}, ${onLoad.getExpr})")
    }

    def loadSkin(skin: String = "", onLoad: FunctionExpression) {
        setClassCommandEnqueue(s"loadSkin(${skin.toString()}, ${onLoad.getExpr})")
    }
}