//
//  ProjectObject.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public typealias Reference = String

public class ProjectObject: Hashable {
    public var items: ProjectFileDictionary
    public var project: XcodeProject?
    public var referenceKey: String

    public init() {
        self.items = [:]
        self.referenceKey = "tmpRef:\(UUID().uuidString)"
    }

    public required init(items: ProjectFileDictionary) {
        self.items = items
        self.referenceKey = "tmpRef:\(UUID().uuidString)"
    }

    static var projectObjectTypeMap: [String: ProjectObject.Type] = [:]

    static func addProjectObjectType<T: ProjectObject>(_ typeClass: T.Type, withKey isaKey: String) {
        projectObjectTypeMap[isaKey] = typeClass
    }

    static func registerProjectObjectTypes() {
        addProjectObjectType(PBXBuildFile.self, withKey: "PBXBuildFile")
        addProjectObjectType(PBXContainerItemProxy.self, withKey: "PBXContainerItemProxy")
        addProjectObjectType(PBXCopyFilesBuildPhase.self, withKey: "PBXCopyFilesBuildPhase")
        addProjectObjectType(PBXFileReference.self, withKey: "PBXFileReference")
        addProjectObjectType(PBXFrameworksBuildPhase.self, withKey: "PBXFrameworksBuildPhase")
        addProjectObjectType(PBXGroup.self, withKey: "PBXGroup")
        addProjectObjectType(PBXNativeTarget.self, withKey: "PBXNativeTarget")
        addProjectObjectType(PBXProject.self, withKey: "PBXProject")
        addProjectObjectType(PBXResourcesBuildPhase.self, withKey: "PBXResourcesBuildPhase")
        addProjectObjectType(PBXShellScriptBuildPhase.self, withKey: "PBXShellScriptBuildPhase")
        addProjectObjectType(PBXSourcesBuildPhase.self, withKey: "PBXSourcesBuildPhase")
        addProjectObjectType(PBXTargetDependency.self, withKey: "PBXTargetDependency")
        addProjectObjectType(PBXVariantGroup.self, withKey: "PBXVariantGroup")
        addProjectObjectType(XCBuildConfiguration.self, withKey: "XCBuildConfiguration")
        addProjectObjectType(XCConfigurationList.self, withKey: "XCConfigurationList")
        addProjectObjectType(XCRemoteSwiftPackageReference.self, withKey: "XCRemoteSwiftPackageReference")
        addProjectObjectType(XCSwiftPackageProductDependency.self, withKey: "XCSwiftPackageProductDependency")
    }

    public static func decode(from items: ProjectFileDictionary) -> ProjectObject? {
        if projectObjectTypeMap.count == 0 {
            registerProjectObjectTypes()
        }
        if let isa = items["isa"] as? String {
            if let isaClass = projectObjectTypeMap[isa] {
                return isaClass.init(items: items)
            }
            return ProjectObject(items: items)
        }
        return nil
    }

    public func debugDumpItems() {
        print(">>> ProjectObject")
        dump(items)
        print("<<<")
    }

    public static func == (lhs: ProjectObject, rhs: ProjectObject) -> Bool {
        if lhs.referenceKey == rhs.referenceKey {
            return true
        }
        return false
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(referenceKey)
    }
}
