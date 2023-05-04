//
//  LocationBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/16.
//

import SwiftUI

struct LocationBlock: View {
    
    var locationCH = [
        Location.taipei : "台北市",
        Location.hsinchu : "新竹市" ,
        Location.taichung : "台中市" ,
        Location.kaohsiung : "高雄市" ,
        Location.pingtung : "屏東縣" ,
        Location.taitung : "台東縣" ,
        Location.hualian : "花蓮縣" ,
        Location.yilan : "宜蘭縣" ,
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 100.0, height: 40.0)
                .clipped()
                .cornerRadius(15.0)
            Text(locationCH[ SettingsView.shared.subscribedLoc]!)
                .foregroundColor(Color("Pad"))
                .font(Font.system(size: 20, design: .default).weight(.medium))
        }
        
    }
    
}

struct LocationBlock_Previews: PreviewProvider {
    static var previews: some View {
        LocationBlock()
    }
}
