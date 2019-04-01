//
//  Project.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class XcodeProject {
    public var archiveVersion: Int
    public var objectVersion: Int
    public var rootObject: String
    private(set) public var objects: [String: ProjectObject]

    public init() {
        archiveVersion = 0
        objectVersion = 0
        rootObject = ""
        objects = [:]
    }

    public func add(object: ProjectObject, for key: String) {
        objects[key] = object
        object.project = self
    }
    
    public func project() -> PBXProject? {
        return objects[rootObject] as? PBXProject
    }

    public func dumpUnhandledTypes() {
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

        if filtered.count != 0 {
            print("Unhandled Object Types: \(filtered.count)")
            for item in filtered {
                print(" \(item)")
            }
        }
    }
}
