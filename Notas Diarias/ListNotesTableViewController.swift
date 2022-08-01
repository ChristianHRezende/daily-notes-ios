//
//  ViewController.swift
//  Notas Diarias
//
//  Created by Christian Rezende on 27/07/22.
//  Copyright © 2022 Christian Rezende. All rights reserved.
//

import UIKit
import CoreData


class ListNotesTableViewController: UITableViewController {
    
    var notes: [NSManagedObject]! = []
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.getNotesService()
    }
    
    func getNotesService(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(request)
            notes = result as? [NSManagedObject]
            self.tableView.reloadData()
        } catch let error  {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableVuew:UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath:IndexPath){
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let index = indexPath
            let note = self.notes[index.row]
            self.context.delete(note)
            self.notes.remove(at: index.row)
            
            self.tableView.deleteRows(at: [index], with: .automatic)
            
            do {
                try self.context.save()
            } catch let error {
                print("Error on try delete: \(error.localizedDescription)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notes.count)
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        let note = self.notes[index]
        self.performSegue(withIdentifier: "showNoteViewController", sender: note)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteViewController" {
            let viewDestination = segue.destination as! NoteViewController
            viewDestination.note = sender as? NSManagedObject
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteItemTableView",for: indexPath)
        if let title = notes[indexPath.row].value(forKey: "text") {
            cell.textLabel?.text = title as? String
            print(title)
            if let date = notes[indexPath.row].value(forKey: "date") {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
                let newDate = dateFormatter.string(from: date as! Date)
                cell.detailTextLabel?.text = newDate
                print(date)

            }
        }
        
        return cell
    }
    
    

}

