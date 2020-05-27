//
//  Model.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 19/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import Foundation

struct SettingsData {
    var weight: Double?
    var height: Double?
    var targetIntakes: Double? = 2300
}

struct PermissionData {
    var isSyncedToHealth: Bool = false
    var isPushedNotif: Bool = false
}

//struct IntakesData {
//    var targetIntakes: Double
//    var unit: String
//    var startTime: String
//    var endTime: String
//    var interval: Int
//    var cntrSize: Int
//    var cntrUnit: String
//}

var noOfRows: Int?
var sectionsId: Int?
