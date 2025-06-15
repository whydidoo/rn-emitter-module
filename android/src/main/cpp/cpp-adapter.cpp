#include <jni.h>
#include "RnEmitterModuleOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::rnemittermodule::initialize(vm);
}
