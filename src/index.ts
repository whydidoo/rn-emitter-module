import { NitroModules } from 'react-native-nitro-modules'
import type { RnEmitterModule as RnEmitterModuleSpec } from './specs/rn-emitter-module.nitro'

export const RnEmitterModule =
  NitroModules.createHybridObject<RnEmitterModuleSpec>('RnEmitterModule')