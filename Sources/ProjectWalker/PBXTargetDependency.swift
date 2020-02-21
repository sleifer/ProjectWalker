//
//  PBXTargetDependency.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXTargetDependency: ProjectObject {
    public var target: Reference?
    public var targetProxy: Reference?
    public var name: String?

    public override var openStepComment: String {
        return name ?? "PBXTargetDependency"
    }

    public override init() {
        super.init()
        self.isa = "PBXTargetDependency"
    }

    public required init(items: ProjectFileDictionary) {
        self.target = items.string(forKey: "target")
        self.targetProxy = items.string(forKey: "targetProxy")
        self.name = items.string(forKey: "name")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("target")
        keys.remove("targetProxy")
        keys.remove("name")

        super.removeRead(keys: &keys)
    }

    #warning("needs write")
    
    public func getTarget() -> PBXNativeTarget? {
        if let objects = project?.objects, let key = target {
            return objects[key] as? PBXNativeTarget
        }
        return nil
    }

    public func getTargetProxy() -> PBXContainerItemProxy? {
        if let objects = project?.objects, let key = targetProxy {
            return objects[key] as? PBXContainerItemProxy
        }
        return nil
    }
}
