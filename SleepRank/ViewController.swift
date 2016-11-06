//
//  ViewController.swift
//  SleepRank
//
//  Created by Walter Wei on 11/5/16.
//  Copyright © 2016 SleepRank. All rights reserved.
//

import UIKit
import HealthKit
import FBSDKLoginKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let healthStore = HKHealthStore()
    var window = UIWindow()
    var imageView:UIImageView!
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var headerView: UIView!
    var sleepers:[Sleeper]!
    var sleepTime:Double!

    @IBOutlet weak var tableView: UITableView!
    @IBAction func logout(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        performSegue(withIdentifier: "logout", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initiate HealthKit
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
        
        // Get sleepers data
        sleepers = []
        retrieveSleepAnalysis()
        
        // Initiate imageView:
        imageView = UIImageView()
        imageView.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // Initiate tableView:
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        headerView = UIView(frame: frame)
        tableView.sectionHeaderHeight = imageView.frame.height
        tableView.tableHeaderView = headerView
        headerView.addSubview(imageView)
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        
    }
    
    // Functions getting health data:
    func retrieveSleepAnalysis() {
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 5, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                if let result = tmpResult {
                    
                    // do something with my data
                    for item in result{
                        if let sample = item as? HKCategorySample {
                            if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue{
                                print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(sample.value)")
                                self.sleepTime = sample.endDate.timeIntervalSince(sample.startDate) / 3600
                                self.sleepers[0].sleepTime = self.sleepTime
                                print("sleepTime updated")
                                break
                            }
                        }
                    }
                    
                    /* no need for printing all the data
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "inBed" : "Asleep"
                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                        }
                    }
                    */
                }
            }
            
            // finally, we execute our query
            healthStore.execute(query)
            
            // Functions getting Data:
            // getSleepers() in heaven
            print("sleepers initialized")
            if let t = self.sleepTime{
                let sleeper = Sleeper(r:"", s:"user", t:t)
                self.sleepers.append(sleeper)
            } else {
                let sleeper = Sleeper(r:"", s:"user", t:0.00)
                self.sleepers.append(sleeper)
            }
            
            for index in 1...10 {
                let sleeper = Sleeper(r: "\(index)", s: "lalala", t: Double(index))
                self.sleepers.append(sleeper)
            }
        }
    }
    
    // Functions supporting tableView:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count:Int?
        
        count = 0
        
        if tableView == self.tableView {
            if sleepers != nil {
                count = sleepers.count
            }
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleeperCell", for: indexPath) as! SleeperCell
        
        cell.sleeper = sleepers[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        dismiss(animated: true, completion: {});
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? SleeperCell{
            
            cell.isSelected = false
            
            let indexPath = tableView.indexPath(for: cell)
            let sleeper = sleepers[indexPath!.row]
            
            let detailViewController = segue.destination as! SleeperDetailViewController
            
            detailViewController.sleeper = sleeper
        }
    }

}

