package com.rnemittermodule

import com.margelo.nitro.rnemittermodule.HybridRnEmitterModuleSpec

class HybridRnEmitterModule: HybridRnEmitterModuleSpec() {    
    override fun sum(num1: Double, num2: Double): Double {
        return num1 + num2
    }
}
