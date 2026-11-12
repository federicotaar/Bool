//
//  GestaltView.swift
//  Erosion
//
//  Created by lunginspector on 8/14/26.
//
//  MobileGestalt tweak list: toggle hidden device capabilities with per-tweak warnings.
//

import SwiftUI

import UniformTypeIdentifiers

struct GestaltView: View {
    @EnvironmentObject private var mgr: ErosionManager
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgOverrideGates") private var mgOverrideGates = false
    @AppStorage("mgWriteAtomically") private var mgWriteAtomically = true
    @AppStorage("autoRespring") var autoRespring = false
    @AppStorage("hasShownSheet") private var hasShownSheet = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var mgSubtype = 0
    @State private var mgOgSubtype = 0
    @State private var mgOgDeviceName = ""
    @State private var mgEnableDeviceName = false
    @AppStorage("mgDeviceName") private var mgDeviceName = ""
    @AppStorage("ogMachineName") private var ogMachineName = ""
    @AppStorage("mgCustomSubtype") private var mgCustomSubtype = 2436
    @AppStorage("showRegionTweak") private var showRegionTweak = false
    @AppStorage("showCustomKeys") private var showCustomKeys = false
    @AppStorage("mgCustKeyArray") var customKeys: [MGCustomKey] = []
    @State private var mgProductType = ""
    
