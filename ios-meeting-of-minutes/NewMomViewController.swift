//
//  NewMomViewController.swift
//  ios-meeting-of-minutes
//
//  Created by Talukder on 11/30/16.
//  Copyright © 2016 Talukder. All rights reserved.
//

import UIKit

class NewMomViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtFldEmails: UITextField!
    @IBOutlet weak var txtFldMomSubject: UITextField!
    @IBOutlet weak var txtViewMoms: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClearAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Moms textview border setup
        txtViewMoms.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        txtViewMoms.layer.borderWidth = 1.0
        txtViewMoms.layer.cornerRadius = 5
        
        //Btn border setup
        btnStyle(btn: btnSubmit)
        btnStyle(btn: btnClearAll)
        self.txtViewMoms.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);

    }
    
    func btnStyle(btn: UIButton){
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blue.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSubmit(_ sender: AnyObject) {
        preparePostJsonData(email: txtFldEmails.text!,
                            subject: txtFldMomSubject.text!,
                            mom: txtViewMoms.text!)
    }
    
    @IBAction func btnClearAll(_ sender: AnyObject) {
        clearAllField()
    }
    
    func preparePostJsonData(email: String, subject: String, mom: String){
        let newMomEndpoint: String = serverBase + "addNewMom"
        guard let newMomUrl = URL(string: newMomEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var newMomUrlRequest = URLRequest(url: newMomUrl)
        newMomUrlRequest.httpMethod = "POST"
        newMomUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newMom: [String: Any] = ["emails": email, "momsubject": subject, "mom": mom]
        
        let newJsonMom: Data
        do {
            newJsonMom = try JSONSerialization.data(withJSONObject: newMom, options: [])
            newMomUrlRequest.httpBody = newJsonMom
        } catch {
            print("Error: cannot create JSON from newMom")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: newMomUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /api/addNewMom")
                print(error)
                return
            }
            print("response", response)
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: {action in self.backToPreviousView()}))
            self.present(alert, animated: true, completion: nil)
        }
        task.resume()
    }
    
    func backToPreviousView(){
        clearAllField()
        self.navigationController?.popViewController(animated: true)
    }
    
    func clearAllField(){
        txtFldMomSubject.text = ""
        txtFldEmails.text = ""
        txtViewMoms.text = ""
    }
}
