//
//  PBXVariantGroup.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class PBXVariantGroup: ProjectObject {
    public var name: String?
    public var children: [Reference]?
    public var sourceTree: String?

    public required init(items: ProjectFileDictionary) {
        self.name = items.string(forKey: "name")
        self.children = items.stringArray(forKey: "children")
        self.sourceTree = items.string(forKey: "sourceTree")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("name")
        keys.remove("children")
        keys.remove("sourceTree")

        super.removeRead(keys: &keys)
    }

    public func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = children {
            return files.compactMap({ (key) -> PBXBuildFile? in
                return objects[key] as? PBXBuildFile
            })
        }
        return nil
    }
}
