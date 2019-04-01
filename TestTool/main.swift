//
//  main.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

import ProjectWalker

let path = "/Users/simeon/Documents/Code/git-glide/git-glide.xcodeproj"
public var project: XcodeProject = XcodeProject(contentsOf: path)

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
                        if let settings = configuration.buildSettings {
                            for (key, value) in settings {
                                print("\(key) = \(value)")
                            }
                        }
                    }
                }
            }
        }
    }
}
