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

    public override init(items: ProjectFileDictionary) {
        self.target = items.string(forKey: "target")
        self.targetProxy = items.string(forKey: "targetProxy")

        super.init(items: items)
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
