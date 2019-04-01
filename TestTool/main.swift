//
//  main.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

import ProjectWalker

let path = "/Users/simeon/Documents/Code/git-glide/git-glide.xcodeproj/project.pbxproj"
let url = URL(fileURLWithPath: path)
let data = try! Data(contentsOf: url)
public var format: PropertyListSerialization.PropertyListFormat = .xml
let plist: ProjectFileDictionary = try! PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: &format) as? ProjectFileDictionary ?? [:]

public var project: XcodeProject = XcodeProject()

for key in plist.keys.sorted() {
    if key == "archiveVersion" {
        if let value = plist.int(forKey: "archiveVersion") {
            project.archiveVersion = value
        }
    }
    if key == "objectVersion" {
        if let value = plist.int(forKey: "objectVersion") {
            project.objectVersion = value
        }
    }
    if key == "objects" {
        if let objects = plist.dictionary(forKey: "objects") {
            for objectKey in objects.keys.sorted() {
                if let entry = objects.dictionary(forKey: objectKey) {
                    if let obj = ProjectObject.decode(from: entry) {
                        project.add(object: obj, for: objectKey)
                    }
                }
            }
        }
    }
    if key == "rootObject" {
        if let value = plist.string(forKey: "rootObject") {
            project.rootObject = value
        }
    }
}

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
