//
//  ViewController.swift
//  sockets.io
//
//  Created by Muhand Jumah on 2/27/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit
import SocketIO

class HomeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    ////////////////////////////////
    //Structures
    ////////////////////////////////
    struct TableViewCellIDS {
        static let TextMessage = "TextMessageID"
        static let ImageMessage = "ImageMessageID"
        static let RoomName = "RoomNameID"
    }
    
    ////////////////////////////////
    //Models
    ////////////////////////////////
    class TextMessage {
        var senderName: String
        var isMe: Bool
        
        init(senderName: String, isMe: Bool){
            self.senderName = senderName
            self.isMe = isMe
        }
    }
    
    class StringTextMessage : TextMessage{
        var message: String
        
        init(message: String, senderName: String, isMe: Bool){
            self.message = message
            
            super.init(senderName: senderName, isMe: isMe)
        }
    }
    
    class ImageTextMessage : TextMessage{
        var image: UIImage
        
        init(image: UIImage, senderName: String, isMe: Bool){
            self.image = image
            
            super.init(senderName: senderName, isMe: isMe)
        }
    }
    
    ////////////////////////////////
    //Global variables
    ////////////////////////////////
    var manager: SocketManager!
    var socket: SocketIOClient!
    var currentUserName: String!
    var imagePicker = UIImagePickerController()
    var chosenImage = UIImage()
    var messages = [TextMessage]()
    var previousColor = UIColor.green
    
    ////////////////////////////////
    //Outlets
    ////////////////////////////////
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var disconnectBtnOutlet: UIButton!
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var sendMessageTextBox: UITextField!
    @IBOutlet weak var pickImageBtnOutlet: UIButton!
    @IBOutlet weak var messagesTableView: UITableView!
    
    ////////////////////////////////
    //Action
    ////////////////////////////////
    @IBAction func disconnectBtn(_ sender: Any) {
        socket.emit("member_leaving", currentUserName)
        socket.disconnect()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
      
        let a: [String: Any] = [
            "name": currentUserName!,
            "message": sendMessageTextBox.text!
        ]
        
        guard let newMessageTmp = sendMessageTextBox.text else { return }
        let senderNameTmp = "Muhand"
        let isMeTmp = true
        let newMessage = StringTextMessage(message: newMessageTmp, senderName: senderNameTmp, isMe: isMeTmp)
        
        //Append the new message
        messages.append(newMessage)
        
        //Refresh the table
        messagesTableView.reloadData()
        
        //Send the message
        socket.emit("new_message", a)
    }
    
    @IBAction func pickImageBtn(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    ////////////////////////////////
    //Conform to UIViewController
    ////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.sendMessageTextBox.delegate = self;
        
        socket.on(clientEvent: .disconnect) {data, ack in
            self.statusLabel.text = "Disconnected :)";
            self.statusLabel.textColor = UIColor.red;
        
            self.dismiss(animated: true)
        }
        
        socket.on("incoming_message") { [unowned self] data, ack in
            guard let s = data.first as? [String: Any] else { return }
            
            guard let name = s["name"] as? String else {return}
            guard let message = s["message"] as? String else {return}
            
            let newMessageTmp = message
            let senderNameTmp = name
            let isMeTmp = false
            let newMessage = StringTextMessage(message: newMessageTmp, senderName: senderNameTmp, isMe: isMeTmp)
            
            //Append the new message
            self.messages.append(newMessage)
            
            //Refresh the table
            self.messagesTableView.reloadData()
        }
        
        socket.on("new_member") { [unowned self] data, ack in
            guard let s = data.first as? String else { return }
            
            let newMessageTmp = "\(s) have joined the room\n"
            let senderNameTmp = ""
            let isMeTmp = false
            let newMessage = StringTextMessage(message: newMessageTmp, senderName: senderNameTmp, isMe: isMeTmp)
            
            //Append the new message
            self.messages.append(newMessage)
            
            //Refresh the table
            self.messagesTableView.reloadData()
        }
        
        socket.on("member_leaving") { [unowned self] data, ack in
            guard let s = data.first as? String else { return }
            
            let newMessageTmp = "\(s) have left the room\n"
            let senderNameTmp = ""
            let isMeTmp = false
            let newMessage = StringTextMessage(message: newMessageTmp, senderName: senderNameTmp, isMe: isMeTmp)
            
            //Append the new message
            self.messages.append(newMessage)
            
            //Refresh the table
            self.messagesTableView.reloadData()
        }
        
        socket.on("new_image") { [unowned self] data, ack in
//            print("RECIEVD DATA \(data)")
            guard let s = data.first as? String else { return }
//            print("RECIEVD DATA \(s)")
            
            let decodedData = NSData(base64Encoded: s, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let returnImage = UIImage(data: decodedData! as Data)
            
            let newMessage = ImageTextMessage(image: returnImage!, senderName: "ss", isMe: false)
            
            //Append the new message
            self.messages.append(newMessage)
            
            //Refresh the table
            self.messagesTableView.reloadData()
            
//            var indexPath = NSIndexPath(forRow: numberOfRowYouWant, inSection: 0)
//            var indexPath = NSIndexPath(row: messagesTableView.child, section: <#T##Int#>)
//            self.tableview.scrollToRowAtIndexPath(indexPath,
//                                                  atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            
            // First figure out how many sections there are
//            let lastSectionIndex = (self.messagesTableView!.numberOfSections) - 1
//
//            // Then grab the number of rows in the last section
//            let lastRowIndex = (self.messagesTableView!.numberOfRows(inSection: lastSectionIndex)) - 1
//
//            // Now just construct the index path
//            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            
            // Make the last row visible
//            self.messagesTableView.scrollToRow(at: pathToLastRow as IndexPath, at: .none, animated: true)
//            self.messagesTableView.scrollToRow(at: pathToLastRow as, at: .bottom, animated: true)
            
//            print("LAST SECTION IS \(lastSectionIndex)")
//            print("LAST ROW IS \(lastRowIndex)")
//            print("LAST PATH ROW IS \(pathToLastRow)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////
    //Image picker
    ////////////////////////////////
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let newSize = CGSize(width: 220, height: 260)
            let f = resizeImage(image: pickedImage, targetSize: newSize)
            
            let senderNameTmp = "Me"
            let isMeTmp = true
            let newMessage = ImageTextMessage(image: f, senderName: senderNameTmp, isMe: isMeTmp)
            
            //Append the new message
            messages.append(newMessage)
            
            //Refresh the table
            messagesTableView.reloadData()

            let imageData = UIImagePNGRepresentation(f)
            let base64encoding = imageData?.base64EncodedString(options: .lineLength64Characters)
            
            socket.emit("new_image", base64encoding!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    ////////////////////////////////
    //Helpers
    ////////////////////////////////
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageTextBox.resignFirstResponder()
        return true
    }
    
    func setupTableView() {
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        let textMessageNib = UINib(nibName: "TextMessageTableViewCell", bundle: nil)
        messagesTableView.register(textMessageNib, forCellReuseIdentifier: TableViewCellIDS.TextMessage)

        let imageTextNib = UINib(nibName: "TextImageTableViewCell", bundle: nil)
        messagesTableView.register(imageTextNib, forCellReuseIdentifier: TableViewCellIDS.ImageMessage)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {

            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let textCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.TextMessage, for: indexPath) as? TextMessageTableViewCell else { return UITableViewCell() }
        
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.ImageMessage, for: indexPath) as? TextImageTableViewCell else { return UITableViewCell() }
        
        var ret:UITableViewCell = UITableViewCell()
        
        if let _ = messages[indexPath.row] as? ImageTextMessage {
            let message:ImageTextMessage = messages[indexPath.row] as! ImageTextMessage
            imageCell.ImageText.contentMode = .scaleAspectFit
            imageCell.ImageText.image = message.image
            if (message.isMe == true) {
                imageCell.backgroundColor = UIColor.blue
            } else {
                imageCell.backgroundColor = UIColor.lightGray
            }
            
            ret = imageCell
        } else if let _ = messages[indexPath.row] as? StringTextMessage {
            let message:StringTextMessage = self.messages[indexPath.row] as! StringTextMessage
            
            if (message.isMe == true) {
                //Is me sending a message
                //Print the messsage with a prefix "ME"
                textCell.TextMessage.text = "Me: \(message.message)"
                textCell.TextMessage.textAlignment = NSTextAlignment.right
                textCell.backgroundColor = UIColor.blue
                textCell.TextMessage.textColor = UIColor.white
                
            } else {
                if (message.senderName == "") {
                    //The senderName is empty that means this is a notification so don't append anything
                    textCell.TextMessage.text = "\(message.message)"
                    textCell.TextMessage.textAlignment = NSTextAlignment.center
                    textCell.backgroundColor = UIColor(white: 1, alpha: 0.0)
                } else {
                    //Someone else is sending a message so append their name
                    textCell.TextMessage.text = "\(message.senderName): \(message.message)"
                    textCell.TextMessage.textAlignment = NSTextAlignment.left
                    textCell.backgroundColor = UIColor.lightGray
                }
            }
            
            ret = textCell
        }
        
        return ret
    }
}


