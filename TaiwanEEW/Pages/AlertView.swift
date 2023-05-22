//
//  AlertView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/5.
//

import SwiftUI

struct AlertView: View {
    // Instance
    @ObservedObject var eventManager: EventDispatcher
    // binding from @main
    @Binding var historyRange: TimeRange
    @Binding var subscribedLoc: Location
    
    var publishedTime: Date {eventManager.publishedTime}
    var arrivalTime: Date {eventManager.arrivalTime}
    var intensity: String {eventManager.intensity}
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    var pageInfo: some View {
        Group {
            LocationBlock(subscribedLoc: subscribedLoc).offset(x:UIScreen.baseLine, y:10)
            
            Group {
                Text("地震緊急速報").font(.largeTitle.bold())
                    .foregroundColor(.black)
            }.offset(x:30)
            Text("\(dateFormatter.string(from: publishedTime)) 發表")
                .padding(.bottom, 20.0)
                .offset(x: UIScreen.baseLine, y:5)
        }
    }
    
    var alertInfo: some View {
        Group {
            HStack {
                Spacer()
                TimeBlock(arrivalTime: arrivalTime)
                Spacer()
                IntensityBlock(intensity: intensity)
                Spacer()
            }
        }
    }
    
    var arrivalClockTimeBar: some View {
        Group {
            HStack (alignment: .center) {
                ZStack {
                    Rectangle().frame(width: 170.0, height: 40.0).clipped().cornerRadius(/*@START_MENU_TOKEN@*/7.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("Pad"))
                    Text("預計抵達時間").font(.system(size:20))
                }
                Text(dateFormatter.string(from: arrivalTime)).font(.system(size: 20))
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Color("Background"))
            //ConnectionStatusBar()
            
            VStack(alignment: .leading){
                pageInfo
                AlertStatusBar(arrivalTime: arrivalTime, intensity: intensity).offset(x:UIScreen.baseLine)
                alertInfo
                arrivalClockTimeBar.offset(x:UIScreen.baseLine)
                Spacer()
            }
        }
    }
}

//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView()
//    }
//}
