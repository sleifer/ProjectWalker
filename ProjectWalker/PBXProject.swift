//
//  PBXProject.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXProject: ProjectObject {
    var buildConfigurationList: Reference?
    var compatibilityVersion: String?
    var developmentRegion: String?
    var hasScannedForEncodings: Bool?
    var knownRegions: [String]?
    var mainGroup: Reference?
    var productRefGroup: Reference?
    var projectDirPath: String?
    var projectReferences: ProjectFileDictionary?
    var projectRoot: String?
    var targets: [Reference]?

    override init(items: ProjectFileDictionary) {
        self.buildConfigurationList = items.string(forKey: "buildConfigurationList")
        self.compatibilityVersion = items.string(forKey: "compatibilityVersion")
        self.developmentRegion = items.string(forKey: "developmentRegion")
        self.hasScannedForEncodings = items.bool(forKey: "hasScannedForEncodings")
        self.knownRegions = items.stringArray(forKey: "knownRegions")
        self.mainGroup = items.string(forKey: "mainGroup")
        self.productRefGroup = items.string(forKey: "productRefGroup")
        self.projectDirPath = items.string(forKey: "projectDirPath")
        self.projectReferences = items.dictionary(forKey: "projectReferences")
        self.projectRoot = items.string(forKey: "projectRoot")
        self.targets = items.stringArray(forKey: "targets")

        super.init(items: items)
    }

    func getBuildConfigurationList() -> XCConfigurationList? {
        if let objects = project?.objects, let key = buildConfigurationList {
            return objects[key] as? XCConfigurationList
        }
        return nil
    }

    func getMainGroup() -> PBXGroup? {
        if let objects = project?.objects, let key = mainGroup {
            return objects[key] as? PBXGroup
        }
        return nil
    }

    func getProductRefGroup() -> PBXGroup? {
        if let objects = project?.objects, let key = productRefGroup {
            return objects[key] as? PBXGroup
        }
        return nil
    }

    func getTargets() -> [PBXNativeTarget]? {
        if let objects = project?.objects, let targets = targets {
            return targets.compactMap({ (key) -> PBXNativeTarget? in
                return objects[key] as? PBXNativeTarget
            })
        }
        return nil
    }
}
