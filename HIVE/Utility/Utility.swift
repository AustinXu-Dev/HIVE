//
//  Utility.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import UIKit

final class Application_utility {
    
    static var rootViewController: UIViewController{
        
        //MARK: - View will lead to the google sign-in link got from Firebase
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
