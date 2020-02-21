//
//  PBXContainerItemProxy.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXContainerItemProxy: ProjectObject {
    public var containerPortal: Reference?
    public var proxyType: Int?
    public var remoteGlobalIDString: Reference?
    public var remoteInfo: String?

    public override init() {
        super.init()
        self.isa = "PBXContainerItemProxy"
    }

    public required init(items: ProjectFileDictionary) {
        self.containerPortal = items.string(forKey: "containerPortal")
        self.proxyType = items.int(forKey: "proxyType")
        self.remoteInfo = items.string(forKey: "remoteInfo")
        self.remoteGlobalIDString = items.string(forKey: "remoteGlobalIDString")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("containerPortal")
        keys.remove("proxyType")
        keys.remove("remoteInfo")
        keys.remove("remoteGlobalIDString")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = containerPortal {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("containerPortal = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("containerPortal = \(value.openStepQuoted());")
            }
        }
        if let value = proxyType {
            fileText.appendLine("proxyType = \(value);")
        }
        if let value = remoteInfo {
            fileText.appendLine("remoteInfo = \(value.openStepQuoted());")
        }
        if let value = remoteGlobalIDString {
            fileText.appendLine("remoteGlobalIDString = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getContainerPortal() -> PBXProject? {
        if let objects = project?.objects, let key = containerPortal {
            return objects[key] as? PBXProject
        }
        return nil
    }
}
