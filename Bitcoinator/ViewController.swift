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
import Whisper
import Alamofire

class ViewController: UIViewController {
    
    var socket = WebSocket(url: url!, protocols: ["blockchain"])

    @IBOutlet weak var tansactionalHashLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var blockHashLabel: UILabel!
    @IBOutlet weak var blockHeightLabel: UILabel!
    @IBOutlet weak var btcSentLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starscream()
        
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    func starscream() {
        showWhisper(message: Message(title: "Connecting", textColor: .white, backgroundColor: .orange, images: nil))
        socket.delegate = self
        socket.connect()
        
        socket.onDisconnect = { (error: Error?) in
            self.showWhisper(message: Message(title: "Disconnected", textColor: .white, backgroundColor: .red, images: nil))
            self.socket.connect()
        }
    }
}

extension ViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        showWhisper(message: Message(title: "Connected!", textColor: .white, backgroundColor: .green, images: nil))
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
        
        let json = JSON(dictionary["x"])
        
        if let op = dictionary["op"] as? String {
            if op == "utx" {
                let utx = UTX(fromJSON: json)
                handlingUTX(utx)
            } else if op == "block" {
                let block = Block(fromJSON: json)
                handlingBlock(block)
            }
        } else {
            return
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    }
   
    func handlingUTX(_ utx: UTX) {

        if utx.largestValue >= 0.002 {
            tansactionalHashLabel.text = utx.transactionHash
             getConvertedPrice(utx.largestValue)
        }
        
    }
    
    func getConvertedPrice(_ btc: Double) {
        Alamofire.request("https://blockchain.info/ticker", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                
                let result = response.result.value as! NSDictionary
                let dictionary = JSON(result)
                let conversion = dictionary["USD"]["last"].doubleValue
                
                let converted = btc * conversion
                
                self.valueLabel.text = String(format: "%.2f", converted) + " $"
        }
        
    }
    
    func handlingBlock(_ block: Block) {
        blockHashLabel.text = block.blockHash
        blockHeightLabel.text = "\(block.blockHeight)"
        btcSentLabel.text = "\(block.btcSent/pow(10, 8)) ₿"
        rewardLabel.text = "\(block.reward/pow(10, 8)) ₿"
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

    
    func showWhisper(message: Message) {
        Whisper.hide(whisperFrom: self.navigationController!)
        Whisper.show(whisper: message, to: self.navigationController!)
    }
}
