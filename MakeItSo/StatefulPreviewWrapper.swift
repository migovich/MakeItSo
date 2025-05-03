//
//  StatefulPreviewWrapper.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content
    
    init(_ initial: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initial)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
