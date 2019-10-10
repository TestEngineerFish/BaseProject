//
//  BPSocketManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

protocol BPSocketProtocol {
    func updateEvent(_ log: String)
    func disconnectServerSocket()
    func disconnectClientSocket()
}

class BPSocketManager: NSObject, GCDAsyncSocketDelegate {

    var clientSocket: GCDAsyncSocket!
    var timer: Timer?
    var delegate: BPSocketProtocol?

    /// 开始连接
    /// - Parameter host: 服务器IP地址
    /// - Parameter port: 服务器Socket监听的端口号
    func connection(toHost host: String, onPort port: UInt16) {
        clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try clientSocket?.connect(toHost: host, onPort: port, viaInterface: nil, withTimeout: -1)
            self.delegate?.updateEvent("准备连接")
        } catch {
            self.delegate?.updateEvent("连接错误,请重试")
            self.delegate?.updateEvent("错误日志:\n" + error.localizedDescription)
        }
    }

    /// 发送数据
    /// - Parameter data: 数据对象
    func sendData(_ data: Data?) {
        guard let _data = data else {
            self.delegate?.updateEvent("发送的数据不应为nil")
            return
        }
        self.clientSocket.write(_data, withTimeout: -1, tag: 0)
        self.delegate?.updateEvent("客户端消息发送成功")
    }

    /// 断开连接
    func disconnect() {
        self.clientSocket?.disconnect()
    }

    /// 添加计时器
    func addTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
            let data = String(format: "%@", "heartbeat test: \(timer.timeInterval)").data(using: .utf8)
            self.delegate?.updateEvent("准备发送心跳消息")
            self.sendData(data)
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    //TODO: GCDAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.delegate?.updateEvent(String(format: "连接到主机: %@:%d", host, port))
        self.clientSocket.readData(withTimeout: -1, tag: 0)
        self.addTimer()
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let dataStr = String(data: data, encoding: .utf8) ?? ""
        self.delegate?.updateEvent("客户端接收到数据: " + dataStr)
        sock.readData(withTimeout: -1, tag: 0)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.clientSocket           = nil
        self.clientSocket?.delegate = nil
        self.timer?.invalidate()
        self.timer = nil
        self.delegate?.updateEvent("客户端断开Socket连接")
        self.delegate?.disconnectClientSocket()
    }

}
