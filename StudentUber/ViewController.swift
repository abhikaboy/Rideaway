//
//  ViewController.swift
//  StudentUber
//
//  Created by Chiraag Nadig on 6/12/22.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    var names = [String]()
    var numbers = [String]()
    
    var weatherManager = WeatherManager()
    var apiThing = APIRequest()
    
    @IBOutlet var vCode: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var userNum: UITextField!
    
    @IBAction func unlockApp(_ sender: Any) {
        fetchContacts()
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        apiThing.makePOSTRequest(num: "users/login?number=" + userNum.text! + "&code=" + vCode.text!)
    }
    @IBAction func sendButton(_ sender: Any) {
        //weatherManager.fetchWeather(cityName: "users/create?number=" + userNum.text!)
        apiThing.makePOSTRequest(num: "users/create?number=" + userNum.text!)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "billy" {
            let otherView = segue.destination as! HomeViewController
            otherView.names = names
            otherView.numbers = numbers
        }
    }
    
    private func fetchContacts() {
        print("Attempting to fetch contacts today...")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access: ", err)
                return
            }
            if granted {
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        let fullName = contact.givenName + " " + contact.familyName
                        self.names.append(fullName)
                        let number = contact.phoneNumbers.first?.value.stringValue ?? ""
                        //let numArray = number.components(separatedBy: "")
                        
                        self.numbers.append(number)
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "billy", sender: nil)
                        }
                        
                    })
                } catch let err {
                    self.errorLabel.text = "Failed to enumerate contacts"
                }
                
                
            
            }
            else {
                self.errorLabel.text = "Access denied"
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }


}

