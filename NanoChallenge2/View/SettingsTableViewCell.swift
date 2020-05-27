//
//  SettingsTableViewCell.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 18/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit
import HealthKit
import UserNotifications

class SettingsTableViewCell: UITableViewCell {
    
    var isNotifOn: Bool = false
    
    var sectionType: SectionType? {
        didSet{
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            if switchControl.isHidden == true {
                if textLabel?.text != "Unit"
                {
                    self.accessoryType = .disclosureIndicator
                }
                addSubview(dispData)
                dispData.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                if textLabel?.text == "Unit" {
                    dispData.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
                } else {
                dispData.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
                }
            }
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = UIColor(red: 66/255, green: 165/255, blue: 238/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        if PermissionsOptions.Health.description == "Sync Health Data" {
            switchControl.addTarget(self, action: #selector(syncWithHealth), for: .valueChanged)
        }
        if PermissionsOptions.Notif.description == "Water Intake Notifications" {
            switchControl.addTarget(self, action: #selector(pushNotif), for: .valueChanged)
        }
        
        return switchControl
    }()
    
    lazy var dispData: UILabel = {
        let dispData = UILabel()
        dispData.translatesAutoresizingMaskIntoConstraints = false
        dispData.text = "data"

        return dispData
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerForPushNotifications() {
        if isNotifOn {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    if granted {
                        print("User gave permissions for local notifications")
                    }
            }
        }
    }
    
    @objc func syncWithHealth(sender: UISwitch){
        if sender.isOn {
            print("switch on")
            } else{
            print("turned off")
        }
    }
    
    @objc func pushNotif(sender: UISwitch){
        if sender.isOn {
            isNotifOn = true
            registerForPushNotifications()
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Drink your water!"
            content.body = "Take a cup of water or one third of your bottle"
            content.sound = .default
            
            var multiples = ["a", "b", "c"]
            
            for i in multiples {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
                
                let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if error != nil {
                        print("Error = \(error?.localizedDescription ?? "error local notification")")
                    }
                }
            }
            print(isNotifOn)
            isNotifOn = false
            
        } else{
            isNotifOn = false
            print("turned off")
        }
    }

}
