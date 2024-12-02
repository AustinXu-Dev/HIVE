//
//  ParticipantMock.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 26/10/2024.
//

import Foundation

struct ParticipantMock {
    
    static let instance = ParticipantMock()
    private init(){}
    
  let participantA = ParticipantModel(userid: "1", name: "", profileImageUrl: "", instagramLink: "", bio: "")
    
    let participants = [
      ParticipantModel(userid: "1", name: "", profileImageUrl: "", instagramLink: "", bio: ""),
      ParticipantModel(userid: "2", name: "", profileImageUrl: "", instagramLink: "", bio: ""),
      ParticipantModel(userid: "3", name: "", profileImageUrl: "", instagramLink: "", bio: ""),
      ParticipantModel(userid: "4", name: "", profileImageUrl: "", instagramLink: "", bio: ""),
      ParticipantModel(userid: "5", name: "", profileImageUrl: "", instagramLink: "", bio: ""),


    ]
    let pendingParticipants = [
        PendingParticipantModel(userid: "1", name: "", profileImageUrl: "", instagramLink: "", bio: "")
    ]
}
