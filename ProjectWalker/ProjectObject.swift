//
//  ProjectObject.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public typealias Reference = String

public class ProjectObject {
    public var items: ProjectFileDictionary
    public var project: XcodeProject?

    public init() {
        items = [:]
    }

    public init(items: ProjectFileDictionary) {
        self.items = items
    }

    // swiftlint:disable cyclomatic_complexity

    public static func decode(from items: ProjectFileDictionary) -> ProjectObject? {
        if let isa = items["isa"] as? String {
            switch isa {
            case "PBXFileReference":
                return PBXFileReference(items: items)
            case "PBXGroup":
                return PBXGroup(items: items)
            case "PBXBuildFile":
                return PBXBuildFile(items: items)
            case "PBXProject":
                return PBXProject(items: items)
            case "PBXTargetDependency":
                return PBXTargetDependency(items: items)
            case "XCBuildConfiguration":
                return XCBuildConfiguration(items: items)
            case "XCConfigurationList":
                return XCConfigurationList(items: items)
            case "PBXFrameworksBuildPhase":
                return PBXFrameworksBuildPhase(items: items)
            case "PBXShellScriptBuildPhase":
                return PBXShellScriptBuildPhase(items: items)
            case "PBXCopyFilesBuildPhase":
                return PBXCopyFilesBuildPhase(items: items)
            case "PBXSourcesBuildPhase":
                return PBXSourcesBuildPhase(items: items)
            case "PBXNativeTarget":
                return PBXNativeTarget(items: items)
            case "PBXContainerItemProxy":
                return PBXContainerItemProxy(items: items)
            default:
                return ProjectObject(items: items)
            }
        }
        return nil
    }

    // swiftlint:enable cyclomatic_complexity

    public func debugDumpItems() {
        print(">>> ProjectObject")
        dump(items)
        print("<<<")
    }
}
