//
//  SettingsView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/8.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("subscribedLoc") var subscribedLoc: Location = .taipei
    @AppStorage("historyRange") var historyRange: TimeRange = .year
    public static let shared = SettingsView()

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("警報 Alerts")){
                        List {
                            Picker("位置 Location", selection: $subscribedLoc){
                                ForEach(Location.allCases){ location in
                                    Text(location.rawValue)
                                }
                            }
                        }
                    }
                    Section(header: Text("歷史 History")){
                        List {
                            Picker("歷史紀錄顯示 History Time Range", selection: $historyRange){
                                ForEach(TimeRange.allCases){ timeRange in
                                    Text(timeRange.rawValue)
                                }
                            }
                        }
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
