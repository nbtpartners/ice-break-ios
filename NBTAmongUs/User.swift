//
//  User.swift
//  NBTAmongUs
//
//  Created by okmin lee on 2020/09/11.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import Foundation


struct User: Codable {
    var uid: uid
    var x: Double
    var y: Double
    var color: String
    enum uid: String, Codable {
        case ios
        case aos
        case web
    }
    
    func makeUpdatingJSON() -> [String: Any]? {
        guard let encoder = try? JSONEncoder().encode(self) else { return nil }
        guard let convertedJSON = try? JSONSerialization.jsonObject(with: encoder,
                                                           options: .allowFragments) as? [String: Any] else { return nil }
        return convertedJSON
    }
    
    static func decoder(with playerInfo: Data) -> User? {
        guard let decoder = try? JSONDecoder().decode(User.self, from: playerInfo) else { return nil }
        return decoder
    }
}
