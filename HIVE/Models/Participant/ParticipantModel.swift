//
//  struct ParticipantModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 26/10/2024.
//

import Foundation

struct ParticipantModel : Codable, Hashable {
    var userid : String?
    let name, profileImageUrl, bio : String?
}
