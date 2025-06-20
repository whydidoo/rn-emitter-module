///
/// HybridRnEmitterModuleSpec.cpp
/// This file was generated by nitrogen. DO NOT MODIFY THIS FILE.
/// https://github.com/mrousavy/nitro
/// Copyright © 2025 Marc Rousavy @ Margelo
///

#include "HybridRnEmitterModuleSpec.hpp"

namespace margelo::nitro::rnemittermodule {

  void HybridRnEmitterModuleSpec::loadHybridMethods() {
    // load base methods/properties
    HybridObject::loadHybridMethods();
    // load custom methods/properties
    registerHybrids(this, [](Prototype& prototype) {
      prototype.registerHybridMethod("sum", &HybridRnEmitterModuleSpec::sum);
      prototype.registerHybridMethod("sendNativeEvent", &HybridRnEmitterModuleSpec::sendNativeEvent);
      prototype.registerHybridMethod("addRNFromNativeListener", &HybridRnEmitterModuleSpec::addRNFromNativeListener);
      prototype.registerHybridMethod("removeListener", &HybridRnEmitterModuleSpec::removeListener);
    });
  }

} // namespace margelo::nitro::rnemittermodule
