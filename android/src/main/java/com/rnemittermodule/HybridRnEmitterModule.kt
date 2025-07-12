package com.rnemittermodule

import com.margelo.nitro.core.AnyMap
import com.margelo.nitro.rnemittermodule.HybridRnEmitterModuleSpec

class HybridRnEmitterModule: HybridRnEmitterModuleSpec() {    
    override fun sum(num1: Double, num2: Double): Double {
        return num1 + num2
    }

    override fun sendNativeEvent(message: String, data: AnyMap?) {
        TODO("Not yet implemented")
    }

    override fun addRNFromNativeListener(callback: (message: String, data: AnyMap?) -> Unit): Double {
        TODO("Not yet implemented")
    }

    override fun removeListener(id: Double) {
        TODO("Not yet implemented")
    }

}
