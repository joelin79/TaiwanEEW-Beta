//
//  SettingsView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/8.
//

import SwiftUI

//class SettingsModel: ObservableObject{
//    @Published var subscribedLoc: Location = .hsinchu
////    SettingsView.readFromUserDefault()
//}

struct SettingsView: View {
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    public static let shared = SettingsView()

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    
                    Section(header: Text("警報 Alert")){
                        List {
                            Picker("位置 Location", selection: $subscribedLoc){
                                ForEach(Location.allCases){ location in
                                    Text(location.rawValue)
                                }
                            }
                        }.navigationTitle("Settings")
                    }
                }
            }
            Text("更改位置設定後必須將應用程式關閉後重新啟動（把App向上滑掉）").font(.system(size: 30)).multilineTextAlignment(.center).padding(.horizontal, 20.0)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

/* All the unused codes made from hard work so cannot bear deleting them */


    /* Modifier after Picker */
    
    //.onReceive([self.settingsModel.subscribedLoc].publisher.first()) { (value) in
    //                            guard writeToUserDefault(value) else {
    //                                print("Error writing Location selection to UserDefaults (@SettingsView.Picker)")
    //                                return
    //                            }
    //                        }

    /* Attribute of struct */

//    @StateObject var settingsModel = SettingsModel()

    /* Functions under struct */

//    func writeToUserDefault (_ selection: Location?) -> Bool {
//        let userDefaults = UserDefaults.standard
//        // Write after encoding into String
//        if let data = try? JSONEncoder().encode(selection) {
//            userDefaults.set(data, forKey: "subscribedLoc")
//            return true
//        }
//        print("Error encoding Picker selection (@SettingsView.writeToUserDefault())")
//        return false
//    }
//
//    static func readFromUserDefault () -> Location? {
//        let userDefaults = UserDefaults.standard
//        // Read after decoding into Location
//        if let savedData = userDefaults.data(forKey: "subscribedLoc") {
//            let data = try? JSONDecoder().decode(Location.self, from: savedData)
//            return data         // this is nil, use try catch and see bug
//        }
//        print("Error reading Location to UserDefault (@SettingsView.readFromUserDefault() <-x- SettingsModel.subscribedLoc )")
//        return nil
//    }
    

