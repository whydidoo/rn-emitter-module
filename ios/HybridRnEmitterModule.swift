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
    
    func emitToNative(message: String, data: AnyMapHolder?) throws -> Void {
        NotificationCenter.default.post(
            name: NSNotification.Name("RNEmitterSend"),
            object: nil,
            userInfo: [
                "event": message,
                "data": data ?? [:]
            ]
        )
    }
    
    func addNativeEventListener(callback: @escaping (String, AnyMapHolder?) -> Void) throws -> Double {
        currentListenerId += 1
        let listener = RNListener(id: currentListenerId, callback: callback)
        listeners.append(listener)
        return currentListenerId
    }
    
    func removeNativeEventListener(id: Double) throws -> Void {
        listeners.removeAll { $0.id == id }
    }
    
    @objc private func handleDidRespondToReactNative(_ notification: Notification) -> Void {
        guard let userInfo = notification.userInfo,
              let event = userInfo["event"] as? String else {
            return
        }
        
        

        if let data = userInfo["data"] as? [String: Any] {
            let anyMapHolder = AnyValueConverter.createMapHolder(from: data)
            listeners.forEach { $0.callback(event, anyMapHolder) }
        } else {
            listeners.forEach { $0.callback(event, nil) }
        }
    }
}
