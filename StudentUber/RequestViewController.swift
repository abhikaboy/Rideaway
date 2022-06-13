//
//  RequestViewController.swift
//  StudentRides
//
//  Created by Chiraag Nadig on 6/11/22.
//

import UIKit

class RequestViewController: UIViewController {
    
    var names = [String]()
    var numbers = [String]()
    var apiThing = APIRequest()

    @IBOutlet var bar1: UITabBarItem!
    @IBOutlet var submitButton: UIButton!
    
    
    @IBOutlet var addy: UITextField!
    
    
    @IBOutlet var comment: UITextField!
    
    @IBOutlet var navBar: UINavigationBar!
    
    
    @IBAction func submitRequest(_ sender: Any) {
        var linky = "requests/create?id=62a69f352e2605481ec754e0&comment=\(comment.text!)&destination=\(addy.text!)"
        for number in numbers {
            linky = linky + "&requesting[]=\(number)"
        }
        apiThing.makePOSTRequest(num: linky)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rtos" {
            let otherView = segue.destination as! SettingsViewController
            otherView.names = names
            otherView.numbers = numbers
        }
        else if segue.identifier == "rtoh" {
            let otherView = segue.destination as! HomeViewController
            otherView.names = names
            otherView.numbers = numbers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 12
        submitButton.clipsToBounds = true
        
        submitButton.layer.borderColor = UIColor.blue.cgColor
        // Do any additional setup after loading the view.
        /*
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        */
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        let height: CGFloat = 100 //whatever height you want to add to the existing height
        let bounds = navBar.bounds
        navBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        */
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
