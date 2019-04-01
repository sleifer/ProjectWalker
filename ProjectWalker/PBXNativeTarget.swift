//
//  PBXNativeTarget.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXNativeTarget: ProjectObject {
    var buildConfigurationList: Reference?
    var buildPhases: [Reference]?
    var dependencies: [Reference]?
    var name: String?
    var productInstallPath: String?
    var productName: String?
    var productReference: Reference?
    var productType: String?

    override init(items: ProjectFileDictionary) {
        self.buildConfigurationList = items.string(forKey: "buildConfigurationList")
        self.buildPhases = items.stringArray(forKey: "buildPhases")
        self.dependencies = items.stringArray(forKey: "dependencies")
        self.name = items.string(forKey: "name")
        self.productInstallPath = items.string(forKey: "productInstallPath")
        self.productName = items.string(forKey: "productName")
        self.productReference = items.string(forKey: "productReference")
        self.productType = items.string(forKey: "productType")

        super.init(items: items)
    }

    func getBuildConfigurationList() -> XCConfigurationList? {
        if let objects = project?.objects, let key = buildConfigurationList {
            return objects[key] as? XCConfigurationList
        }
        return nil
    }

    func getBuildPhases() -> [PBXBuildPhase]? {
        if let objects = project?.objects, let files = buildPhases {
            return files.compactMap({ (key) -> PBXBuildPhase? in
                return objects[key] as? PBXBuildPhase
            })
        }
        return nil
    }

    func getDependencies() -> [PBXTargetDependency]? {
        if let objects = project?.objects, let files = dependencies {
            return files.compactMap({ (key) -> PBXTargetDependency? in
                return objects[key] as? PBXTargetDependency
            })
        }
        return nil
    }

    func getProductReference() -> PBXFileReference? {
        if let objects = project?.objects, let key = productReference {
            return objects[key] as? PBXFileReference
        }
        return nil
    }
}
