//
//  ViewController.swift
//  Bitcoinator
//
//  Created by Aditya Vikram Godawat on 01/07/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import UIKit
import SocketIO


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketCalls()
        
    }
    
    func socketCalls() {
        let manager = SocketManager(socketURL: url!, config: [.log(true), .forcePolling(true)])
        let socket = manager.defaultSocket
        socket.connect()

        
        socket.once(clientEvent: .connect, callback: { (_, _) in
            print("connected")
            let object: Any = [:]
            socket.emitWithAck("{\"op\":\"unconfirmed_sub\"}", with: [object]).timingOut(after: 0, callback: { (any) in
                print("Printing: \(any)")
            })
        })
        
        socket.onAny { (event) in
            print(event)
        }
        
//        socket.on("{\"op\":\"unconfirmed_sub\"}") { (data, ack) in
//            print(data)
//            ack.with("Got your currentAmount", "dude")
//
//        }
    }
}


