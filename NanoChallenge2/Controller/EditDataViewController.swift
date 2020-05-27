//
//  EditDataViewController.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 19/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit

class EditDataViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavbar()
        confirgureTableView()
    }
    
    func setNavbar(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if sectionsId == 0 {
            self.navigationItem.title = "Body Measurement"
        }
        else if sectionsId == 1 {
            self.navigationItem.title = "Intake Settings"
        }
        
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    func confirgureTableView(){
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = 60

        detailTableView.frame = view.frame
        detailTableView.tableFooterView = UIView()
        detailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)

    }
    
}

extension EditDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch sectionsId {
        case 0:
            SettingsSection(rawValue: 0)
        case 1:
            SettingsSection(rawValue: 1)
        case .none:
            return 0
        case .some(_):
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return noOfRows!
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 66/255, green: 165/255, blue: 238/255, alpha: 1)
        
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: sectionsId!)?.description
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
        
        guard let section = SettingsSection(rawValue: sectionsId!) else { return UITableViewCell()}
        
        switch section {
        case .Measurements:
            let measurement = MeasurementsOptions(rawValue: indexPath.row)
            cell.dispEditData.text = measurement?.description
            cell.dataTxtFields.text = measurement?.showData
            
        case .Intakes:
            let intake = IntakesOptions(rawValue: indexPath.row)
            cell.dispEditData.text = intake?.description
            cell.dataTxtFields.text = intake?.showData
            
        case .Permissions:
            let permission = PermissionsOptions(rawValue: indexPath.row)
            
        }
        return cell
    }
    
    
    @objc func saveData(){
        print("data updated")
    }
}
