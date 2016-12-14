//
//  EntryDetailViewController.swift
//  TouchIDPlay
//
//  Created by Taylor Mott on 9/28/16.
//  Copyright © 2016 Mott Applications. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped() {
        
        entry?.title = titleTextField.text
        entry?.text = bodyTextView.text
        entry?.timestamp = NSDate()
        
        EntryController.saveToPersistentStore()
        
        _ = navigationController?.popViewController(animated: true)
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
