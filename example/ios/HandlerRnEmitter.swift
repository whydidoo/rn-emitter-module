//
//  HandlerRnEmitter.swift
//  RnEmitterModuleExample
//
//  Created by amir.saifutdinov on 12/07/2025.
//



import Foundation

final class HandlerRnEmitter {
  static let shared = HandlerRnEmitter()

  struct HandlerWrapper {
    let callback: ([String: Any]) -> Any
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

  func register(event: String, shouldRespond: Bool = true, callback: @escaping ([String: Any]) -> Any) {
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

    if let handlerWrapper = handlers[event] {
      let result = handlerWrapper.callback(data)

      if handlerWrapper.shouldRespond {
        let response = [
          "event": event,
          "data": result
        ] as [String: Any]

        NotificationCenter.default.post(
          name: NSNotification.Name("RNEmitterResponse"),
          object: nil,
          userInfo: response
        )
      }
    } else {
      print("⚠️ No registered handler for the event '\(event)'")
    }
  }
}
