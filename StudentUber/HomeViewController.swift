//
//  HomeController.swift
//  StudentRides
//
//  Created by Chiraag Nadig on 6/11/22.
//

import UIKit
//import Contacts

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //let names = ["Araash", "Abhik", "Chiraag"]
    var weatherManager = WeatherManager()
    
    
    var names = [String]()
    var numbers = [String]()
    
    //var contactStore = CNContactStore()
    //var contacts = [ContactStruct]()
    
    let cellSpacingHeight: CGFloat = 1
    
    @IBOutlet var ridesTable: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "htor" || segue.identifier == "htorb" {
            let otherView = segue.destination as! RequestViewController
            otherView.names = names
            otherView.numbers = numbers
        }
        else if segue.identifier == "htos" {
            let otherView = segue.destination as! SettingsViewController
            otherView.names = names
            otherView.numbers = numbers
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(nameList[0])
        weatherManager.fetchWeather(cityName: "requests/incomming?id=62a6a0612e2605481ec754e5")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1
        let headerView = UIView()
        // 2
        //headerView.backgroundColor = view.backgroundColor
        // 3
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ridesTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RequestsCell
        cell.nameLabel.text = names[indexPath.section]
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ridesTable.delegate = self
        ridesTable.dataSource = self
        
        ridesTable.rowHeight = 105
        
        /*
        contactStore.requestAccess(for: .contacts) { success, error in
            if success {
                print("Authorization Successful")
            }
        }
        */
        
        
        //UIApplication.shared.status
        //statusBarView?.backgroundColor = UIColor.red
        
        /*
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        */
        // Do any additional setup after loading the view.
    }
    

}

