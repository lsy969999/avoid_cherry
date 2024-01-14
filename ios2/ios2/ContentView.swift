//
//  ContentView.swift
//  ios2
//
//  Created by SY L on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonClicked = false
    var body: some View {
        VStack {
            Text("avoid cherry")
            BevyView(isButtonClicked: $buttonClicked)
//                .frame(width: 300, height: 500)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
