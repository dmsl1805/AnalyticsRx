//
//  ViewEvent.swift
//  DMSL-Analytics
//
//  Created by Dmytro Shulzhenko on 17.10.2020.
//

import UIKit

public struct ViewEvent: ParamsContainer {
    let name: String
    let context: Event.Context
    public var params: [String: Any]
    let isActive: Bool
    let isUrgent: Bool
    let states: Set<UIApplication.State>
    
    public init(context: Event.Context,
                params: [String: Any] = [:],
                isActive: Bool = true,
                isUrgent: Bool = false,
                states: Set<UIApplication.State> = [.active, .inactive]) {
        self.init(name: context.rawValue,
                  context: context,
                  params: params,
                  isActive: isActive,
                  isUrgent: isUrgent,
                  states: states)
    }
    
    public init(name: String,
                context: Event.Context,
                params: [String: Any] = [:],
                isActive: Bool = true,
                isUrgent: Bool = false,
                states: Set<UIApplication.State> = [.active, .inactive]) {
        self.name = "\(name)_view"
        self.context = context
        self.params = params
        self.isActive = isActive
        self.isUrgent = isUrgent
        self.states = states
    }
}
