import Foundation
import NitroModules

struct RNListener<T> {
    let id: Double
    let callback: T
}


typealias RNMessageCallback = (_ msg: String, _ data: AnyMapHolder?) -> Void

class HybridRnEmitterModule: HybridRnEmitterModuleSpec {
    
    
    private var currentListenerId: Double = 0
    private var listeners: [RNListener<RNMessageCallback>] = []

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidRespondToReactNative(_:)),
            name: NSNotification.Name("RNEmitterResponse"),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func sum(num1: Double, num2: Double) throws -> Double {
        return num1 + num2
    }

    func sendNativeEvent(message: String, data: AnyMapHolder?) throws -> Void {
        print(message)
        
        NotificationCenter.default.post(
            name: NSNotification.Name("RNEmitterSend"),
            object: nil,
            userInfo: [
                "event": message,
                "data": data ?? [:]
            ]
        )
    }

    func addRNFromNativeListener(callback: @escaping RNMessageCallback) throws -> Double {
        currentListenerId += 1
        let listener = RNListener(id: currentListenerId, callback: callback)
        listeners.append(listener)
        return currentListenerId
    }

     func removeListener(id: Double) throws -> Void {
         listeners.removeAll { $0.id == id }
     }

    @objc private func handleDidRespondToReactNative(_ notification: Notification) -> Void {
        guard let userInfo = notification.userInfo,
              let event = userInfo["event"] as? String else {
            return
        }

        let data = userInfo["data"] as? AnyMapHolder
        listeners.forEach { $0.callback(event, data) }
    }
}
