#!/usr/bin/env python3
"""Extract Bool's actual apply/read logic and run it on harmless fixture plists.
Run on macOS with Xcode command line tools. Does not open any system plist.
"""
from pathlib import Path
import subprocess, tempfile
s = Path('Erosion/Tweaks/MobileGestalt/GestaltView.swift').read_text()
apply = s.split('            guard mgSubtype > 0 else {', 1)[1].split('            let data = try PropertyListSerialization.data', 1)[0]
apply = 'guard mgSubtype > 0 else {' + apply
read = s.split('    private func mgReadSavedSubtype() throws -> Int {',1)[1].split('\n    private func mgApply(',1)[0].rsplit('    }',1)[0]
# Same functions as the app, with the path redirected to a temporary fixture.
swift = r'''
import Foundation
extension String: @retroactive Error {}
enum MGKey {
    static let artwork = "oPeik/9e8lQWMszEjbPzng"
    static let prodType = "h9jDsbgj7xIVeIQ8S3/X3Q"
}
enum MGURL { static var fsGestaltURL = URL(fileURLWithPath: CommandLine.arguments[1]) }
struct CustomKey { let key: String; let value: Int; let isOn: Bool }
final class Store { var mgCurrentDict = NSMutableDictionary() }
let store = Store()
let mgEnableDeviceName = false
let mgDeviceName = "unused"
let mgProductType = "iPhone14,5"
let customKeys = [CustomKey(key: "KeepOn", value: 1, isOn: true), CustomKey(key: "RemoveMe", value: 1, isOn: false)]
func apply(_ mgSubtype: Int) throws -> NSMutableDictionary {
''' + apply + r'''
return mgDictToApply
}
func readSaved() throws -> Int {
''' + read + r'''
}
let original: [String: Any] = [
    "CacheExtra": [MGKey.artwork: ["ArtworkDeviceSubType": 2532, "UnrelatedArtwork": "keep"], "KeepOther": "yes", "RemoveMe": 1],
    "CacheData": Data([1, 2, 3])
]
let originalData = try PropertyListSerialization.data(fromPropertyList: original, format: .binary, options: 0)
// Immutable nested dictionaries are the important regression case.
let parsed = try PropertyListSerialization.propertyList(from: originalData, options: [], format: nil) as! NSDictionary
store.mgCurrentDict = parsed.mutableCopy() as! NSMutableDictionary
for subtype in [2556, 2796, 2622, 2868, 2736, 2532, 2480] {
    let updated = try apply(subtype)
    let data = try PropertyListSerialization.data(fromPropertyList: updated, format: .binary, options: 0)
    try data.write(to: MGURL.fsGestaltURL)
    precondition(try readSaved() == subtype)
    let extra = updated["CacheExtra"] as! NSDictionary
    let artwork = extra[MGKey.artwork] as! NSDictionary
    precondition(artwork["UnrelatedArtwork"] as? String == "keep")
    precondition(extra["KeepOther"] as? String == "yes")
    precondition(extra["KeepOn"] as? Int == 1)
    precondition(extra["RemoveMe"] == nil)
    precondition(updated["CacheData"] as? Data == Data([1, 2, 3]))
    let before = store.mgCurrentDict["CacheExtra"] as! NSDictionary
    precondition((before[MGKey.artwork] as! NSDictionary)["ArtworkDeviceSubType"] as? Int == 2532)
}
do { _ = try apply(0); fatalError("zero must fail") } catch {}
do { _ = try apply(-1); fatalError("sentinel must fail") } catch {}
try Data("invalid".utf8).write(to: MGURL.fsGestaltURL)
do { _ = try readSaved(); fatalError("invalid plist must fail") } catch {}
print("PASS: seven profile round-trips, unknown-current preservation, unrelated keys, independent source, invalid profile and malformed read-back")
'''
# precondition's autoclosure cannot throw.
swift = swift.replace('precondition(try readSaved() == subtype)', 'let saved = try readSaved()\n    precondition(saved == subtype)')
with tempfile.TemporaryDirectory() as tmp:
    file = Path(tmp)/'test.swift'
    file.write_text(swift)
    subprocess.run(['swift', str(file), str(Path(tmp)/'fixture.plist')], check=True)
