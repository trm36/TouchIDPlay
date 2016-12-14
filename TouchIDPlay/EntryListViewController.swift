//
//  ViewController.swift
//  TouchIDPlay
//
//  Created by Taylor Mott on 9/28/16.
//  Copyright © 2016 Mott Applications. All rights reserved.
//

import UIKit
import LocalAuthentication

class EntryListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var lockedStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - Authenticate User
    
    func authenticateUser() {
        /* PREP */
        //Get the local authentication context.
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentication is needed to access your entries."
        
        
        /* CHECK DEVICE HAS TOUCH ID */
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //has Touch ID
            self.showTouchID(context: context, reason: reasonString)
        } else {
            //No Touch ID
            self.handleNoTouchID(error: error as? LAError)
        }
    }
    
    func showPasswordAlert() {
        let alert = UIAlertController(title: "TouchIDDemo", message: "Please type your password", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            if let textField = alert.textFields?.first {
                if textField.text == "password" {
                    DispatchQueue.main.async(execute: {
                        self.unlock()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.showPasswordAlert()
                    })
                }
            }
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func showTouchID(context: LAContext, reason: String) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (sucess: Bool, evalPolicyError: Error?) in
            if sucess {
                DispatchQueue.main.async(execute: {
                    self.unlock()
                })
            } else if let evalPolicyError = evalPolicyError as? LAError {
                self.handleTouchID(error: evalPolicyError)
            } else {
                DispatchQueue.main.async(execute: { 
                    self.showPasswordAlert()
                })
            }
        })
    }
    
    
    // MARK: - Error Handling - TOUCH ID
    
    ///User did not authenticate successfully
    func handleTouchID(error evalPolicyError: LAError) {
        
        print("/******************")
        print(" * TOUCH ID ERROR *")
        print(" ******************/")
        
        print(evalPolicyError.localizedDescription)
        
        switch evalPolicyError {
        case LAError.systemCancel:
            print("Authentication was cancelled by the system")
        case LAError.userCancel:
            print("Authentication was cancelled by the user")
            DispatchQueue.main.async(execute: {
                self.showPasswordAlert()
            })
        case LAError.userFallback:
            print("User selected to enter custom password")
            DispatchQueue.main.async(execute: {
                self.showPasswordAlert()
            })
        default:
            print("Authentication failed")
            DispatchQueue.main.async(execute: {
                self.showPasswordAlert()
            })
        }
    }
    
    ///Could not evaluate policy
    func handleNoTouchID(error: LAError?) {
        
        print("/***************")
        print(" * NO TOUCH ID *")
        print(" ***************/")
        
        if let error = error {
        
            switch error {
            case LAError.touchIDNotAvailable:
                print("Touch ID not available")
            case LAError.touchIDNotEnrolled:
                print("Touch ID is not enrolled")
            case LAError.passcodeNotSet:
                print("A passcode has not been set")
            default:
                print("DEFAULT - \(error)")
            }
        
        }
        
        self.showPasswordAlert()
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.sharedController.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let entry = EntryController.sharedController.entries[indexPath.row]
        let timeIntervalSince1970 = entry.timestamp!.timeIntervalSince1970
        
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short
        df.doesRelativeDateFormatting = true
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = df.string(from: Date(timeIntervalSince1970: timeIntervalSince1970))
        
        return cell
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetail" {
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let entry = EntryController.sharedController.entries[indexPath.row]
            
                let detailViewController = segue.destination as? EntryDetailViewController
                detailViewController?.entry = entry
            }
            
        } else if segue.identifier == "toAddEntry" {
            
            let entry = EntryController.sharedController.createEntry()
            entry.timestamp = NSDate()
            
            let detailViewController = segue.destination as? EntryDetailViewController
            detailViewController?.entry = entry
            
        }
    }
    
    // MARK: - Refresh Bar Button Method
    
    @IBAction func unlockButtonTapped() {
        authenticateUser()
    }
    
    @IBAction func lockButtonTapped() {
        lock()
    }
    
    // MARK: - View Controller Mode
    
    ///User authenticated successfully
    func unlock() {
        EntryController.sharedController.loadEntries()
        setViewMode(viewMode: .unlocked)
    }
    
    func lock() {
        EntryController.sharedController.clearEntries()
        setViewMode(viewMode: .locked)
    }
    
    func setViewMode(viewMode: EntryListViewController.ViewMode) {
        switch viewMode {
        case .locked:
            tableView.isHidden = true
            tableView.reloadData()
        case .unlocked:
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

extension EntryListViewController {
    enum ViewMode {
        case locked
        case unlocked
    }
}

