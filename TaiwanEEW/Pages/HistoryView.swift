//
//  HistoryView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/14.
//

import SwiftUI

struct HistoryView: View{
    @StateObject var eventManager = EventDispatcher()
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text("測報歷史紀錄")
                    .font(.largeTitle)
                    .bold()
                .padding(.all)
                if(Date().timeIntervalSince(eventManager.event.last?.eventTime ?? Date(timeIntervalSince1970: 0)) < 24 * 3600){
                    ActiveStatusIndicator()
                }
            }
            Rectangle()
                .frame(width: UIScreen.screenWidth - UIScreen.baseLine, height: 1)
                .padding(.leading)
                .offset(y:-15)
            
            ScrollView {
                VStack {
                    ForEach(eventManager.event.reversed(), id: \.id){ event in
                        EventInfoBlock(e: event)
                    }
                }
            }.frame(width: UIScreen.screenWidth)
        }
        
        
    }
    
}

struct HistoryView_Preview: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
