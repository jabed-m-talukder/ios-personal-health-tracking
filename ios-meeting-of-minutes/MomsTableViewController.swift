//
//  MomsTableViewController.swift
//  ios-meeting-of-minutes
//
//  Created by Talukder on 11/28/16.
//  Copyright © 2016 Talukder. All rights reserved.
//

import UIKit

class MomsTableViewController: UITableViewController {
    let commutil: CommonUtility = CommonUtility()
    var momsubs = [String]()
    var subjectList: [String] = []
    let getAllApiEndPoint = "getall"

    override func viewDidLoad() {
        super.viewDidLoad()
        commutil.getAllMoms(apiEndPoint: getAllApiEndPoint){ response in
            self.subjectList = response
            let res: String = self.subjectList.first!
            
            if res == "Not a 200 response" {
                let alert = UIAlertController(title: "Server Error", message: "Please check the server status", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in self.backToPreviousView()}))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.tableView.reloadData()

                
            }

        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let momsubject: String = commutil.getAllMoms()
        
        let count = subjectList.count
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomSubject", for: indexPath)
        cell.textLabel?.text = subjectList[indexPath.row]
        return cell
    }

    func backToMainView(){
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    func backToPreviousView(){
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
