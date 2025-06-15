import { type AnyMap, type HybridObject } from 'react-native-nitro-modules'

type Callback = (message: string, data?: AnyMap) => void
export interface RnEmitterModule
  extends HybridObject<{ ios: 'swift'; android: 'kotlin' }> {
  sum(num1: number, num2: number): number
  sendNativeEvent(message: string, data?: AnyMap): void
  addRNFromNativeListener(callback: Callback): number
  removeListener(id: number): void
}
