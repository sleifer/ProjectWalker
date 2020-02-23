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
            Divider()
            OldTestsView()
            Divider()
            BatchTestsView()
            Divider()
            SingleReadWriteTestView()
            Spacer()
        }
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
}

struct SingleReadWriteTestView: View {
    @EnvironmentObject var tests: Tests
    @State var projectPath: String = ""

    var body: some View {
        VStack {
            TextField("Project", text: $projectPath)
            .padding()
            Button(action: {
                self.tests.readWriteTest(self.projectPath)
            }) {
                Text("Run readWriteTest")
            }
            Text(tests.readWriteResult)
            .padding()
        }
    }
}

struct BatchTestsView: View {
    @EnvironmentObject var tests: Tests

    var body: some View {
        VStack {
            Text("Batch tests: \(tests.batchTestPath)")
                .padding(.top)
            Button(action: {
                self.tests.batchTest()
            }) {
                Text("Run batchTest")
            }
        }
    }
}

struct OldTestsView: View {
    @EnvironmentObject var tests: Tests

    var body: some View {
        VStack {
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
                self.tests.infoOnUnhandled()
        }) {
                Text("Run infoOnUnhandled")
            }
            .disabled(self.tests.project == nil)

            tests.project.map { project in
                ProjectInfoView(project: project)
            }
            .padding(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Tests())
    }
}
