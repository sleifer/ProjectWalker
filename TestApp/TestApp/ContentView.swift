//
//  ContentView.swift
//  ProjectWalkerTestApp
//
//  Created by Simeon Leifer on 2/16/20.
//  Copyright © 2020 droolingcat.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tests: Tests

    var body: some View {
        VStack {
        Text("Hello, World!")
            Button(action: {
                self.tests.readTest()
            }) {
                Text("Run readTest")
            }
            Spacer()
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
