//
//  CommonUtility.swift
//  ios-meeting-of-minutes
//
//  Created by BJIT-2015 on 11/28/16.
//  Copyright © 2016 BJIT-2015. All rights reserved.
//

import Foundation

class MomsData{
    private var subjectlist: [String]
    
    init() {
        self.subjectlist = []
    }
    
    func addToList(subject: String){
        self.subjectlist.append(subject)
    }
    
    func getSubjectList() -> [String] {
        return self.subjectlist
    }
}


/*

 FF
 
 */

class CommonUtility{
    
    var apibase: String
    var subjectlist: [String]
    
    init() {
        self.apibase = serverBase
        self.subjectlist = []
    }
    
    // Get list of Moms from server
    // Return list of data
    func getAllMoms(apiEndPoint: String, getSubjectCompletionHandler: @escaping ([String]) -> ()) {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        // Made http through setting in plist
        // End point e.g "/getall"
        let postEndpoint: String = self.apibase + apiEndPoint
        let session = URLSession.shared
        let url = URL(string: postEndpoint)!
        
        
        // Make the POST call and handle it in a completion handler
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            // Make sure we get an OK response
            print(data)
            print(response)
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let momString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                    // Print what we got from the call
                    print(momString)
                    
                    // Parse the JSON to get the IP
                    let jsonArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    let count: Int = jsonArray.count
                    var index: Int = 0
                    
                    while  index < count{
                        let jsonDict = jsonArray[index] as! NSDictionary
                        
                        let id = jsonDict["id"] as! Int
                        let email = jsonDict["emails"] as! String
                        let subject = jsonDict["momsubject"] as! String
                        let mom = jsonDict["mom"] as! String
                        //self.setSubject(sub: subject)
                        self.subjectlist.append(subject)
                        
                        print("\r\nId=",id,"\r\nEmails= ", email,"\r\nSubject= ",subject, "\r\nMom= ", mom)
                        index += 1
                    }
                    getSubjectCompletionHandler(self.subjectlist)
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
                
            } catch {
                print("bad things happened")
            }
        })
        task.resume()
    }
    
}
