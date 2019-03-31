//
//  Project.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class Project {
    var archiveVersion: Int
    var objectVersion: Int
    var rootObject: String
    var objects: [String: ProjectObject]

    init() {
        archiveVersion = 0
        objectVersion = 0
        rootObject = ""
        objects = [:]
    }

    func root() -> PBXProject? {
        return objects[rootObject] as? PBXProject
    }

    func dumpUnhandledTypes() {
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

        print("Unhandled Object Types: \(filtered.count)")
        for item in filtered {
            print(" \(item)")
        }
    }
}
