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
            Text("ProjectWalker tests")
                .padding(.top)
            Text("Read from: \(tests.readPath)")
                .padding(.top)
            Text("Write to: \(tests.writePath)")
                .padding(.top)
            Button(action: {
                self.tests.readTest()
            }) {
                Text("Run readTest")
            }
            Button(action: {
                self.tests.writeTest()
            }) {
                Text("Run writeTest")
            }
            Button(action: {
                self.tests.configurationsTest()
            }) {
                Text("Run configurationsTest")
            }
            .disabled(self.tests.project == nil)
            Button(action: {
                self.tests.infoOnUnhandled()
            }) {
                Text("Run infoOnUnhandled")
            }
            .disabled(self.tests.project == nil)

            tests.project.map { project in
                ProjectInfoView(project: project)
            }
            .padding(.top)

            Group {
                Text("Batch tests: \(tests.batchTestPath)")
                    .padding(.top)
                Button(action: {
                    self.tests.batchTest()
            }) {
                    Text("Run batchTest")
                }
            }

            Spacer()
        }
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Tests())
    }
}
