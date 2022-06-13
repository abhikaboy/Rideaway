//
//  APIRequest.swift
//  StudentUber
//
//  Created by Chiraag Nadig on 6/12/22.
//

import Foundation
import UIKit
import CoreData

struct APIRequest {
    func makePOSTRequest(num: String) {
        print("http://18.189.194.54:5000/\(num)")
        guard let url = URL(string: "http://18.189.194.54:5000/\(num)") else {
            return
        }
        
        print("Making api call...")
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /*
        let body: [String: AnyHashable] = [
            "userId": 1,
            "title": "Hello From iOS Academy",
            "body": "Hello",
        ]
        */
        //request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                let rBetter = response as! String
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
                request.returnsObjectsAsFaults = false
                let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
                newEntry.setValue(rBetter, forKey: "userID")
                do {
                    try context.save()
                    //pop up that routine name has been saved
                    //perform segue - send the name of the routine over
                }
                catch {
                    //pop up that an error occured
                    print("An error occured. Please try again")
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
    }
}


