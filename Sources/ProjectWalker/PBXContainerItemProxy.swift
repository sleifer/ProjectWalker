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

    public required init(items: ProjectFileDictionary) {
        self.containerPortal = items.string(forKey: "containerPortal")
        self.proxyType = items.int(forKey: "proxyType")
        self.remoteGlobalIDString = items.string(forKey: "remoteGlobalIDString")
        self.remoteInfo = items.string(forKey: "remoteInfo")

        super.init(items: items)
    }

    public func getContainerPortal() -> PBXProject? {
        if let objects = project?.objects, let key = containerPortal {
            return objects[key] as? PBXProject
        }
        return nil
    }
}
