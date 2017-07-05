//
//  HCSocketClient.swift
//  HCSocketProtocolBuf-Client
//
//  Created by UltraPower on 2017/7/3.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation
typealias Result = (_ tcpClient:TCPClient? ,_ success:Bool, _ content:String?) -> Void
class HCSocketClient {
    
    var address: String = ""
    var port: Int = 0
    
    static let socketClientManager = HCSocketClient()
    
    lazy var tcpClient: TCPClient = {
        return TCPClient()
    }()
    
    fileprivate init() {
        
    }
    
    static func socketClient(address: String, port: Int) -> HCSocketClient {
        socketClientManager.address = address
        socketClientManager.port = port
        return socketClientManager
    }
    
    func connect(result:(_ success: Bool) -> Void) -> HCSocketClient {
        tcpClient.addr = address
        tcpClient.port = port
        let connectResult = tcpClient.connect(timeout: 20)
        result(connectResult.0)
        return self
    }
    
    func sendMessage(message:String,result:Result) {
        let personBuild = Person.Builder()
        personBuild.id = 456
        personBuild.name = "client"
        personBuild.email = "houconghc@163.com"
        personBuild.info = message
        
        let person = try! personBuild.build()
        
        // 内容长度
        var personSize = person.data().count
        let sizeData = Data(bytes: &personSize, count: MemoryLayout.size(ofValue: personSize))
        print(personSize)
        let sendResult = tcpClient.send(data: sizeData + person.data())
        result(tcpClient, sendResult.0, sendResult.1)
    }
    
    func readMessage(result:@escaping Result) {
        DispatchQueue.global().async {
            
            var contentLength = 0
            let sizeOfInt = MemoryLayout.size(ofValue: contentLength)
            
            while true {

                guard let contentSize = self.tcpClient.read(sizeOfInt) else {
                    result(self.tcpClient, false, "读取内容失败")
                    return
                }
                
                let dataContent = NSData(bytes: contentSize, length: sizeOfInt)
                dataContent.getBytes(&contentLength, length: sizeOfInt)
                
                guard let content = self.tcpClient.read(contentLength) else {
                    result(self.tcpClient, false, "读取内容失败")
                    return
                }
                
                let data = Data(bytes: content)
                
                do {
                    let person = try Person.parseFrom(data: data)
                    result(self.tcpClient, true, person.info)
                } catch {
                    result(self.tcpClient, false, "protocolBuf解析失败")
                }
                
            }
        }
    }
}
