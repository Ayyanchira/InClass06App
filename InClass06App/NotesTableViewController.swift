//
//  NotesTableViewController.swift
//  InClass06App
//
//  Created by Ayyanchira, Akshay Murari on 10/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase
class NotesTableViewController: UITableViewController {

    var key:String?
    let rootref = Database.database().reference()
    var notes:[Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        fetchNotesfor(key: key!)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCustomCell", for: indexPath) as! NoteCustomTableViewCell
        let note = notes[indexPath.row]
        cell.noteTextView.text = note.post
        cell.dateTimeLabel.text = "Created on \(note.date)"
        // Configure the cell...
        
        return cell
    }

    func fetchNotesfor(key:String) {
        let dataref = self.rootref.child("Notes").child(self.key!)
        dataref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.notes.removeAll()
                for value in values {
                    let key = value.key as! String
                    let object = value.value as? [String:Any]
                    let post = object!["post"] as! String
                    let date = object!["date"] as! String
                    let note = Note(post: post, date: date, key: key)
                    self.notes.append(note)
                }
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addNoteAlertController = UIAlertController(title: "New Note", message: "Enter New Post Text", preferredStyle: UIAlertControllerStyle.alert)
        addNoteAlertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Note text"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction:UIAlertAction) in
            //call firebase save function
            let textfield = addNoteAlertController.textFields![0] as UITextField
            if let notesText = textfield.text{
                if notesText != ""{
                    let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
                    let notebookReference = self.rootref.child("Notes").child(self.key!).childByAutoId();
                    let noteObject = [
                        "post" : notesText,
                        "date" : date
                    ]
                    notebookReference.setValue(noteObject)
                    self.fetchNotesfor(key: self.key!)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addNoteAlertController.addAction(okAction)
        addNoteAlertController.addAction(cancelAction)
        self.navigationController?.present(addNoteAlertController, animated: true, completion: nil)
    }
    
}





class Note: NSObject {
    var post:String
    var date:String
    var key:String
    
    init(post:String, date:String, key:String) {
        self.post = post
        self.date = date
        self.key = key
    }
}

