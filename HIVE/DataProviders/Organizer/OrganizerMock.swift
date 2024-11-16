//
//  OrganizerMock.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 27/10/2024.
//

import Foundation

struct OrganizerMock {
    static let instance = OrganizerMock()
    private init(){}
    
  let organizer = OrganizerModel(userid: "1", name: "Si Si", profileImageUrl: "", instagramLink: "", bio: "")
}
