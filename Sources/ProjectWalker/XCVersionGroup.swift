//
//  XCVersionGroup.swift
//  
//
//  Created by Simeon Leifer on 2/23/20.
//

import Foundation

public class XCVersionGroup: ProjectObject {
    public var children: [Reference]?
    public var currentVersion: Reference?
    public var path: String?
    public var sourceTree: String?
    public var versionGroupType: String?

    public override var openStepComment: String {
        return path ?? "XCVersionGroup"
    }

    public override init() {
        super.init()
        self.isa = "XCVersionGroup"
    }

    public required init(items: ProjectFileDictionary) {
        self.children = items.stringArray(forKey: "children")
        self.currentVersion = items.string(forKey: "currentVersion")
        self.path = items.string(forKey: "path")
        self.sourceTree = items.string(forKey: "sourceTree")
        self.versionGroupType = items.string(forKey: "versionGroupType")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("children")
        keys.remove("currentVersion")
        keys.remove("path")
        keys.remove("sourceTree")
        keys.remove("versionGroupType")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        if let theName = path {
            fileText.appendLine("\(referenceKey) /* \(theName) */ = {")
        } else {
            fileText.appendLine("\(referenceKey) = {")
        }
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = children {
            fileText.appendLine("children = (")
            fileText.indent()
            for oneFile in value {
                if let file = project?.object(withKey: oneFile) {
                    fileText.appendLine("\(oneFile) /* \(file.openStepComment) */,")
                }
            }
            fileText.outdent()
            fileText.appendLine(");")
        }
        if let value = currentVersion {
            if let file = project?.object(withKey: value) {
                fileText.appendLine("currentVersion = \(value.openStepQuoted()) /* \(file.openStepComment) */;")
            } else {
                fileText.appendLine("currentVersion = \(value.openStepQuoted());")
            }
        }
        if let value = path {
            fileText.appendLine("path = \(value.openStepQuoted());")
        }
        if let value = sourceTree {
            fileText.appendLine("sourceTree = \(value.openStepQuoted());")
        }
        if let value = versionGroupType {
            fileText.appendLine("versionGroupType = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getChildren() -> [PBXFileElement]? {
        if let objects = project?.objects, let children = children {
            return children.compactMap({ (key) -> PBXFileElement? in
                return objects[key] as? PBXFileElement
            })
        }
        return nil
    }
}
