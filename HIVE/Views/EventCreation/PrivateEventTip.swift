//
//  PrivateEventTip.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 4/12/2567 BE.
//

import Foundation
import TipKit

struct PrivateEventTip: Tip{
    
    var title: Text {
        Text("Make your event private")
    }
    
    var message: Text?{
        Text("By turning on this your event will be private")
    }
    
    var options: [any TipOption] {
        [MaxDisplayCount(1), IgnoresDisplayFrequency(true)]
    }
}
