//
//  PBXNativeTarget.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXNativeTarget: ProjectObject {
    public var buildConfigurationList: Reference?
    public var buildPhases: [Reference]?
    public var dependencies: [Reference]?
    public var name: String?
    public var productInstallPath: String?
    public var productName: String?
    public var productReference: Reference?
    public var productType: String?
    public var packageProductDependencies: [Reference]?
    public var buildRules: ProjectFileArray?

    public required init(items: ProjectFileDictionary) {
        self.buildConfigurationList = items.string(forKey: "buildConfigurationList")
        self.buildPhases = items.stringArray(forKey: "buildPhases")
        self.dependencies = items.stringArray(forKey: "dependencies")
        self.name = items.string(forKey: "name")
        self.productInstallPath = items.string(forKey: "productInstallPath")
        self.productName = items.string(forKey: "productName")
        self.productReference = items.string(forKey: "productReference")
        self.productType = items.string(forKey: "productType")
        self.packageProductDependencies = items.stringArray(forKey: "packageProductDependencies")
        self.buildRules = items.array(forKey: "buildRules")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("buildConfigurationList")
        keys.remove("buildPhases")
        keys.remove("dependencies")
        keys.remove("name")
        keys.remove("productInstallPath")
        keys.remove("productName")
        keys.remove("productReference")
        keys.remove("productType")
        keys.remove("packageProductDependencies")
        keys.remove("buildRules")

        super.removeRead(keys: &keys)
    }

    public func getBuildConfigurationList() -> XCConfigurationList? {
        if let objects = project?.objects, let key = buildConfigurationList {
            return objects[key] as? XCConfigurationList
        }
        return nil
    }

    public func getBuildPhases() -> [PBXBuildPhase]? {
        if let objects = project?.objects, let files = buildPhases {
            return files.compactMap({ (key) -> PBXBuildPhase? in
                return objects[key] as? PBXBuildPhase
            })
        }
        return nil
    }

    public func getDependencies() -> [PBXTargetDependency]? {
        if let objects = project?.objects, let files = dependencies {
            return files.compactMap({ (key) -> PBXTargetDependency? in
                return objects[key] as? PBXTargetDependency
            })
        }
        return nil
    }

    public func getProductReference() -> PBXFileReference? {
        if let objects = project?.objects, let key = productReference {
            return objects[key] as? PBXFileReference
        }
        return nil
    }
}
