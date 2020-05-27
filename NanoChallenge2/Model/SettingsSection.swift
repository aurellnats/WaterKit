//
//  SettingsSection.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 18/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

var data = SettingsData()
var permission = PermissionData()

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}


enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Measurements
    case Intakes
    case Permissions
    
    var description: String {
        switch self {
        case .Measurements:
            return "Body Measurements"
        case .Intakes:
            return "Intake Settings"
        case .Permissions:
            return "Permissions"
        }
    }
}

enum MeasurementsOptions: Int, CaseIterable, SectionType {
    case Weight
    case Height
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .Weight:
            return "Weight"
        case .Height:
            return "Height"
        }
    }
    
    var showData: String {
        switch self {
        case .Weight:
            return "\(data.weight!) kg"
        case .Height:
            return "\(data.height!) cm"
        }
    }
}

enum IntakesOptions: Int, CaseIterable, SectionType {
    
    case Target
    case Unit
    case startTime
    case endTime
    case Interval
    case ContainerSize
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .Target:
            return "Intake Target per Day"
        case .Unit:
            return "Unit"
        case .startTime:
            return "Starting Time"
        case .endTime:
            return "Ending Time"
        case .Interval:
            return "Interval"
        case .ContainerSize:
            return "Container Size"
        }
    }
    
    var showData: String {
        switch self {
        case .Target:
            return "2.3 Litre"
        case .Unit:
            return "Litre"
        case .startTime:
            return "8.00"
        case . endTime:
            return "21.00"
        case .Interval:
            return "30 mins"
        case .ContainerSize:
            return "600 mL"
        }
        
    }
}

enum PermissionsOptions: Int, CaseIterable, SectionType {
    case Health
    case Notif
    
    var containsSwitch: Bool {
        switch self {
        case .Health:
            return true
        case .Notif:
            return true
        }
    }
    
    var description: String {
        switch self {
        case .Health:
            return "Sync Health Data"
        case .Notif:
            return "Water Intake Notifications"
        }
    }
}
