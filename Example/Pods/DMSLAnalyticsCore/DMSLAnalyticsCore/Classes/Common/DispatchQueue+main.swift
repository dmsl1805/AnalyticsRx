//
//  DispatchQueue+main.swift
//  DMSLAnalytics
//
//  Created by Dmytro Shulzhenko on 18.10.2020.
//

import Dispatch

extension DispatchQueue {
    private static var token: DispatchSpecificKey<()> = {
        let key = DispatchSpecificKey<()>()
        DispatchQueue.main.setSpecific(key: key, value: ())
        return key
    }()

    static var isMain: Bool {
        DispatchQueue.getSpecific(key: token) != nil
    }
    
    static func safeSyncOnMain<T>(_ execute: () throws -> T) rethrows -> T {
        isMain ? try execute() : try main.sync(execute: execute)
    }
}
