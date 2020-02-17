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
    @Published var project: XcodeProject?

    func readTest() {
        let path = "/Users/simeon/Desktop/test2/test2.xcodeproj"
        project = XcodeProject(contentsOf: URL(fileURLWithPath: path))
        if let project = project {
            let filtered = project.unhandledTypes()

            if filtered.count != 0 {
                print("Unhandled Object Types: \(filtered.count)")
                for item in filtered {
                    print(" \(item)")
                }
            }
        }
    }

    func configurationsTest() {
        if let project = project {
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
                                    if let settings = configuration.buildSettings {
                                        for (key, value) in settings {
                                            print("\(key) = \(value) .. \(type(of: value))")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func infoOnUnhandled() {
        if let project = project {
            let types = project.unhandledTypes()

            for oneType in types {
                let objects = project.objects.values.filter { (obj) -> Bool in
                    if obj.items.string(forKey: "isa") == oneType {
                        return true
                    }
                    return false
                }

                print("\(oneType): \(objects.count)")
                if let first = objects.first {
                    print("referenceKey: \(first.referenceKey)")
                    print("items:")
                    dump(first.items)
                }
                print("- - -")
            }

            if types.count == 0 {
                print("No unhandled types.")
            }
        }
    }
}
