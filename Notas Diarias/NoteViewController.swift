//
//  NoteViewController.swift
//  Notas Diarias
//
//  Created by Christian Rezende on 27/07/22.
//  Copyright © 2022 Christian Rezende. All rights reserved.
//

import UIKit
import CoreData
class NoteViewController: UIViewController {

 
    @IBOutlet weak var addTextView: UITextView!
    
    var context : NSManagedObjectContext!
    
    var note : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // focus initial
        self.addTextView.becomeFirstResponder()
        if note != nil {
            if let recoveredText = note.value(forKey: "text"){
                self.addTextView.text = String(describing:recoveredText)
            }
            
        }else {
            self.addTextView.text = ""
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

    }
    
    @IBAction func saveMenuButton(_ sender: Any) {
        if self.note != nil {
            updateDate()
        }else {
            self.saveNote()
          
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveNote( ){
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        newNote.setValue(self.addTextView.text, forKey: "text")
        newNote.setValue(Date(), forKey: "date")
        
        
        do {
            try context.save()
        } catch let error  {
            print("Error on save note: \(error.localizedDescription)")
        }
        
    }
    
    func updateDate(){
        note.setValue(self.addTextView.text, forKey: "text")
        note.setValue(Date(), forKey: "date")

        do {
            try context.save()
        } catch let error  {
            print("Error on save note: \(error.localizedDescription)")
        }

    }
    
    
}
