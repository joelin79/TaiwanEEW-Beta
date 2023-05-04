//
//  EventInfoBlock.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/15.
//

import SwiftUI

struct EventInfoBlock: View{
    
    var e: Event
    
    
    var body: some View{
        RoundedRectangle(cornerRadius: 10)
            .frame(width: UIScreen.screenWidth - UIScreen.baseLine-10, height: 100)
            .foregroundColor(.white)
            
        // side color bar
            .overlay(
                Rectangle().frame(width: 15, height: 100).foregroundColor(Color(e.intensity)), alignment: .leading
            )
        
        // text
            .overlay(
                
                HStack{
                    Spacer()
                    VStack {
                        Text("預測級數").foregroundColor(.secondary)
                            .bold()
                        Text(e.intensity)
                            .font(.system(size: 32))
                        .bold()
                    }
                    Spacer()
                    Divider().overlay(.gray).frame(height: 70)
                    Spacer()
                    
                    VStack (alignment: .leading){
                        Spacer()
                        Text("發生時間").foregroundColor(.secondary)
                        Text(e.eventTime.formatted())
                        Spacer()
                        HStack {
                            Text("預測倒數").foregroundColor(.secondary)
                            Text(String(e.seconds))
                        }
                        Spacer()
                    }
                    Spacer()
                    
                }
                
                
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        
        // border
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1))

    }
}

struct EventInfoBlock_Preview: PreviewProvider{
    static var previews: some View {
        EventInfoBlock(e: Event(id: "testerS", intensity: "4", seconds: 66, eventTime: Date()))
    }
    
}
