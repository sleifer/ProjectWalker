//
//  Tests.swift
//  ProjectWalkerTestApp
//
//  Created by Simeon Leifer on 2/16/20.
//  Copyright © 2020 droolingcat.com. All rights reserved.
//

import Foundation
import ProjectWalker

class Tests: ObservableObject {
    func readTest() {
        let path = "/Users/simeon/Desktop/test2/test2.xcodeproj"
        if let project = XcodeProject(contentsOf: path) {
            project.dumpUnhandledTypes()
            if let proj = project.project() {
                print(proj)
                if let targets = proj.getTargets() {
                    for target in targets {
                        print(target)
                        if let configList = target.getBuildConfigurationList() {
                            print(configList)
                            print("default: \(configList.defaultConfigurationName ?? "<none>")")
                            if let configurations = configList.getBuildConfigurations() {
                                for configuration in configurations {
                                    print(configuration)
                                    print("base: \(configuration.baseConfigurationReference ?? "<none>")")
                                    print("name: \(configuration.name ?? "<none>")")
                                    print("marketing version: \(configuration.buildSettings?["MARKETING_VERSION"] as? String ?? "<missing>")")
                                    print("current project version: \(configuration.buildSettings?["CURRENT_PROJECT_VERSION"] as? String ?? "<missing>")")
//                            if let settings = configuration.buildSettings {
//                                for (key, value) in settings {
//                                    print("\(key) = \(value) .. \(type(of: value))")
//                                }
//                            }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
