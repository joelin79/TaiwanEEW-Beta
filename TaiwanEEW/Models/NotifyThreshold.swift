//
//  NotifyThreshold.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2023/6/19.
//

import Foundation
import SwiftUI

enum NotifyThreshold: String, CaseIterable, Identifiable, Codable {
    case test, eg0, eg1, eg2, eg3, eg4
    var id: Self {self}
    
    func getDisplayName() -> LocalizedStringKey {
        switch self {
        case .test:
            return "test"
        case .eg0:
            return LocalizedStringKey("eg0-string") // TODO: localization
        case .eg1:
            return LocalizedStringKey("eg1-string")
        case .eg2:
            return LocalizedStringKey("eg2-string")
        case .eg3:
            return LocalizedStringKey("eg3-string")
        case .eg4:
            return LocalizedStringKey("eg4-string")
        }
    }
    
    func getTopicKey() -> String {
        self.rawValue
    }
}
