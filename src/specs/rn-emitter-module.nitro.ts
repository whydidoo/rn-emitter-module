import { type AnyMap, type HybridObject } from 'react-native-nitro-modules'

type Callback = (message: string, data?: AnyMap) => void
export interface RnEmitterModule
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  emitToNative(message: string, data?: AnyMap): void
  addNativeEventListener(callback: Callback): number
  removeNativeEventListener(id: number): void
}
