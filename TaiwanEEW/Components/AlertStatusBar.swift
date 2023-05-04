//
//  AlertStatusBar.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/2/18.
//

import SwiftUI

struct AlertStatusBar : View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var arrivalTime: Date
    var intensity: String
    @State private var opacity: Double = 1
    @State private var fillColor: Color = .green
    @State private var isAlert: Bool = false
    @State private var isMajor: Bool = false
    @State private var isUpdated: Bool = false     // used to indicate if arrivalTime is updated to non-default value (1970/1/1)
    
    
    var body: some View {
        Rectangle()
        // Color
            .fill( (isUpdated) ? (isAlert) ? (isMajor) ? Color.red : Color.yellow : Color.green : Color.gray)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/3/*@END_MENU_TOKEN@*/)
            .frame(width:
                    UIScreen.baseLine+340,
                   height: 50.0)
            .clipped()
            .overlay(
        // Text
                StrokeText(text: (isUpdated) ? (isAlert) ? (isMajor) ? "緊 急 地 震 速 報" : "地 震 通 報 發 表 中" : "目前無發布地震資訊" : "載入中...", width: (isMajor) ? 0.75 : 0 , color: .black)
                    .foregroundColor( (isMajor) ? .white : .black)
                    .font(.system(size: 28).bold().monospaced())
        // Opacity Animation
            ).opacity(opacity)
            .onReceive(timer) { _ in
                updateAlert()
                print(arrivalTime.formatted())
            }
            .onAppear {
                updateAlert()
            }
            
    }

    private func updateAlert() {
        
        // updates isInAlert (true before 5 seconds after wave arrival
        let now = Date()
        let isInAlert = now.addingTimeInterval(TimeInterval(0-5)) < arrivalTime
        if isInAlert != isAlert {
            isAlert = isInAlert
            if isAlert {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
        
        // updates isUpdate
        if arrivalTime > Date(timeIntervalSince1970: 1000){
            isUpdated = true
        } else {
            isUpdated = false       // FYI: AlertView defaults arrivalTime value to 1970/1/1 before firebase is connected
        }
        
        // updates isMajor
        if (isAlert && intensity.first!.wholeNumberValue! >= 4 ) {
            isMajor = true
        } else {
            isMajor = false
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.1).delay(0.25).repeatForever()) {
                opacity = 0.5
            }
        }

    private func stopAnimation() {
        withAnimation (.linear(duration: 0.1)){
            opacity = 1.0
        }
    }
    
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct AlertStatusBar_Preview : PreviewProvider {
    static var previews: some View {
        AlertStatusBar(arrivalTime: Date(), intensity: "3")
    }
    
}
