//
//  Event.swift
//  DMSL-Analytics
//
//  Created by Dmytro Shulzhenko on 15.10.2020.
//

import UIKit
import Tagged

public struct Event {
    enum Key: String {
        case context
    }
    
    public typealias Context = Tagged<Self, String>

    let name: String
    private (set) var params: [String: Any]
    let isActive: Bool
    let isUrgent: Bool
    let states: Set<UIApplication.State>
    
    init(name: String,
         context: Context,
         params: [String: Any] = [:],
         isActive: Bool = true,
         isUrgent: Bool,
         states: Set<UIApplication.State> = [.active, .inactive]) {
        self.name = name
        self.params = params
        self.isActive = isActive
        self.isUrgent = isUrgent
        self.states = states
        
        self.params[Key.context.rawValue] = context.rawValue
    }
}

extension Event.Context {
    public static let initial: Self = "initial"
}
