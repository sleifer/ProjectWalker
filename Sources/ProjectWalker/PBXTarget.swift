//
//  PBXTarget.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXTarget: ProjectObject, BuildConfigurationListUser {
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

    public override var openStepComment: String {
        return name ?? "<target>"
    }

    public override init() {
        super.init()
        self.isa = "PBXTarget"
    }

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

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = buildConfigurationList {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("buildConfigurationList = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("buildConfigurationList = \(value.openStepQuoted());")
            }
        }
        if let value = buildPhases {
            fileText.appendLine("buildPhases = (")
            fileText.indent()
            for item in value {
                if let object = project?.object(withKey: item) {
                    fileText.appendLine("\(item.openStepQuoted()) /* \(object.openStepComment) */,")
                } else {
                    fileText.appendLine("\(item.openStepQuoted()),")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = buildRules {
            fileText.appendLine("buildRules = (")
            fileText.indent()
            for item in value {
                if let value = item as? String {
                    fileText.appendLine("\(value.openStepQuoted()),")
                } else {
                    fileText.appendLine("\(item),")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = dependencies {
            fileText.appendLine("dependencies = (")
            fileText.indent()
            for item in value {
                if let object = project?.object(withKey: item) {
                    fileText.appendLine("\(item.openStepQuoted()) /* \(object.openStepComment) */,")
                } else {
                    fileText.appendLine("\(item.openStepQuoted()),")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = name {
            fileText.appendLine("name = \(value.openStepQuoted());")
        }
        if let value = packageProductDependencies {
            fileText.appendLine("packageProductDependencies = (")
            fileText.indent()
            for item in value {
                if let object = project?.object(withKey: item) {
                    fileText.appendLine("\(item.openStepQuoted()) /* \(object.openStepComment) */,")
                } else {
                    fileText.appendLine("\(item.openStepQuoted()),")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = productInstallPath {
            fileText.appendLine("productInstallPath = \(value.openStepQuoted());")
        }
        if let value = productName {
            fileText.appendLine("productName = \(value.openStepQuoted());")
        }
        if let value = productReference {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("productReference = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("productReference = \(value.openStepQuoted());")
            }
        }
        if let value = productType {
            fileText.appendLine("productType = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
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