    @State private var showInfoSheet = false
    @State private var idiotButtonTimerComplete = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Picker("Subtype", selection: $mgSubtype) {
                            Text("Original (\(mgOgSubtype))").tag(mgOgSubtype)
                            if isDynamIslandHD() && doubleSysVrs() < 19.0 {
                                Text("Disable Dynamic Island").tag(2436)
                            }
                            Text("iPhone 14 Pro").tag(2436)
                            Text("iPhone 14 Pro Max").tag(2796)
                            Text("iPhone 15 Pro Max").tag(2976)
                            if doubleSysVrs() >= 18.0 {
                                Text("iPhone 16 Pro").tag(2622)
                                Text("iPhone 16 Pro Max").tag(2868)
                            }
                            if doubleSysVrs() >= 26.0 {
                                Text("iPhone Air").tag(2736)
                            }
                            if doubleSysVrs() >= 27.0 {
                                Text("iPhone 18 Pro Max").tag(2670)
                            }
                            if isHomeButtonHD() {
                                Text("iPhone X Gestures").tag(2436)
                            }
                            Text("Custom Height...").tag(-1)
                        }
                        Spacer()
                        Button {
                            Alertinator.shared.alert(title: "Subtype Info", body: MGMsg.subtype)
                        } label: {
                            Image(systemName: "info.circle")
                                .frame(width: 24, height: 22)
                        }
                        .buttonStyle(.plain)
                    }
                    if mgSubtype == -1 {
                        VStack(alignment: .leading, spacing: 10) {
                            IslandPositionPreview(subtype: mgCustomSubtype, range: customSubtypeRange)
                                .frame(height: 170)
                                .padding(.top, 4)
                            HStack {
                                Text("Height")
                                Spacer()
                                Text("\(mgCustomSubtype)")
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(
                                value: Binding(
                                    get: { Double(mgCustomSubtype) },
                                    set: { mgCustomSubtype = Int($0.rounded()) }
                                ),
                                in: customSubtypeRange,
                                step: 1
                            )
                            Text("Drag to preview where the island will sit, then Apply. Higher values move it lower; your original height is \(mgOgSubtype).")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Toggle("Custom Device Name", isOn: $mgEnableDeviceName)
                    if mgEnableDeviceName {
                        TextField("Device Name", text: $mgDeviceName)
                    }
                } header: {
                    HeaderLabel("Artwork", symbol: "paintbrush.pointed")
                }
                
                if !isDynamIslandHD() || !isAODHD() || !isBootChimeHD() || !isChargeLimitHD() || mgOverrideGates {
                    Section {
                        if !isDynamIslandHD() || mgOverrideGates {
                            PlainToggle("Enable Dynamic Island", minVrs: 19.0, isOn: store.mgKeyBinding([MGKey.island]))
                        }
                        if !isAODHD() || mgOverrideGates {
                            PlainToggle("Enable AOD", infoType: .warning, infoMessage: MGMsg.aodUnsupported, minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.AOD, MGKey.AOTime]))
                            if store.isEnabled([MGKey.AOD]) {
                                PlainToggle("Enable AOD Vibrancy", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.AODVibrancy]))
                            }
                        }
                        if !isChargeLimitHD() || mgOverrideGates {
                            PlainToggle("Enable Charge Limit", minVrs: 17.0, isOn: store.mgKeyBinding([MGKey.chargeLim]))
                        }
                        if !isBootChimeHD() || mgOverrideGates {
                            PlainToggle("Enable Boot Chime", isOn: store.mgKeyBinding([MGKey.bootChime]))
                        }
                    } header: {
                        HeaderLabel("Hardware Features", symbol: "gearshape")
                    }
                }
                
                Section {
                    PlainToggle("Enable Internal Install", infoType: .info, infoMessage: MGMsg.intInstall, isOn: store.mgKeyBinding([MGKey.intInstall]))
                    PlainToggle("Enable Internal Build", infoType: .info, infoMessage: MGMsg.intBuild, isOn: store.mgKeyBinding([MGKey.intBuild]))
                } header: {
                    HeaderLabel("Internal", symbol: "ant")
                }
                .disabled(store.isEnabled([MGKey.appIntell]))
                
                Section {
                    PlainToggle("Enable SRD UI", minVrs: 26.0, isOn: store.mgKeyBinding([MGKey.srd]))
                    if showRegionTweak {
                        PlainToggle("Disable Region Restrictions", isOn: store.mgRegionRestrictionsBinding())
                    }
                    if !isAppleIntellHD() || mgOverrideGates {
                        PlainToggle("Enable Apple Intelligence", minVrs: 18.1, isOn: store.mgKeyBinding([MGKey.appIntell]))
                            .onChange(of: store.mgKeyBinding([MGKey.appIntell]).wrappedValue) { (oldVal, newVal) in
                                if newVal {
                                    store.mgPullKeys([MGKey.intBuild, MGKey.intInstall])
                                }
                            }
                    }
                    HStack(spacing: 10) {
                        Picker("Spoofing", selection: $mgProductType) {
                            Text("Default").tag(ogMachineName)
                            if ogMachineName.contains("Pad") {
                                if doubleSysVrs() >= 17.4 {
                                    Text("iPad Pro 11-inch (M4)").tag("iPad16,3")
                                    Text("iPad Pro 11-inch (M4, Cellular)").tag("iPad16,4")
                                }
                                Text("iPad Pro 11-inch (4th Gen)").tag("iPad14,3")
                                Text("iPad Pro 11-inch (4th Gen, Cellular)").tag("iPad14,4")
                            } else {
                                Text("iPhone 15 Pro").tag("iPhone16,1")
                                Text("iPhone 15 Pro Max").tag("iPhone16,2")
                                if doubleSysVrs() >= 18.0 {
                                    Text("iPhone 16").tag("iPhone17,3")
                                    Text("iPhone 16 Plus").tag("iPhone17,4")
                                    Text("iPhone 16 Pro").tag("iPhone17,1")
                                    Text("iPhone 16 Pro Max").tag("iPhone17,2")
                                }
                                if doubleSysVrs() >= 19.0 {
                                    Text("iPhone 17").tag("iPhone18,3")
                                    Text("iPhone 17 Pro").tag("iPhone18,1")
                                    Text("iPhone 17 Pro Max").tag("iPhone18,2")
                                    Text("iPhone Air").tag("iPhone18,4")
                                }
                                if doubleSysVrs() >= 27.0 {
                                    Text("iPhone 18 Pro").tag("iPhone19,2")
                                    Text("iPhone 18 Pro Max").tag("iPhone19,3")
                                    Text("iPhone Duo").tag("iPhone19,4")
                                }
                            }
                        }
                        Button {
                            Alertinator.shared.alert(title: "Device Spoofing Info", body: isAppleIntellHD() ? MGMsg.spoofUseless : MGMsg.spoofAI)
                        } label: {
                            Image(systemName: "info.circle")
                                .frame(width: 24, height: 22)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    HeaderLabel("Eligibility", symbol: "flag")
                }
                
                Section {
                    if !isCrashDectHD() || mgOverrideGates {
                        PlainToggle("Crash Detection", isOn: store.mgKeyBinding([MGKey.crashDet]))
                    }
                    if !isPWMHD() || mgOverrideGates {
                        PlainToggle("Pulse Width Modulation", minVrs: 19.0, isOn: store.mgKeyBinding([MGKey.pwm]))
                    }
                    if ogMachineName.contains("iPhone") || mgOverrideGates {
                        PlainToggle("Apple Pencil", isOn: store.mgKeyBinding([MGKey.appPencil]))
                    }
                    if !isCamControlHD() || mgOverrideGates {
                        PlainToggle("Camera Control", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.camButton, MGKey.grapPefr]))
                    }
                    if !isActionButtonHD() || mgOverrideGates {
                        PlainToggle("Action Button", minVrs: 17.0, isOn: store.mgKeyBinding([MGKey.actButton]))
                    }
                    if isHomeButtonHD() || mgOverrideGates {
                        PlainToggle("Tap to Wake", isOn: store.mgKeyBinding([MGKey.tapToWake]))
                    }
                } header: {
                    HeaderLabel("Preference Bundles", symbol: "gear")
                }
                
                Section {
                    if machineName().contains("iPad") || mgOverrideGates {
                        PlainToggle("Enable Stage Manager", isOn: store.mgKeyBinding([MGKey.stageMgr]))
                    }
                    if store.strVal(forKey: MGKey.deviceClass) == "iPhone" || mgOverrideGates {
                        PlainToggle("Enable iPadOS UI", infoType: .warning, infoMessage: MGMsg.ipadOS, isOn: store.mgTrollPadBinding())
                    }
                } header: {
                    HeaderLabel("iPadOS", symbol: "ipad")
                }
            }
            .navigationTitle("MobileGestalt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            mgRevert()
                        } label: {
                            Label("Revert Tweaks", systemImage: "xmark")
                        }
                        
                        Button(role: .destructive) {
                            Alertinator.shared.alert(title: "Are you sure you'd like to reset MobileGestalt?", body: MGMsg.mgReset, actionLabel: "Confirm", action: {
                                do {
                                    try fm.removeItem(at: MGURL.savedGestaltURL)
                                    try fm.removeItem(at: MGURL.fsGestaltURL)
                                    store.mgCurrentDict = NSMutableDictionary()
                                    Alertinator.shared.alert(title: "Successfully reset MobileGestalt!", body: MGMsg.mgResetComp, showCancel: false, actionLabel: "Exit App", action: { exitinator() })
                                } catch {
                                    print("(mg) failed to reset mobilegestalt: \(error.localizedDescription)")
                                    Alertinator.shared.alert(title: "Failed to reset MobileGestalt!", body: AppMsg.opFailed)
                                }
                            })
                        } label: {
                            Label("Reset Gestalt", systemImage: "trash")
                        }
                        
                        Divider()
                        
                        if showCustomKeys {
                            NavigationLink(destination: CustomKeyView()) {
                                Label("Custom Keys", systemImage: "pencil")
                            }
                        }
                        
                        // tweak-specific settings
                        NavigationLink {
                            List {
                                Section {
                                    Button("Export Current Gestalt") {
                                        presentShareSheet(with: MGURL.fsGestaltURL)
                                    }
                                    Button("Export Original Gestalt") {
                                        presentShareSheet(with: MGURL.savedGestaltURL)
                                    }
                                    Button("Reset Saved Gestalt", role: .destructive) {
                                        Alertinator.shared.alert(title: "Warning!", body: MGMsg.mgResetSavWarn, action: {
                                            try? fm.removeItem(at: MGURL.savedGestaltURL)
                                            let _ = mgLoadData()
                                        })
                                    }
                                } header: {
                                    HeaderLabel("Data", symbol: "loupe")
                                }
                                
                                Section {
                                    PlainToggle("Show Hidden Tweaks", infoType: .warning, infoMessage: MGMsg.hidTweakWarn, isOn: $mgOverrideGates)
                                    Toggle("Show Custom Keys", isOn: $showCustomKeys)
                                    Toggle("Overwrite Atomically", isOn: $mgWriteAtomically)
                                } footer: {
                                    Text("When atomic writes are enabled, MobileGestalt will not revert after a reboot.")
                                }
                            }
                            .navigationTitle("Gestalt Settings")
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis")
                            .labelStyle(.iconOnly)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply", role: .adaptiveConfirm) {
                        if !hasShownSheet {
                            showInfoSheet = true
                        } else {
                            mgApply()
                        }
                    }
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                NavigationStack {
                    VStack {
                        InfoSheet(title: "Before you begin...") {
                            InfoSheetCell(title: "Important Warning!", symbol: "exclamationmark.triangle.fill", context: MGMsg.support)
                                .modifier(SectionPlatter())
                            InfoSheetCell(title: "Apple Intelligence (Classic)", symbol: "apple.intelligence", context: MGMsg.spoofAI)
                            InfoSheetCell(title: "iPadOS UI", symbol: "ipad", context: MGMsg.ipadOS)
                            InfoSheetCell(title: "Region Restrictions", symbol: "map", context: MGMsg.region)
                        } button: {
                            Button("Apply") {
                                showInfoSheet = false
                                hasShownSheet = true
                                idiotButtonTimerComplete = false
                                mgApply(isFromSheet: true)
                            }
                            .buttonStyle(ConfirmButtonStyle())
                            .padding(.horizontal, 30)
                            .padding(.bottom, device.userInterfaceIdiom == .pad ? 25 : 0)
                            .disabled(!idiotButtonTimerComplete)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            idiotButtonTimerComplete = true
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Cancel") {
                                showInfoSheet = false
                                idiotButtonTimerComplete = false
                            }
                        }
                    }
                }
            }
            .onAppear {
                store.mgCurrentDict = mgLoadData()
                let isWritable = fm.isWritableFile(atPath: MGURL.fsGestaltURL.path)
                if !isWritable {
                    let res = wq.grantAccess(path: MGURL.fsGestaltURL.deletingLastPathComponent().path)
                    if !res.0 {
                        Alertinator.shared.alert(title: "Failed to get write access to MobileGestalt!", body: "Tweaks will NOT apply. Maybe try restarting the app?")
                    }
                }
            }
        }
    }
    
    private func mgLoadData() -> NSMutableDictionary {
        do {
            let mgData = try Data(contentsOf: MGURL.fsGestaltURL)
            if !fm.fileExists(atPath: MGURL.savedGestaltURL.path) {
                try mgData.write(to: MGURL.savedGestaltURL)
                if let locale = Locale.current.region?.identifier {
                    showRegionTweak = locale != "US"
                }
            }
            
            if let ogDict = NSDictionary(contentsOf: MGURL.savedGestaltURL),
               let ogCacheExtra = ogDict["CacheExtra"] as? NSDictionary,
               let ogArtwork = ogCacheExtra[MGKey.artwork] as? NSDictionary {
                mgOgSubtype = ogArtwork["ArtworkDeviceSubType"] as? Int ?? 0
                mgOgDeviceName = ogArtwork["ArtworkDeviceProductDescription"] as? String ?? ""
            } else {
                throw "failed to get information from mobilegestalt"
            }
            
            guard let currentDict = NSMutableDictionary(contentsOf: MGURL.fsGestaltURL) else {
                throw "failed to get nsmutabledictionary from mobilegestalt"
            }
            
            if let cacheExtra = currentDict["CacheExtra"] as? NSDictionary,
               let artwork = cacheExtra[MGKey.artwork] as? NSDictionary {
                mgSubtype = artwork["ArtworkDeviceSubType"] as? Int ?? 0
                let knownSubtypes = [mgOgSubtype, 2436, 2796, 2976, 2622, 2868, 2736, 2670]
                if !knownSubtypes.contains(mgSubtype) {
                    // the current subtype isn't one of the presets, so surface it as a manual value
                    mgCustomSubtype = mgSubtype
                    mgSubtype = -1
                }
                mgDeviceName = artwork["ArtworkDeviceProductDescription"] as? String ?? ""
                if mgDeviceName != mgOgDeviceName {
                    mgEnableDeviceName = true
                }
                mgProductType = cacheExtra[MGKey.prodType] as? String ?? machineName()
            }
            
            return currentDict
        } catch {
            print("(mg) failed to get mobilegestalt: \(error.localizedDescription)")
            Haptic.shared.play(.heavy)
            Alertinator.shared.alert(title: "Failed to get MobileGestalt!", body: "Tweaks will not work properly. Please leave this page.", showCancel: false, actionLabel: "Exit", action: { dismiss() })
        }
        
        return [:]
    }
    
    // slider span for the custom subtype: a bit below the original height (island
    // rises) up to well past it (island sinks); 2532 is a safe fallback if the
    // original gestalt could not be read
    private var customSubtypeRange: ClosedRange<Double> {
        let og = mgOgSubtype > 0 ? mgOgSubtype : 2532
        return Double(max(2200, og - 200))...Double(og + 400)
    }

    private func mgApply(isFromSheet: Bool = false) {
        do {
            let mgDictToApply = store.mgCurrentDict
            
            if let cacheExtra = mgDictToApply["CacheExtra"] as? NSMutableDictionary,
               let artwork = cacheExtra[MGKey.artwork] as? NSMutableDictionary {
                // a manually entered subtype always wins when selected; fall back to the
                // original subtype if the custom value isn't a plausible positive number
                let subtypeToApply = mgSubtype == -1 ? mgCustomSubtype : mgSubtype
                artwork["ArtworkDeviceSubType"] = subtypeToApply > 0 ? subtypeToApply : mgOgSubtype
                if mgEnableDeviceName {
                    artwork["ArtworkDeviceProductDescription"] = mgDeviceName
                }
                cacheExtra[MGKey.prodType] = mgProductType
                for item in customKeys {
                    if item.isOn {
                        cacheExtra[item.key] = item.value
                    } else {
                        cacheExtra.removeObject(forKey: item.key)
                    }
                }
            } else {
                throw "failed to write keys to mobilegestalt!"
            }
            
            let data = try PropertyListSerialization.data(fromPropertyList: mgDictToApply, format: .binary, options: 0)
            let res = mgWrite(data)
            
            if res {
                print("[*] successfully overwrote mobilegestalt!")
                Haptic.shared.play(.soft)
                if autoRespring || isFromSheet {
                    mgr.shouldRespring = true
                } else {
                    Alertinator.shared.alert(title: "Successfully appiled MobileGestalt tweaks!", body: AppMsg.applied + (store.isEnabled([MGKey.appIntell]) ? " You'll have to reboot your device if you want to use Apple Intelligence." : ""), actionLabel: "Respring", action: { mgr.shouldRespring = true })
                }
            } else {
                throw "overwrite failed!"
            }
        } catch {
            print("(mg) failed to apply mobilegestalt: \(error.localizedDescription)")
            Alertinator.shared.alert(title: "Failed to apply MobileGestalt!", body: "Error: \(error.localizedDescription)")
        }
    }
    
    private func mgRevert() {
        do {
            guard let mgDictToApply = NSMutableDictionary(contentsOf: MGURL.savedGestaltURL) else {
                throw "failed to get mobilegestalt dict!"
            }
            
            let data = try PropertyListSerialization.data(fromPropertyList: mgDictToApply, format: .binary, options: 0)
            let res = mgWrite(data)
            
            if res {
                print("[*] successfully overwrote mobilegestalt!")
                Haptic.shared.play(.soft)
                if let dict = NSMutableDictionary(contentsOf: MGURL.savedGestaltURL) {
                    store.mgCurrentDict = dict
                }
                Alertinator.shared.alert(title: "Successfully reverted MobileGestalt tweaks!", body: MGMsg.revertComp)
            } else {
                throw "overwrite failed!"
            }
        } catch {
            print("(mg) failed to revert mobilegestalt: \(error.localizedDescription)")
            Alertinator.shared.alert(title: "Failed to revert MobileGestalt!", body: AppMsg.opFailed)
        }
    }
}

// approximate on-screen preview of where the Dynamic Island will sit for a given
// ArtworkDeviceSubType: across the slider range the island travels from overlapping
// the notch (lowest value) to clearly below it (highest value)
private struct IslandPositionPreview: View {
    let subtype: Int
    let range: ClosedRange<Double>

    private var fraction: Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0.5 }
        return min(1, max(0, (Double(subtype) - range.lowerBound) / span))
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let barH: CGFloat = 13
            let topY: CGFloat = 8            // overlapping the notch
            let bottomY: CGFloat = h * 0.45  // clearly below the notch
            let islandY = topY + (bottomY - topY) * fraction
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(Color(.separator), lineWidth: 1)
                Capsule()
                    .fill(Color.primary)
                    .frame(width: w * 0.5, height: barH)
                    .offset(y: topY)
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: w * 0.38, height: barH)
                    .offset(y: islandY)
                    .animation(.easeOut(duration: 0.1), value: islandY)
            }
        }
    }
}

#Preview {
    ContentView()
}
