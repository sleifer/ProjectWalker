//
//  Project.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public enum XcodeProjectError: Error {
    case notOpenStepFormat
    case objectWrite(ProjectObject)
}

public class XcodeProject {
    public var path: URL
    public var archiveVersion: Int
    public var classes: ProjectFileDictionary
    public var objectVersion: Int
    public var rootObject: String
    public private(set) var objects: [String: ProjectObject]
    private var format: PropertyListSerialization.PropertyListFormat

    private var groupReverseLookup: [String: PBXGroup]?
    private var buildPhaseReverseLookup: [String: PBXBuildPhase]?
    private var buildConfigurationListUserReverseLookup: [String: BuildConfigurationListUser]?
    private var dependencyForPackageReverseLookup: [String: XCSwiftPackageProductDependency]?

    public init() {
        self.path = URL(fileURLWithPath: "")
        self.archiveVersion = 0
        self.classes = ProjectFileDictionary()
        self.objectVersion = 0
        self.rootObject = ""
        self.objects = [:]
        self.format = .xml
    }

    public convenience init?(contentsOf url: URL) {
        self.init()
        do {
            self.path = url.appendingPathComponent("project.pbxproj")
            let data = try Data(contentsOf: path)
            let plist: ProjectFileDictionary = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: &format) as? ProjectFileDictionary ?? [:]

            for key in plist.keys.sorted() {
                if key == "archiveVersion" {
                    if let value = plist.int(forKey: "archiveVersion") {
                        self.archiveVersion = value
                    }
                }
                if key == "objectVersion" {
                    if let value = plist.int(forKey: "objectVersion") {
                        self.objectVersion = value
                    }
                }
                if key == "objects" {
                    if let objects = plist.dictionary(forKey: "objects") {
                        for objectKey in objects.keys.sorted() {
                            if let entry = objects.dictionary(forKey: objectKey) {
                                let decoded = ProjectObject.decode(from: entry)
                                switch decoded {
                                case .success(let object):
                                    add(object: object, for: objectKey)
                                case .failure(let error):
                                    switch error {
                                    case .missingIsa(let isa):
                                        print("missing isa: \(isa)")
                                    case .unknownIsa(let isa, let dict):
                                        print("unknown isa: \(isa)")
                                        print(dict)
                                    case .unusedKeys(let object, let dict):
                                        print("unused keys: \(object.unused)")
                                        print(dict)
                                    }
                                }
                            }
                        }
                    }
                }
                if key == "classes" {
                    if let value = plist.dictionary(forKey: "classes") {
                        self.classes = value
                    }
                }
                if key == "rootObject" {
                    if let value = plist.string(forKey: "rootObject") {
                        self.rootObject = value
                    }
                }
            }
        } catch {
            print(error)
            return nil
        }
    }

    public func write(to url: URL) throws {
        if format != .openStep {
            throw XcodeProjectError.notOpenStepFormat
        }

        let fileText: IndentableString = IndentableString()

        fileText.appendLine("// !$*UTF8*$!")
        fileText.appendLine("{")
        fileText.indent()
        fileText.appendLine("archiveVersion = \(archiveVersion);")
        fileText.appendLine("classes = {")
        fileText.indent()
        for oneClass in classes {
            print("WARNING: Not writing class ... \(oneClass)")
        }
        fileText.outdent()
        fileText.appendLine("};")
        fileText.appendLine("objectVersion = \(objectVersion);")
        fileText.appendLine("objects = {")
        fileText.indent()

        let theTypes = allTypes()
        for oneType in theTypes {
            fileText.appendLine("", ignoreIndent: true)
            fileText.appendLine("/* Begin \(oneType) section */", ignoreIndent: true)

            let theObjects = objects(ofType: oneType)
            for oneObject in theObjects {
                try oneObject.write(to: fileText)
            }
            fileText.appendLine("/* End \(oneType) section */", ignoreIndent: true)
        }
        fileText.outdent()
        fileText.appendLine("};")
        if let theRootObject = objects[rootObject] {
            fileText.appendLine("rootObject = \(rootObject) /* \(theRootObject.openStepComment) */;")
        }
        fileText.outdent()
        fileText.appendLine("}")

        try fileText.text.write(to: url, atomically: true, encoding: .utf8)
    }

    public func add(object: ProjectObject, for key: String) {
        objects[key] = object
        object.project = self
        object.referenceKey = key

        groupReverseLookup = nil
        buildPhaseReverseLookup = nil
        buildConfigurationListUserReverseLookup = nil
        dependencyForPackageReverseLookup = nil
    }

    public func project() -> PBXProject? {
        return objects[rootObject] as? PBXProject
    }

    public func object(withKey key: String?) -> ProjectObject? {
        if let key = key {
            return objects[key]
        }
        return nil
    }

    func makeBuildPhaseReverseLookup() {
        let buildPhases = objects.values.compactMap { (object) -> PBXBuildPhase? in
            return object as? PBXBuildPhase
        }
        var lookup: [String: PBXBuildPhase] = [:]
        for buildPhase in buildPhases {
            if let files = buildPhase.files {
                for file in files {
                    lookup[file] = buildPhase
                }
            }
        }
        buildPhaseReverseLookup = lookup
    }

    public func buildPhaseForObject(withKey key: String?) -> PBXBuildPhase? {
        if buildPhaseReverseLookup == nil {
            makeBuildPhaseReverseLookup()
        }
        if let lookup = buildPhaseReverseLookup, let key = key {
            return lookup[key]
        }
        return nil
    }

    func makeGroupReverseLookup() {
        let groups = objects(ofType: "PBXGroup").compactMap { (object) -> PBXGroup? in
            object as? PBXGroup
        }
        var lookup: [String: PBXGroup] = [:]
        for group in groups {
            if let children = group.children {
                for child in children {
                    lookup[child] = group
                }
            }
        }
        groupReverseLookup = lookup
    }

    public func groupForObject(withKey key: String?) -> PBXGroup? {
        if groupReverseLookup == nil {
            makeGroupReverseLookup()
        }
        if let lookup = groupReverseLookup, let key = key {
            return lookup[key]
        }
        return nil
    }

    func makeBuildConfigurationListUserReverseLookup() {
        let configurationUsers = objects.values.compactMap { (object) -> BuildConfigurationListUser? in
            object as? BuildConfigurationListUser
        }
        var lookup: [String: BuildConfigurationListUser] = [:]
        for configurationUser in configurationUsers {
            if let config = configurationUser.buildConfigurationList {
                lookup[config] = configurationUser
            }
        }
        buildConfigurationListUserReverseLookup = lookup
    }

    public func buildConfigurationListUserForObject(withKey key: String?) -> BuildConfigurationListUser? {
        if buildConfigurationListUserReverseLookup == nil {
            makeBuildConfigurationListUserReverseLookup()
        }
        if let lookup = buildConfigurationListUserReverseLookup, let key = key {
            return lookup[key]
        }
        return nil
    }

    func makeDependencyForPackageReverseLookup() {
        let dependencies = objects.values.compactMap { (object) -> XCSwiftPackageProductDependency? in
            object as? XCSwiftPackageProductDependency
        }
        var lookup: [String: XCSwiftPackageProductDependency] = [:]
        for dependency in dependencies {
            if let package = dependency.package {
                lookup[package] = dependency
            }
        }
        dependencyForPackageReverseLookup = lookup
    }

    public func dependencyForPackage(withKey key: String?) -> XCSwiftPackageProductDependency? {
        if dependencyForPackageReverseLookup == nil {
            makeDependencyForPackageReverseLookup()
        }
        if let lookup = dependencyForPackageReverseLookup, let key = key {
            return lookup[key]
        }
        return nil
    }

    public func allTypes() -> [String] {
        let types = objects.values.map { (obj: ProjectObject) -> String in
            obj.isa
        }

        let sorted = Array(Set(types)).sorted()

        return sorted
    }

    public func objects(ofType objectType: String) -> [ProjectObject] {
        let typedObjects = objects.values.filter { (obj: ProjectObject) -> Bool in
            if obj.isa == objectType {
                return true
            }
            return false
        }

        return typedObjects.sorted { (lhs, rhs) -> Bool in
            if lhs.referenceKey < rhs.referenceKey {
                return true
            }
            return false
        }
    }

    public func unhandledTypes() -> [String] {
        let generics = objects.values.filter { (obj: ProjectObject) -> Bool in
            if type(of: obj) == ProjectObject.self {
                return true
            }
            return false
        }

        let types = generics.map { (obj: ProjectObject) -> String in
            obj.isa
        }

        let filtered = Array(Set(types)).sorted()

        return filtered
    }
}
