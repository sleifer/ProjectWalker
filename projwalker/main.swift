//
//  main.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

let path = "/Users/simeon/Documents/Code/git-glide/git-glide.xcodeproj/project.pbxproj"
let url = URL(fileURLWithPath: path)
let data = try! Data(contentsOf: url)
var format: PropertyListSerialization.PropertyListFormat = .xml
let plist: ProjectFileDictionary = try! PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: &format) as? ProjectFileDictionary ?? [:]

var project: Project = Project()

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
                        project.objects[objectKey] = obj
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

let proj = project.root()
