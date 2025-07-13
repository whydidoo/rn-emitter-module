import Foundation
import NitroModules

struct RNListener<T> {
    let id: Double
    let callback: T
}


typealias RNMessageCallback = (_ msg: String, _ data: String?) -> Void

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
    
    func emitToNative(message: String, data: String?) throws -> Void {
        
        let parsedData: [String: Any] = {
            guard
                let json = data?.data(using: .utf8),
                let obj = try? JSONSerialization.jsonObject(with: json),
                let dict = obj as? [String: Any]
            else {
                return [:]
            }
            
            return dict
        }()

        NotificationCenter.default.post(
            name: NSNotification.Name("RNEmitterSend"),
            object: nil,
            userInfo: [
                "event": message,
                "data": parsedData
            ]
        )
    }
    
    func addNativeEventListener(callback: @escaping (String, String?) -> Void) throws -> Double {
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
        
        
        let dataJson: String? = {
            guard let data = userInfo["data"] as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return nil
            }
            return String(data: jsonData, encoding: .utf8)
        }()
        
        

        listeners.forEach { $0.callback(event, dataJson) }
    }
}
