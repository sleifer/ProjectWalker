//
//  XCConfigurationList.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class XCConfigurationList: ProjectObject {
    public var buildConfigurations: [Reference]?
    public var defaultConfigurationIsVisible: Bool?
    public var defaultConfigurationName: String?

    public override var openStepComment: String {
        if let user = project?.buildConfigurationListUserForObject(withKey: referenceKey) {
            if let user = user as? PBXProject {
                var name = user.openStepComment
                if let targetObject = project?.object(withKey: user.targets?.first) {
                    name = targetObject.openStepComment
                }
                return "Build configuration list for PBXProject \"\(name)\""
            } else if let user = user as? PBXNativeTarget {
                return "Build configuration list for PBXNativeTarget \"\(user.openStepComment)\""
            } else if let user = user as? PBXAggregateTarget {
                return "Build configuration list for PBXAggregateTarget \"\(user.openStepComment)\""
            }
        }
        return "XCConfigurationList"
    }

    public override init() {
        super.init()
        self.isa = "XCConfigurationList"
    }

    public required init(items: ProjectFileDictionary) {
        self.buildConfigurations = items.stringArray(forKey: "buildConfigurations")
        self.defaultConfigurationIsVisible = items.bool(forKey: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = items.string(forKey: "defaultConfigurationName")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("buildConfigurations")
        keys.remove("defaultConfigurationIsVisible")
        keys.remove("defaultConfigurationName")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = buildConfigurations {
            fileText.appendLine("buildConfigurations = (")
            fileText.indent()
            for oneFile in value {
                if let file = project?.object(withKey: oneFile) {
                    fileText.appendLine("\(oneFile) /* \(file.openStepComment) */,")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = defaultConfigurationIsVisible {
            fileText.appendLine("defaultConfigurationIsVisible = \(value ? 1 : 0);")
        }
        if let value = defaultConfigurationName {
            fileText.appendLine("defaultConfigurationName = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getBuildConfigurations() -> [XCBuildConfiguration]? {
        if let objects = project?.objects, let keys = buildConfigurations {
            return keys.compactMap { (key) -> XCBuildConfiguration? in
                objects[key] as? XCBuildConfiguration
            }
        }
        return nil
    }
}
