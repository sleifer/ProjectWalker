//
//  Project.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class XcodeProject {
    public var path: String
    public var archiveVersion: Int
    public var classes: ProjectFileDictionary
    public var objectVersion: Int
    public var rootObject: String
    private(set) public var objects: [String: ProjectObject]

    public init() {
        self.path = ""
        self.archiveVersion = 0
        self.classes = ProjectFileDictionary()
        self.objectVersion = 0
        self.rootObject = ""
        self.objects = [:]
    }

    public convenience init?(contentsOf path: String) {
        self.init()
        do {
            self.path = NSString(string: path).appendingPathComponent("project.pbxproj")
            let url = URL(fileURLWithPath: self.path)
            let data = try Data(contentsOf: url)
            var format: PropertyListSerialization.PropertyListFormat = .xml
            let plist: ProjectFileDictionary = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: &format) as? ProjectFileDictionary ?? [:]

            for key in plist.keys.sorted() {
                if key == "archiveVersion" {
                    if let value = plist.int(forKey: "archiveVersion") {
                        self.archiveVersion = value
                    }
                }
                if key == "objectVersion" {
                    if let value = plist.int(forKey: "objectVersion") {
                        self.objectVersion = value
                    }
                }
                if key == "objects" {
                    if let objects = plist.dictionary(forKey: "objects") {
                        for objectKey in objects.keys.sorted() {
                            if let entry = objects.dictionary(forKey: objectKey) {
                                if let obj = ProjectObject.decode(from: entry) {
                                    self.add(object: obj, for: objectKey)
                                }
                            }
                        }
                    }
                }
                if key == "classes" {
                    if let value = plist.dictionary(forKey: "classes") {
                        self.classes = value
                    }
                }
                if key == "rootObject" {
                    if let value = plist.string(forKey: "rootObject") {
                        self.rootObject = value
                    }
                }
            }
        } catch {
            print(error)
            return nil
        }
    }

    public func add(object: ProjectObject, for key: String) {
        objects[key] = object
        object.project = self
        object.referenceKey = key
    }

    public func project() -> PBXProject? {
        return objects[rootObject] as? PBXProject
    }

    public func unhandledTypes() -> [String] {
        let generics = objects.values.filter({ (obj: ProjectObject) -> Bool in
            if type(of: obj) == ProjectObject.self {
                return true
            }
            return false
        })

        let types = generics.map { (obj: ProjectObject) -> String in
            return obj.items.string(forKey: "isa") ?? "<unknown>"
        }

        let filtered = Array(Set(types)).sorted()

        return filtered
    }
}
