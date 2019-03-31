//
//  PBXContainerItemProxy.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXContainerItemProxy: ProjectObject {
    var containerPortal: Reference?
    var proxyType: Int?
    var remoteGlobalIDString: Reference?
    var remoteInfo: String?

    override init(items: ProjectFileDictionary) {
        self.containerPortal = items.string(forKey: "containerPortal")
        self.proxyType = items.int(forKey: "proxyType")
        self.remoteGlobalIDString = items.string(forKey: "remoteGlobalIDString")
        self.remoteInfo = items.string(forKey: "remoteInfo")

        super.init(items: items)
    }

    func getContainerPortal() -> PBXProject? {
        if let objects = project?.objects, let key = containerPortal {
            return objects[key] as? PBXProject
        }
        return nil
    }
}
