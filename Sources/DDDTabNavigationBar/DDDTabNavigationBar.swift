//
//  DDDTabNavigationBar.swift
//
//
//  Created by DDDrop on 2020/12/14.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___.
//  All rights reserved.
//


import SwiftUI

struct DDDTabItem<Item>: View where Item: View {
    @Binding var selected: Int
    let index: Int
    var zoomRate: CGFloat = 1
    let item: () -> Item
    
    var body: some View {
        item()
            .anchorPreference(key: DDDTabItemPreferenceKey.self, value: .topLeading, transform: {[DDDTabItemPreferenceData(index: index, topLeading: $0)]})
            .transformAnchorPreference(key: DDDTabItemPreferenceKey.self, value: .bottomTrailing, transform: {
                $0[0].bottomTrailing = $1
            })
            .scaleEffect(selected == index ? max(zoomRate, 1) : 1)
            .animation(.easeInOut(duration: 0.3)).padding(10)
            .onTapGesture { self.selected = self.index}
    }
}


public struct DDDTabNavigationBar<Item, Indicator>: View where Item: View, Indicator: View {
    @Binding var selected: Int
    let zoomRate: CGFloat
    let items: [Item]
    let indicator: () -> Indicator
    let indicatorHeight: CGFloat
    
    public init(selected: Binding<Int>, zoomRate: CGFloat = 1, items: [Item], indicatorHeight: CGFloat = 4, indicator: @escaping () -> Indicator) {
        self.items = items
        self._selected = selected
        self.indicator = indicator
        self.zoomRate = zoomRate
        self.indicatorHeight = indicatorHeight
    }
    
    public var body: some View {
        HStack {
            ForEach(0..<items.count) { index in
                DDDTabItem(selected: $selected, index: index, zoomRate: zoomRate) {
                    items[index]
                }
            }
        }
        .backgroundPreferenceValue(DDDTabItemPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                self.createBorder(geometry, preferences)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
        Spacer().frame(height: max(indicatorHeight - 6, 0))
    }
    
    func createBorder(_ geometry: GeometryProxy, _ preferences: [DDDTabItemPreferenceData]) -> some View {
        let p = preferences.first(where: { $0.index == self.selected })
        
        let aTopLeading = p?.topLeading
        let aBottomTrailing = p?.bottomTrailing
        
        let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
        let bottomTrailing = aBottomTrailing != nil ? geometry[aBottomTrailing!] : .zero
        
        return DDDTabIndicatorWrapper(offset: CGPoint(x: topLeading.x, y: 4), width: bottomTrailing.x - topLeading.x) {
            GeometryReader {
                indicator().frame(minWidth: $0.size.width, maxHeight: indicatorHeight)
            }.animation(.easeInOut)
        }
    }
}

struct DDDTabIndicatorWrapper<Content: View>: View {
    let offset: CGPoint
    let width: CGFloat
    let content: () -> Content
    
    var body: some View {
        content()
            .frame(minWidth: width)
            .fixedSize()
            .offset(x: offset.x, y: offset.y)
    }
}

public struct DDDTabIndicatorDefault: View {
    let height: CGFloat
    let color: Color
    let offset: CGPoint
    
    public init(height: CGFloat = 4, color: Color = .red, offset: CGPoint = .zero) {
        self.height = height
        self.color = color
        self.offset = offset
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(color)
            .frame(height: height)
            .foregroundColor(color)
            .offset(x: offset.x, y: offset.y)
            .animation(.easeInOut(duration: 0.3))
    }
}
