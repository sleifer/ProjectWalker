//
//  PBXGroup.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXGroup: PBXFileElement {
    var children: [Reference]?
    var name: String?
    var sourceTree: String?

    override init(items: ProjectFileDictionary) {
        self.name = items.string(forKey: "name")
        self.sourceTree = items.string(forKey: "sourceTree")
        self.children = items.stringArray(forKey: "children")

        super.init(items: items)
    }
    
    func getChildren() -> [PBXFileElement]? {
        if let objects = project?.objects, let children = children {
            return children.compactMap({ (key) -> PBXFileElement? in
                return objects[key] as? PBXFileElement
            })
        }
        return nil
    }
}
