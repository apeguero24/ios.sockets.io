//
//  RoomsViewController.swift
//  sockets.io
//
//  Created by Muhand Jumah on 3/1/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController, UITextFieldDelegate {
    ////////////////////////////////
    //Global variables
    ////////////////////////////////
    var rooms = [Room]()
    var selectedRoomCell: RoomTableViewCell?
    
    ////////////////////////////////
    //Outlets
    ////////////////////////////////
    @IBOutlet weak var newRoomTextfield: UITextField!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var joinPublicBtn: UIButton!
    @IBOutlet weak var newRoomBtn: UIButton!
    @IBOutlet weak var roomsTableView: UITableView!
    
    
    ////////////////////////////////
    //Action
    ////////////////////////////////
    @IBAction func joinRoomAction(_ sender: Any) {
        socket.emit("join_room", (selectedRoomCell?.RoomName.text)!)
        
        //Move to the next view
        guard let home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController else {return}
        
        socket.emit("new_member", "\(currentUserName!)")
        
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func joinPublicRoomAction(_ sender: Any) {
        
    }
    
    @IBAction func newSceneAction(_ sender: Any) {
        let newRoom: [String: Any] = [
            "roomName": newRoomTextfield.text!,
            "currentUser": currentUserName
        ]
        
        socket.emit("new_room", newRoom)
        
        socket.on("joined_room") {data, ack in
            guard let joinedRoomName = data.first as? String else { return }
            
            //Move to the next view
            guard let home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController else {return}
            
            socket.emit("new_member", "\(currentUserName!)")
            
            self.present(home, animated: true, completion: nil)
        }
        
   
    }
    
    
    ////////////////////////////////
    //Conform to UIViewController
    ////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.newRoomTextfield.delegate = self
        
        socket.emit("download_rooms", "")
        
        socket.on("available_rooms") { [unowned self] data, ack in
            guard let s = data.first as? [String: Any] else { return }
            
            s.forEach({
                let id = $0
                guard let inner = $1 as? [String: Any] else {return}
                guard let name = inner["name"] as? String else {return}
                guard let members = inner["members"] as? [String] else {return}
                
                let newRoom = Room(roomID: id, roomName: name, roomMembers: members)
                
                //Append the new room if it doesn't already exist
                if !(self.rooms.contains(where: { $0.roomName == newRoom.roomName })) {
                    // found
                    self.rooms.append(newRoom)
                }
            })
            
            //Refresh the table
            self.roomsTableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(socket.status == .disconnected){
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    ////////////////////////////////
    //Helpers
    ////////////////////////////////
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newRoomTextfield.resignFirstResponder()
        return true
    }
    func setupTableView() {
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        
        let roomNib = UINib(nibName: "RoomTableViewCell", bundle: nil)
        roomsTableView.register(roomNib, forCellReuseIdentifier: TableViewCellIDS.RoomName)
    }
}

extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let roomCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIDS.RoomName, for: indexPath) as? RoomTableViewCell else { return UITableViewCell() }
        
        let room = rooms[indexPath.row]
        
        roomCell.roomID = room.roomID
        roomCell.RoomName.text = room.roomName
        roomCell.members = room.roomMembers
        
        return roomCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRow(at: indexPath!) as? RoomTableViewCell
        
        selectedRoomCell = currentCell
        
        
//        tableView.deselectRow(at: indexPath!, animated: false)
    }
}



