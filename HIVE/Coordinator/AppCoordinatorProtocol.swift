//
//  AppCoordinatorProtocol.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI

protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
//    var sheet: Sheet? { get set }
//    var fullScreenCover: FullScreenCover? { get set }

    func push(_ screen:  Screen)
//    func presentSheet(_ sheet: Sheet)
//    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
  func setSelectedTab(index: Tab)
 

//    func dismissSheet()
//    func dismissFullScreenOver()
}
