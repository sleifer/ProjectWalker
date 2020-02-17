//
//  PBXGroup.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXGroup: PBXFileElement {
    public var children: [Reference]?
    public var name: String?
    public var sourceTree: String?

    public required init(items: ProjectFileDictionary) {
        self.name = items.string(forKey: "name")
        self.sourceTree = items.string(forKey: "sourceTree")
        self.children = items.stringArray(forKey: "children")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("name")
        keys.remove("sourceTree")
        keys.remove("children")

        super.removeRead(keys: &keys)
    }

    public func getChildren() -> [PBXFileElement]? {
        if let objects = project?.objects, let children = children {
            return children.compactMap({ (key) -> PBXFileElement? in
                return objects[key] as? PBXFileElement
            })
        }
        return nil
    }
}
