import Foundation

final class NativeEmitterBridge {
  static let shared = NativeEmitterBridge()

  struct HandlerWrapper {
    let callback: ([String: Any]) -> Void
    let shouldRespond: Bool
  }

  private var handlers: [String: HandlerWrapper] = [:]

  private init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleRnEmitterSend(_:)),
      name: NSNotification.Name("RNEmitterSend"),
      object: nil
    )
  }

  func register(event: String, shouldRespond: Bool = true, callback: @escaping ([String: Any]) -> Void) {
    handlers[event] = HandlerWrapper(callback: callback, shouldRespond: shouldRespond)
  }

  func unregister(event: String) {
    handlers.removeValue(forKey: event)
  }

  func clearAllHandlers() {
    handlers.removeAll()
  }

  @objc private func handleRnEmitterSend(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let event = userInfo["event"] as? String,
          let data = userInfo["data"] as? [String: Any] else {
      return
    }

    print("📥 NativeEmitterBridge получил: \(event) — \(data)")

    if let handlerWrapper = handlers[event] {
      handlerWrapper.callback(data)

      if handlerWrapper.shouldRespond {
        let response = [
          "event": event + "_response",
          "data": [
            "status": "ok",
            "echo": data
          ]
        ] as [String: Any]

        NotificationCenter.default.post(
          name: NSNotification.Name("RNEmitterResponse"),
          object: nil,
          userInfo: response
        )
      }
    } else {
      print("⚠️ Нет зарегистрированного обработчика для события '\(event)'")
    }
  }
}
