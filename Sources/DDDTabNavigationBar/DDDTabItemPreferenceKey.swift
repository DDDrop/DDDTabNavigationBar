//
//  DDDTabItemPreferenceKey.swift
//  
//
//  Created by DDDrop on 2020/12/14.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___.
//  All rights reserved.
//
    

import SwiftUI

struct DDDTabItemPreferenceKey: PreferenceKey {
    typealias Value = [DDDTabItemPreferenceData]
    
    static var defaultValue: [DDDTabItemPreferenceData] = []
    
    static func reduce(value: inout [DDDTabItemPreferenceData], nextValue: () -> [DDDTabItemPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}
