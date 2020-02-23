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

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let name = name {
            fileText.appendLine("name = \(name);")
        }
        if let value = target {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("target = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("target = \(value.openStepQuoted());")
            }
        }
        if let value = targetProxy {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("targetProxy = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("targetProxy = \(value.openStepQuoted());")
            }
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getTarget() -> PBXTarget? {
        if let objects = project?.objects, let key = target {
            return objects[key] as? PBXTarget
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
