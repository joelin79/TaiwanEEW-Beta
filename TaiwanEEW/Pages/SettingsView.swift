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
                    Section(header: Text("警報 Alerts")){
                        List {
                            Picker("位置 Location", selection: $locSelection){
                                ForEach(Location.allCases){ location in
                                    Text(location.rawValue)
                                }
                            }
                        }
                    }.onChange(of: locSelection) { value in
                        onSubscribedLocChanged?(value)
                    }
                    Section(header: Text("歷史 History")){
                        List {
                            Picker("歷史紀錄顯示 History Time Range", selection: $HRSelection){
                                ForEach(TimeRange.allCases){ timeRange in
                                    Text(timeRange.rawValue)
                                }
                            }
                        }
                    }
                    .onChange(of: HRSelection) { value in
                        onHistoryRangeChanged?(value)
                    }
                    
                }.navigationBarTitle("設定 Settings")
            }
            Text("更改位置設定後必須將應用程式關閉後重新啟動（把App向上滑掉）").font(.system(size: 25)).multilineTextAlignment(.center).padding(.horizontal, 20.0)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
