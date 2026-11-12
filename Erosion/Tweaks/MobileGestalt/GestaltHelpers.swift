//
//  mg.swift
//  mond
//
//  Created by ruter on 16.07.26.
//
//  Typed accessors and conversion helpers for MobileGestalt keys and values.
//

import Foundation
import Darwin
import MachO
import UIKit


func mgWrite(_ data: Data) -> Bool {
    var res: (Bool, String)
    if UserDefaults.standard.bool(forKey: "mgWriteAtomically") {
        res = writeFileAtomically(data, to: MGURL.fsGestaltURL)
    } else {
        res = writeFileTemp(data, to: MGURL.fsGestaltURL)
    }
    
    if !res.0 {
        print("(mg) failed to apply gestalt: \(res.1)")
        return false
    }
    return true
}

// device info getters
// HD - hardware device
// each table lists the machine identifiers (as captured in ogMachineName on
// first launch, before any spoofing) that natively support the capability
private enum HDDeviceLists {
    static let dynamicIsland: Set<String> = ["iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let alwaysOnDisplay: Set<String> = ["iPhone15,2", "iPhone15,3", "iPhone16,1", "iPhone16,2", "iPhone17,1", "iPhone17,2", "iPhone18,1", "iPhone18,2", "iPhone18,3", "iPhone18,4", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let chargeLimit: Set<String> = ["iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4", "iPad16,1", "iPad16,2", "iPad15,7", "iPad15,8", "iPad14,8", "iPad14,9", "iPad14,10", "iPad14,11", "iPad15,3", "iPad15,4", "iPad15,5", "iPad15,6", "iPad16,8", "iPad16,9", "iPad16,10", "iPad16,11", "iPad16,3", "iPad16,4", "iPad16,5", "iPad16,6", "iPad17,1", "iPad17,2", "iPad17,3", "iPad17,4"]

    static let bootChime: Set<String> = ["iPhone14,7", "iPhone14,8", "iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,1", "iPhone18,2", "iPhone18,3", "iPhone18,4", "iPhone18,5", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let homeButton: Set<String> = ["iPhone12,8", "iPhone14,6"]

    static let appleIntelligence: Set<String> = ["iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4", "iPad16,1", "iPad16,2", "iPad13,16", "iPad13,17", "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7", "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11", "iPad14,3", "iPad14,4", "iPad14,5", "iPad14,6", "iPad14,8", "iPad14,9", "iPad14,10", "iPad14,11", "iPad15,3", "iPad15,4", "iPad15,5", "iPad15,6", "iPad16,3", "iPad16,4", "iPad16,5", "iPad16,6", "iPad16,8", "iPad16,9", "iPad16,10", "iPad16,11", "iPad17,1", "iPad17,2", "iPad17,3", "iPad17,4"]

    static let crashDetection: Set<String> = ["iPhone14,7", "iPhone14,8", "iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let pwm: Set<String> = ["iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let cameraControl: Set<String> = ["iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone19,2", "iPhone19,3", "iPhone19,7", "iPhone19,4"]

    static let actionButton: Set<String> = ["iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPhone19,2", "iPhone19,3", "iPhone19,7"]
}

private func isOriginalMachine(in devices: Set<String>) -> Bool {
    guard let machineName = UserDefaults.standard.string(forKey: "ogMachineName") else { return false }
    return devices.contains(machineName)
}

func isDynamIslandHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.dynamicIsland)
}

func isAODHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.alwaysOnDisplay)
}

func isChargeLimitHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.chargeLimit)
}

func isBootChimeHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.bootChime)
}

func isHomeButtonHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.homeButton)
}

func isAppleIntellHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.appleIntelligence)
}

func isCrashDectHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.crashDetection)
}

func isPWMHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.pwm)
}

func isCamControlHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.cameraControl)
}

func isActionButtonHD() -> Bool {
    return isOriginalMachine(in: HDDeviceLists.actionButton)
}
