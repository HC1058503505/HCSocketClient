//
//  ViewController.swift
//  HCSocketClient
//
//  Created by UltraPower on 2017/7/4.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var connectStatus: NSTextField!
    
    @IBOutlet var server: NSTextView!
    @IBOutlet weak var message: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

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

}

