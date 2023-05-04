//
//  Location.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/8/19.
//

import Foundation

enum Location: String, CaseIterable, Identifiable, Codable{
    case taipei, hsinchu, taichung, kaohsiung, pingtung, taitung, hualian, yilan
    var id: Self { self }
}
