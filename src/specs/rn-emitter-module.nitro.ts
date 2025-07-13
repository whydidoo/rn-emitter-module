import { type HybridObject } from 'react-native-nitro-modules'

type Callback = (message: string, data?: string) => void
export interface RnEmitterModule
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  emitToNative(message: string, data?: string): void
  addNativeEventListener(callback: Callback): number
  removeNativeEventListener(id: number): void
}
