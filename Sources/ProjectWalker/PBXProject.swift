//
//  PBXProject.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXProject: ProjectObject, BuildConfigurationListUser {
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

    public override var openStepComment: String {
        return "Project object"
    }

    public override init() {
        super.init()
    }

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

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = attributes {
            fileText.appendLine("attributes = {")
            fileText.indent()
            try value.write(to: fileText)
            fileText.outdent()
            fileText.appendLine("};")
        }
        if let value = buildConfigurationList {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("buildConfigurationList = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("buildConfigurationList = \(value.openStepQuoted());")
            }
        }
        if let value = compatibilityVersion {
            fileText.appendLine("compatibilityVersion = \(value.openStepQuoted());")
        }
        if let value = developmentRegion {
            fileText.appendLine("developmentRegion = \(value.openStepQuoted());")
        }
        if let value = hasScannedForEncodings {
            fileText.appendLine("hasScannedForEncodings = \(value ? 1 : 0);")
        }
        if let value = knownRegions {
            fileText.appendLine("knownRegions = (")
            fileText.indent()
            for item in value {
                fileText.appendLine("\(item.openStepQuoted()),")
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = mainGroup {
            fileText.appendLine("mainGroup = \(value.openStepQuoted());")
        }
        if let value = packageReferences {
            fileText.appendLine("packageReferences = (")
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
        if let value = productRefGroup {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("productRefGroup = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("productRefGroup = \(value.openStepQuoted());")
            }
        }
        if let value = projectDirPath {
            fileText.appendLine("projectDirPath = \(value.openStepQuoted());")
        }
        if let value = projectReferences {
            fileText.appendLine("projectReferences = {")
            fileText.indent()
            try value.write(to: fileText)
            fileText.outdent()
            fileText.appendLine("};")
        }
        if let value = projectRoot {
            fileText.appendLine("projectRoot = \(value.openStepQuoted());")
        }
        if let value = targets {
            fileText.appendLine("targets = (")
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
        fileText.outdent()
        fileText.appendLine("};")
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
