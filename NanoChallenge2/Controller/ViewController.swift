//
//  ViewController.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 18/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit
import HealthKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var context = LAContext()
    var noOfTap: Int = 0
    
    enum AuthenticationState{
        case loggedIn, loggedOut
    }
    var state = AuthenticationState.loggedOut
    
    var datas = SettingsData()
    
    
    var healthStore: HKHealthStore?
    var total: Double! = 0.0
    var add: Double = 2300/6
    var displayPercent: Int = 0
    var remaining: Double! = 0
    var error1 : String = "Error occurred"
    
    @IBAction func addWaterBtn(_ sender: UIButton) {
        noOfTap += 1
        getWaterData()
        faceIDAuthentication()
        
        setButtonImg(sender: sender)
        self.displayPercent = Int(self.calcPercentage(target: 2300, total:
            self.total))
        print(self.displayPercent)
        sender.setTitle("\(displayPercent)%", for: .normal)
    }
    
    @IBOutlet weak var dispTodaysDate: UILabel!
    @IBOutlet weak var dispTargetWater: UILabel!
    @IBOutlet weak var dispRemainingWater: UILabel!
    @IBAction func historyBtn(_ sender: Any) {
        UIApplication.shared.open(URL(string: "x-apple-health://")!) //buka ke water langsung
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorizeHealthKit()
        setNavbar()
        setDate()
        getWeightData()
        getHeightData()
        getWaterData()
        self.total = 0
        dispTargetWater.text = "\(datas.targetIntakes!/1000)"
        remaining = Double(Int(datas.targetIntakes!) - Int(self.total!))
        self.dispRemainingWater.text = "\(self.remaining!/1000)"
        self.displayPercent = Int(self.calcPercentage(target: 2300, total:
            self.total))
        
        
    }
    
    
    func setNavbar(){
        let settingBtn = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(goToSettings))
        
        self.navigationItem.rightBarButtonItem = settingBtn
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setDate(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd MMMM yyyy"
        let formattedDate = format.string(from: date)
        
        dispTodaysDate.text = "\(formattedDate)"
    }
    
    func calculateRemaining(){
        //target - current water
    }
    
    func getWeightData(){
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else { return }
        
        let startDate = Date.distantPast
        let today = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options:  .strictStartDate)
        
        //limit
        let limit = 10
        
        let weightSampleQuery = HKSampleQuery(sampleType: weightSampleType, predicate: predicate, limit: limit
        , sortDescriptors: nil) { (query, resultSamples, error) in
            
            DispatchQueue.main.async {
                guard let samples = resultSamples as? [HKQuantitySample] else{ return }
                
                for sample in samples{
                    let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                    print("weight = \(weight)")
                    data.weight = weight
                }
            }
            
        }
        healthStore?.execute(weightSampleQuery)
        
    }
    
    func getHeightData(){
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else { return }
        
        let startDate = Date.distantPast
        let today = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options:  .strictStartDate)
        
        //limit
        let limit = 10
        
        let heightSampleQuery = HKSampleQuery(sampleType: heightSampleType, predicate: predicate, limit: limit
        , sortDescriptors: nil) { (query, resultSamples, error) in
            
            DispatchQueue.main.async {
                guard let samples = resultSamples as? [HKQuantitySample] else{ return }
                
                for sample in samples{
                    let height = sample.quantity.doubleValue(for: .meterUnit(with: .centi))
                    print("height = \(height)")
                    data.height = height
                }
            }
            
        }
        healthStore?.execute(heightSampleQuery)
        
    }
    
    func getWaterData(){
        //sample type
        guard let waterSampleType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else { return }
        
        //predicate
        let calendar = Calendar.current
        let startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let today = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options:  .strictStartDate)
        
        //limit
        let limit = 10
        
        // descriptor (optional, boleh nil)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let waterSampleQuery = HKSampleQuery(sampleType: waterSampleType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, resultSample, error) in
            DispatchQueue.main.async {
                
                guard let samples = resultSample as? [HKQuantitySample] else {return}
                
                self.total = 0
                for sample in samples{
                    let waterIntake = sample.quantity.doubleValue(for: .literUnit(with: .milli))
                    let timestamp = sample.startDate
                    print("Water intake tanggal \(timestamp) = \(waterIntake)")
                    //                    let dispWater = UILabel()
                    //                    dispWater.text = "Water intake tanggal \(timestamp) = \(waterIntake)"
                    //                    view.addSubview(dispWater)
                    self.total += waterIntake
                }
            }
        }
        healthStore?.execute(waterSampleQuery)
    }
    
    func writeWaterData(value: Double){
        guard let waterQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else { return }
        
        //unitnya
        let unit = HKUnit.literUnit(with: .milli)
        
        //quantity
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        
        //start and end date
        let startDate = Date()
        let endDate = Date()
        
        //HKObject is the sample
        let waterQuantitySample = HKQuantitySample(type: waterQuantityType, quantity: quantity, start: startDate, end: endDate)
        
        //saving dieatary water
        healthStore!.save(waterQuantitySample, withCompletion: { (isSuccess, error) in
            print("success")
        })
    }
    
    func authorizeHealthKit(){
        //create healthstore
        healthStore = HKHealthStore()
        
        //request permission utk read & write data
        let requestedTypeForRead = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!, HKObjectType.quantityType(forIdentifier: .height)!, HKObjectType.quantityType(forIdentifier: .dietaryWater)!])
        
        healthStore?.requestAuthorization(toShare: requestedTypeForRead, read: requestedTypeForRead, completion: { (isAuthorized, error) in
            if isAuthorized {
                
            }
            else{
                fatalError("Fatal Error is not authorized. \(error?.localizedDescription ?? self.error1)")
            }
        })
        
    }
    
    func faceIDAuthentication(){
        context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            //show alert
            return
        }
        
        let reason = "Log in to add water"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        print("Authentication is successful")
                        self.state = .loggedIn
                        self.writeWaterData(value: self.add)
                        if self.remaining >= 0 {
                            self.remaining -= self.add
                        }
                        self.dispRemainingWater.text = "\(self.remaining!/1000)"
                        print(self.total)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        print("Authentication is error")
                    }
                }
            })
        } else {
            print("error")
        }
    }
    
    func setButtonImg(sender: UIButton){
        
        switch noOfTap {
        case 1:
            sender.setBackgroundImage(UIImage(named: "stage1"), for: .normal)
        case 2:
            sender.setBackgroundImage(UIImage(named: "stage2"), for: .normal)
        case 3:
            sender.setBackgroundImage(UIImage(named: "stage3"), for: .normal)
        case 4:
            sender.setBackgroundImage(UIImage(named: "stage4"), for: .normal)
        case 5 :
            sender.setBackgroundImage(UIImage(named: "stage5"), for: .normal)
        case 6 :
            sender.setBackgroundImage(UIImage(named: "stage6"), for: .normal)
        default:
            sender.setBackgroundImage(UIImage(named: "stage1"), for: .normal)
        }
        
    }
    
    func calcPercentage(target: Double, total: Double) -> Double{
        return ((total/target)*100)
    }

    @objc func goToSettings(){
        performSegue(withIdentifier: "goToSettingPage", sender: self)
    }
}

