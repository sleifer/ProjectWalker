//
//  PBXVariantGroup.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class PBXVariantGroup: ProjectObject {
    public var name: String?
    public var children: [Reference]?
    public var sourceTree: String?

    public override var openStepComment: String {
        return name ?? "<unknown>"
    }

    public required init(items: ProjectFileDictionary) {
        self.name = items.string(forKey: "name")
        self.children = items.stringArray(forKey: "children")
        self.sourceTree = items.string(forKey: "sourceTree")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("name")
        keys.remove("children")
        keys.remove("sourceTree")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        if let theName = name {
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
        if let value = name {
            fileText.appendLine("name = \(value.openStepQuoted());")
        }
        if let value = sourceTree {
            fileText.appendLine("sourceTree = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

    public func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = children {
            return files.compactMap({ (key) -> PBXBuildFile? in
                return objects[key] as? PBXBuildFile
            })
        }
        return nil
    }
}
