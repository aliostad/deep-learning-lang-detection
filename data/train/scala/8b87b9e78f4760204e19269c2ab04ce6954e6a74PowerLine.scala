package technic.powernet

import technic.core.NetworkElement

import scala.collection.mutable.ArrayBuffer

/**
 * Created by Bohdan on 07/05/15.
 */
class PowerLine(network:PowerNet) {
    var elements = Array[NetworkElement]()
    var start_voltage:Float = 0
    var end_voltage:Float = 0
    var end_node:NetworkElement = null
    var current_load:Float = 0
    var power_coefficient:Float = 1.0F

    def apply_load(load:Float) {
        if (current_load > 0) remove_load()
        current_load = load
        for (e <- elements) {
            e.apply_load(current_load)
        }
    }

    def delivered_load():Float={
        current_load * power_coefficient
    }

    def consumed_load():Float={
        // ((13/0.8)*1000)/(1.73*380)
        ((current_load / power_coefficient)*1000)/(1.73F*start_voltage)
    }

    def remove_load() {
        if (current_load == 0) return
        for (e <- elements) {
            e.remove_load(current_load)
        }
        current_load = 0
    }

    def add_elements(els:Array[NetworkElement]) {
        this.elements = els
        for (e <- els) {
            e.power_lines :+ this
            e.markForUpdate()
        }
    }
}
