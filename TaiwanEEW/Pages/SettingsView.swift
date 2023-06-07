//
//  SettingsView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/8.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("locSelection") var locSelection: Location = .taipei
    @AppStorage("HRSelection") var HRSelection: TimeRange = .year
    var onHistoryRangeChanged: ((TimeRange) -> Void)?
    var onSubscribedLocChanged: ((Location) -> Void)?
    /*
     1. Selection in menu triggers the onChange
     2. onChange passes the new val into the onHistoryRangeChanged closure
     3. The closure, defined in @main, updates the var accessable between views
     */
    
    
    public static let shared = SettingsView()

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("alerts-pref-string")){
                        List {
                            Picker("location-pref-string", selection: $locSelection){
                                ForEach(Location.allCases){ location in
                                    Text(location.getDisplayName())
                                }
                            }
                        }
                    }.onChange(of: locSelection) { value in
                        onSubscribedLocChanged?(value)
                    }
                    Section(header: Text("history-pref-string")){
                        List {
                            Picker("history-time-range-string", selection: $HRSelection){
                                ForEach(TimeRange.allCases){ timeRange in
                                    Text(timeRange.getDisplayName())
                                }
                            }
                        }
                    }
                    .onChange(of: HRSelection) { value in
                        onHistoryRangeChanged?(value)
                    }
                }.navigationBarTitle("設定 Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
