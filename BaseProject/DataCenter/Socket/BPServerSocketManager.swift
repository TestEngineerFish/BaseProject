//
//  BPServerSocketManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

class BPServerSocketManager: NSObject, GCDAsyncSocketDelegate {

    var serverSocket: GCDAsyncSocket?
    var delegate: BPSocketProtocol?
    var clientSockets = [GCDAsyncSocket]()
    var clientHeartbeatTimeDict: [GCDAsyncSocket:TimeInterval]?
    var timer: Timer?

    func listen(toPort port: UInt16) {
        serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try serverSocket?.accept(onPort: port)
            self.delegate?.updateEvent("服务端监听端口: \(port) 成功")
            if !self.timer.isValid {
                self.addTimer()
            }
        } catch {
            self.delegate?.updateEvent("服务端监听失败")
        }
    }

    /// 添加计时器,记录当前Socket运行时间
      func addTimer() {
          timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            self.checkSocketConnect()
          }
          RunLoop.current.add(timer!, forMode: .common)
      }

    /// 发送消息到客户端
    /// - Parameter data: 数据对象
    func sendData(_ data: Data?) {
        guard let _data = data else {
            self.delegate?.updateEvent("服务端发送的消息不应为nil")
            return
        }
        self.clientSockets.forEach({ (clientSocket) in
            clientSocket.write(_data, withTimeout: -1, tag: 0)
        })
    }

    /// 客户端心跳检测,超过10秒没有收到客户端心跳消息,则自动断开
    func checkSocketConnect() {
        self.delegate?.updateEvent("开始检查连接设备是否有离线")
        self.clientHeartbeatTimeDict?.forEach({ (key, value) in
            let currentTime = Date().timeIntervalSinceNow
            if currentTime - value > 10 {
                self.clientHeartbeatTimeDict?.removeValue(forKey: key)
                self.delegate?.updateEvent("设备\(key.connectedHost ?? " unknow host ")已离线,从当前在线设备列表中移除")
            }
        })
    }

    /// 断开连接
    func disconnect() {
        self.serverSocket?.disconnect()
    }

    // TODO: GCDAsyncSocketDelegate
    /// 有新的Socket连接
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        self.clientSockets.append(newSocket)
        newSocket.readData(withTimeout: -1, tag: 0)
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: .utf8) ?? ""
        self.delegate?.updateEvent("服务端接收到数据: " + message)
        sock.readData(withTimeout: -1, tag: 0)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.serverSocket           = nil
        self.serverSocket?.delegate = nil
        self.clientSockets.removeAll()
        self.timer?.invalidate()
        self.timer = nil
        self.delegate?.updateEvent("服务端关闭Socket监听")
        self.delegate?.disconnectServerSocket()
    }



}
