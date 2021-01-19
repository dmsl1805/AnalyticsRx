//
//  UIApplication+state.swift
//  DMSLAnalytics
//
//  Created by Dmytro Shulzhenko on 18.10.2020.
//

import UIKit

extension UIApplication {
    static var state: () -> State = { shared.applicationState }
}
