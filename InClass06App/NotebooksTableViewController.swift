//
//  NotebooksTableViewController.swift
//  InClass06App
//
//  Created by Ayyanchira, Akshay Murari on 10/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase

class NotebooksTableViewController: UITableViewController {

    let rootref = Database.database().reference()
    var notebooks:[NoteBook] = []
    let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        fetchNotebookfor(uuid: uuid)
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
        return notebooks.count
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "uuid")
        do {
            try Auth.auth().signOut()
        } catch let signoutError as NSError {
            print(signoutError.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addNotebookAlertController = UIAlertController(title: "New Notebook", message: "Enter Notebook Name", preferredStyle: UIAlertControllerStyle.alert)
        addNotebookAlertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Notebook name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction:UIAlertAction) in
            //call firebase save function
            let textfield = addNotebookAlertController.textFields![0] as UITextField
            if let notebookname = textfield.text{
                if notebookname != ""{
                    let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
                    let notebookReference = self.rootref.child("Notebooks").child(self.uuid).childByAutoId()
                    let notebookObject = [
                        "name" : notebookname,
                        "date" : date
                    ]
                    notebookReference.setValue(notebookObject)
                    self.fetchNotebookfor(uuid: self.uuid)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addNotebookAlertController.addAction(okAction)
        addNotebookAlertController.addAction(cancelAction)
        self.navigationController?.present(addNotebookAlertController, animated: true, completion: nil)
    }
    
    
    func fetchNotebookfor(uuid:String) {
        let dataref = self.rootref.child("Notebooks").child(self.uuid)
        dataref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.notebooks.removeAll()
                for value in values {
                    let key = value.key as! String
                    let object = value.value as? [String:Any]
                    let name = object!["name"] as! String
                    let date = object!["date"] as! String
                    let notebook = NoteBook(name: name, date: date, key: key)
                    self.notebooks.append(notebook)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let notebook = notebooks[indexPath.row]
        cell.textLabel?.text = notebook.name
        cell.detailTextLabel?.text = "Created on \(notebook.date)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notebook = notebooks[indexPath.row]
        let notebookKey = notebook.key
        performSegue(withIdentifier: "viewNotes", sender: notebookKey)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let key = sender as? String{
            let notesViewController = segue.destination as? NotesTableViewController
            notesViewController?.key = key
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class NoteBook: NSObject {
    var name:String
    var date:String
    var key:String
    
    init(name:String, date:String, key:String) {
        self.name = name
        self.date = date
        self.key = key
    }
}
