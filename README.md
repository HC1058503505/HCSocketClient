# HCSocketClient
HCSocketClient ProtocolBuffer

> 该Demo是基于Swift 3.1来实现的，使用了开源的**ysocket**以及**ProtocolBuffers-Swift**。服务端请穿越到![HCSocketServer](https://github.com/HC1058503505/HCSocketServer)

# HCSocketClient的使用
```swift
// 链式编程
// socket的连接，信息读取
HCSocketClient.socketClient(address: "172.16.40.33", port: 8888)
            .connect { (success) in
                if !success {
                    self.connectStatus.stringValue = "连接失败"
                    return
                }
                connectStatus.stringValue = "连接成功"
            }
            .readMessage { (client, success, content) in
                DispatchQueue.main.async {
                    self.server.string = self.server.string! + "\nFriend:" + content!
                }
                print(success)
        }

// socket信息的发送
 @IBAction func sendAction(_ sender: NSButton) {
        
        if message.stringValue.characters.count == 0 {
            return
        }
        
        HCSocketClient.socketClientManager.sendMessage(message: message.stringValue) { (client, success, content) in
            if success {
                server.string = server.string! + "\nME:" + message.stringValue
                message.stringValue = ""
            }
        }
 }
```
