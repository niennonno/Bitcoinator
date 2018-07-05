//
//  ViewController.swift
//  Bitcoinator
//
//  Created by Aditya Vikram Godawat on 01/07/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

class ViewController: UIViewController {
    
    var socket = WebSocket(url: url!, protocols: ["blockchain"])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starscream()
        
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    func starscream() {
        socket.delegate = self
        socket.connect()
    }
}

extension ViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connect")
        socket.write(string: "{\"op\":\"unconfirmed_sub\"}")
        socket.write(string: "{\"op\":\"blocks_sub\"}")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Disconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        guard let dictionary = convertToDictionary(text: text) else {
            return
        }
        
         let json = JSON(dictionary)
        
        
        if let op = dictionary["op"] as? String {
            if op == "utx" {
                let utx = UTX(fromJSON: json)
            } else {
                print("Block")
            }
        } else {
            return
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
