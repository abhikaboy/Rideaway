//
//  SettingsViewController.swift
//  StudentRides
//
//  Created by Chiraag Nadig on 6/11/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var names = [String]()
    var numbers = [String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stoh" {
            let otherView = segue.destination as! HomeViewController
            otherView.names = names
            otherView.numbers = numbers
        }
        else if segue.identifier == "stor" {
            let otherView = segue.destination as! RequestViewController
            otherView.names = names
            otherView.numbers = numbers
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        */
        // Do any additional setup after loading the view.
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
