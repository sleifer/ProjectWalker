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
    public var isa: String?
    public var items: ProjectFileDictionary
    public var project: XcodeProject?
    public var referenceKey: String
    public var unused: [String]

    public var hasUnused: Bool {
        return unused.count > 0 ? true : false
    }

    public init() {
        self.isa = "<unknown>"
        self.items = [:]
        self.referenceKey = "tmpRef:\(UUID().uuidString)"
        self.unused = []
    }

    public required init(items: ProjectFileDictionary) {
        self.isa = items.string(forKey: "isa")
        self.items = items
        self.referenceKey = "tmpRef:\(UUID().uuidString)"
        self.unused = []

        self.unused = unusedKeyCheck(items: items)
    }

    func unusedKeyCheck(items: ProjectFileDictionary) -> [String] {
        var keys = Set(items.keys)
        removeRead(keys: &keys)
        return Array(keys)
    }

    func removeRead(keys: inout Set<String>) {
        keys.remove("isa")
    }

    public enum ProjectObjectDecodeError: Error {
        case missingIsa(ProjectFileDictionary)
        case unknownIsa(String, ProjectFileDictionary)
        case unusedKeys(ProjectObject, ProjectFileDictionary)
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

    public static func decode(from items: ProjectFileDictionary, unknownTypeIsError: Bool = false, unusedKeyIsError: Bool = true) -> Result<ProjectObject, ProjectObjectDecodeError> {
        if projectObjectTypeMap.count == 0 {
            registerProjectObjectTypes()
        }
        if let isa = items["isa"] as? String {
            if let isaClass = projectObjectTypeMap[isa] {
                let object = isaClass.init(items: items)
                if unusedKeyIsError == true && object.hasUnused == true {
                    return .failure(.unusedKeys(object, items))
                } else {
                    return .success(object)
                }
            }
            if unknownTypeIsError == true {
                return .failure(.unknownIsa(isa, items))
            } else {
                let object = ProjectObject(items: items)
                return .success(object)
            }
        }
        return .failure(.missingIsa(items))
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
