//
//  PBXProject.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXProject: ProjectObject {
    public var buildConfigurationList: Reference?
    public var compatibilityVersion: String?
    public var developmentRegion: String?
    public var hasScannedForEncodings: Bool?
    public var knownRegions: [String]?
    public var mainGroup: Reference?
    public var productRefGroup: Reference?
    public var projectDirPath: String?
    public var projectReferences: ProjectFileDictionary?
    public var packageReferences: [Reference]?
    public var attributes: ProjectFileDictionary?
    public var projectRoot: String?
    public var targets: [Reference]?

    public required init(items: ProjectFileDictionary) {
        self.buildConfigurationList = items.string(forKey: "buildConfigurationList")
        self.compatibilityVersion = items.string(forKey: "compatibilityVersion")
        self.developmentRegion = items.string(forKey: "developmentRegion")
        self.hasScannedForEncodings = items.bool(forKey: "hasScannedForEncodings")
        self.knownRegions = items.stringArray(forKey: "knownRegions")
        self.mainGroup = items.string(forKey: "mainGroup")
        self.productRefGroup = items.string(forKey: "productRefGroup")
        self.projectDirPath = items.string(forKey: "projectDirPath")
        self.projectReferences = items.dictionary(forKey: "projectReferences")
        self.packageReferences = items.stringArray(forKey: "packageReferences")
        self.attributes = items.dictionary(forKey: "attributes")
        self.projectRoot = items.string(forKey: "projectRoot")
        self.targets = items.stringArray(forKey: "targets")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("buildConfigurationList")
        keys.remove("compatibilityVersion")
        keys.remove("developmentRegion")
        keys.remove("hasScannedForEncodings")
        keys.remove("knownRegions")
        keys.remove("mainGroup")
        keys.remove("productRefGroup")
        keys.remove("projectDirPath")
        keys.remove("projectReferences")
        keys.remove("packageReferences")
        keys.remove("attributes")
        keys.remove("projectRoot")
        keys.remove("targets")

        super.removeRead(keys: &keys)
    }

    public func getBuildConfigurationList() -> XCConfigurationList? {
        if let objects = project?.objects, let key = buildConfigurationList {
            return objects[key] as? XCConfigurationList
        }
        return nil
    }

    public func getMainGroup() -> PBXGroup? {
        if let objects = project?.objects, let key = mainGroup {
            return objects[key] as? PBXGroup
        }
        return nil
    }

    public func getProductRefGroup() -> PBXGroup? {
        if let objects = project?.objects, let key = productRefGroup {
            return objects[key] as? PBXGroup
        }
        return nil
    }

    public func getTargets() -> [PBXNativeTarget]? {
        if let objects = project?.objects, let targets = targets {
            return targets.compactMap({ (key) -> PBXNativeTarget? in
                return objects[key] as? PBXNativeTarget
            })
        }
        return nil
    }
}
