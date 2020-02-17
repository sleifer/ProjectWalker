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

    public required init(items: ProjectFileDictionary) {
        self.target = items.string(forKey: "target")
        self.targetProxy = items.string(forKey: "targetProxy")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("target")
        keys.remove("targetProxy")

        super.removeRead(keys: &keys)
    }

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
