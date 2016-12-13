//
//  CMDataViewController.swift
//  ios-meeting-of-minutes
//
//  Created by BJIT-2015 on 12/2/16.
//  Copyright © 2016 BJIT-2015. All rights reserved.
//

import UIKit
import CoreMotion

class CMDataViewController: UIViewController {
    
    var days: [String] = []
    var stepsTaken: [String] = []
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtSteps: UITextField!
    @IBOutlet weak var txtStepsToday: UITextField!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var txtStepsTodayInKm: UITextField!
    @IBOutlet weak var txtStepsRangeInKm: UITextField!
    @IBOutlet weak var txtAvgTime: UITextField!
    @IBOutlet weak var txtAvgPaceRange: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtState.isEnabled = false
        txtSteps.isEnabled = false
        txtStepsToday.isEnabled = false
        txtStepsTodayInKm.isEnabled = false
        txtStepsRangeInKm.isEnabled = false
        
        getMData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getMData(){

        
        var cal = NSCalendar.current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = TimeZone.current
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: comps)
        
        //print(midnightOfToday as Any)
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { data in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(data?.stationary == true){
                        self.imgState.image = UIImage(named: "Counselor_100")
                        self.imgState.contentMode = .center
                        self.txtState.text = "Stationary"
                        print("stationary or unknown")
                    } else if (data?.walking == true){
                        self.txtState.text = "Walking"
                        self.imgState.image = UIImage(named: "Walking_100")
                        self.imgState.contentMode = .center
                        print("Walking")
                    } else if (data?.running == true){
                        self.txtState.text = "Running"
                        self.imgState.image = UIImage(named: "Running_100")
                         print("Running")
                    } else if (data?.automotive == true){
                        self.txtState.text = "Automotive"
                        self.imgState.image = UIImage(named: "Driver_100")
                        print("Automotive")
                    } else if (data?.cycling == true){
                        self.txtState.text = "Cycling"
                        self.imgState.image = UIImage(named: "Cycling Road_100")
                    }
                })
                
            })

        }
        
        if(CMPedometer.isStepCountingAvailable()){
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerData(from: fromDate as Date, to: Date(), withHandler: { data, error in
                //print(data as Any)
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        // Steps
                        if let stepsRange = data?.numberOfSteps {
                            self.txtSteps.text = String(describing: stepsRange)
                        } else {
                            self.txtSteps.text = "No data"
                        }
                        // In km
                        if let stepRangeKmData = data?.distance {
                            let kmData = stepRangeKmData.floatValue / 1000
                            if #available(iOS 10.0, *) {
                                let timeData = data?.averageActivePace?.intValue
                                self.txtAvgPaceRange.text = String(describing: timeData)
                            } else {
                                // Fallback on earlier versions
                                self.txtAvgPaceRange.isHidden = true
                            }
                            self.txtStepsRangeInKm.text = String(describing: kmData)
                        } else {
                            self.txtStepsRangeInKm.text = "No data"
                        }
                    }
                })
            })
            
            self.pedoMeter.startUpdates(from: midnightOfToday!, withHandler: { data, error in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        if let stepsToday = data?.numberOfSteps {
                            self.txtStepsToday.text = "\(stepsToday)"
                        } else {
                            self.txtStepsToday.text = "No data for today"
                        }
                        // In km
                        if let stepKmData = data?.distance {
                            let kmData = stepKmData.floatValue / 1000
                            if #available(iOS 10.0, *) {
                                let timeData = data?.averageActivePace?.intValue
                                self.txtAvgTime.text = String(describing: timeData)
                            } else {
                                // Fallback on earlier versions
                                self.txtAvgTime.isHidden = true
                            }
                            
                            self.txtStepsTodayInKm.text = String(describing: kmData)
                        } else {
                            self.txtStepsTodayInKm.text = "No data"
                        }
                    }
                })
            })

        }
    }

}
