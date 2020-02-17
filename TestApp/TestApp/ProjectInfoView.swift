//
//  ProjectInfoView.swift
//  ProjectWalkerTestApp
//
//  Created by Simeon Leifer on 2/16/20.
//  Copyright © 2020 droolingcat.com. All rights reserved.
//

import ProjectWalker
import SwiftUI

struct ProjectInfoView: View {
    var project: XcodeProject

    var body: some View {
        VStack(alignment: .leading) {
            Text("path: \(project.path)")
            Text("archiveVersion: \(project.archiveVersion)")
            Text("classes: \(project.classes.count)")
            Text("objectVersion: \(project.objectVersion)")
            Text("rootObject: \(project.rootObject)")
            Text("objects: \(project.objects.count)")
        }
    }
}

struct ProjectInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectInfoView(project: XcodeProject())
    }
}
