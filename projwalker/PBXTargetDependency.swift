//
//  PBXTargetDependency.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXTargetDependency: ProjectObject {
    var target: Reference?
    var targetProxy: Reference?

    override init(items: ProjectFileDictionary) {
        self.target = items.string(forKey: "target")
        self.targetProxy = items.string(forKey: "targetProxy")

        super.init(items: items)
    }
}
