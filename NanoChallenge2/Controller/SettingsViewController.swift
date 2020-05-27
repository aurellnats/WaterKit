//
//  SettingsViewController.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 18/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    var editData: EditDataViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingsTableView.reloadData()
        confirgureTableView()
        setNavbar()
        
    }
    
    func setNavbar(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Settings"
    }
    
    func confirgureTableView(){
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.rowHeight = 60
        
        settingsTableView.frame = view.frame
        settingsTableView.tableFooterView = UIView()
        settingsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        
//        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Measurements:
            return MeasurementsOptions.allCases.count
        case .Intakes:
            return IntakesOptions.allCases.count
        case .Permissions:
            return PermissionsOptions.allCases.count
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 66/255, green: 165/255, blue: 238/255, alpha: 1)
        
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 238/255, alpha: 1)
        footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 6)
        
        if section == 0 {
            let footerNotes = UILabel()
            footerNotes.font = UIFont.systemFont(ofSize: 14)
            footerNotes.text = "The suggestion water daily intake for you is 2.3 Litre"
            
            footerView.addSubview(footerNotes)
            footerNotes.translatesAutoresizingMaskIntoConstraints = false
            footerNotes.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10).isActive = true
            footerNotes.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 20).isActive = true
        }


        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell()}
        
        switch section {
        case .Measurements:
            let measurement = MeasurementsOptions(rawValue: indexPath.row)
            cell.sectionType = measurement
            cell.dispData.text = measurement?.showData
        case .Intakes:
            let intake = IntakesOptions(rawValue: indexPath.row)
            cell.sectionType = intake
            cell.dispData.text = intake?.showData
        case .Permissions:
            let permission = PermissionsOptions(rawValue: indexPath.row)
            cell.sectionType = permission
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Measurements:
            sectionsId = 0
            noOfRows = MeasurementsOptions.allCases.count
            performSegue(withIdentifier: "showDataDetails", sender: self)
            print(MeasurementsOptions(rawValue: indexPath.row)?.description)
        case .Intakes:
            sectionsId = 1
            noOfRows = IntakesOptions.allCases.count
            performSegue(withIdentifier: "showDataDetails", sender: self)
            print(IntakesOptions(rawValue: indexPath.row)?.description)
        case .Permissions:
            print(PermissionsOptions(rawValue: indexPath.row)?.description)
        }
            
        
    }

}
