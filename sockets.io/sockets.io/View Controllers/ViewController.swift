//
//  ViewController.swift
//  sockets.io
//
//  Created by Muhand Jumah on 2/27/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITextFieldDelegate {
    
    ////////////////////////////////
    //Outlets
    ////////////////////////////////
    @IBOutlet weak var connectBtnOutlet: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ipAddressTextField: UITextField!
    
    
    ////////////////////////////////
    //Action
    ////////////////////////////////
    @IBAction func connectBtn(_ sender: Any) {
//        guard let h = storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController else {return}
        guard let rooms = storyboard?.instantiateViewController(withIdentifier: "PrivateRooms") as? RoomsViewController else {return}
        
        manager = SocketManager(socketURL: URL(string: "http://\(ipAddressTextField.text ?? "192.168.7.24"):3000")!, config: [.log(false), .compress])
        
        socket = manager.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) {data, ack in
            currentUserName = self.userNameTextField.text!
//            guard let un = self.userNameTextField.text else {return}
//            socket.emit("new_member", "\(un)")

            self.present(rooms, animated: true, completion: nil)
        }
    }
    
    
    ////////////////////////////////
    //Conform to UIViewController
    ////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userNameTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    ////////////////////////////////
    //Helpers
    ////////////////////////////////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }
}

