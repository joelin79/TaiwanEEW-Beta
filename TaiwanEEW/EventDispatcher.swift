//
//  EventDispatcher.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/18.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class EventDispatcher: ObservableObject{
    @Published private(set) var event: [Event] = []
    @Published private(set) var lastEventId = ""
    @Published private(set) var arrivalTime: Date = Date(timeIntervalSince1970: 0)
    @Published private(set) var publishedTime: Date = Date(timeIntervalSince1970: 0)
    @Published private(set) var intensity: String = "0"
    
    let db = Firestore.firestore()
    init() {
        getEvents()
    }
    
    func getEvents(){
        
        // listening the collection of the selected location
        db.collection(SettingsView.shared.subscribedLoc.rawValue).addSnapshotListener { querySnapshot, error in
            
            // fetch documents into the "documents" array
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            // then decode documents into a compactMap of type Event array, and store into event
            
            self.event = documents.compactMap { document -> Event? in
                do {
                    return try document.data(as: Event.self)
                } catch {
                    print("Error decoding document into Event: \(error)")
                    return nil
                }
            }
            
            // sort Event by eventTime
            self.event.sort { $0.eventTime < $1.eventTime }
            
            // set lastEventId
//            if let id = self.event.last?.id {
//                self.lastEventId = id
//            }
            
            // set variables
            if let lastEvent = self.event.last,
                let arrivalTime = Calendar.current.date(byAdding: .second, value: lastEvent.seconds, to: lastEvent.eventTime)
            {
                self.arrivalTime = arrivalTime
                self.publishedTime = lastEvent.eventTime
                self.intensity = lastEvent.intensity
            }
            
            // set intensity
//            if let intensity = self.event.last?.intensity {
//                self.intensity = intensity
//            }
        }
    }
    
//    func sendMessage(text: String) {
//        do {
//            let newMessage = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
//            try db.collection("messages").document().setData(from: newMessage)
//        } catch {
//            print("Error adding message to Firestore: \(error)")
//        }
//    }
    
}