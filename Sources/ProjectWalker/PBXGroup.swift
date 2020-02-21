//
//  PBXGroup.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXGroup: PBXFileElement {
    public var children: [Reference]?
    public var name: String?
    public var sourceTree: String?
    public var path: String?
    public var usesTabs: Bool?
    public var indentWidth: Int?
    public var tabWidth: Int?

    public override var openStepComment: String {
        return name ?? path ?? "<group>"
    }

    public override init() {
        super.init()
        self.isa = "PBXGroup"
    }

    public required init(items: ProjectFileDictionary) {
        self.name = items.string(forKey: "name")
        self.sourceTree = items.string(forKey: "sourceTree")
        self.path = items.string(forKey: "path")
        self.children = items.stringArray(forKey: "children")
        self.usesTabs = items.bool(forKey: "usesTabs")
        self.indentWidth = items.int(forKey: "indentWidth")
        self.tabWidth = items.int(forKey: "tabWidth")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("name")
        keys.remove("sourceTree")
        keys.remove("path")
        keys.remove("children")
        keys.remove("usesTabs")
        keys.remove("indentWidth")
        keys.remove("tabWidth")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        if let theName = name ?? path {
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
        if let value = indentWidth {
            fileText.appendLine("indentWidth = \(value);")
        }
        if let value = name {
            fileText.appendLine("name = \(value.openStepQuoted());")
        }
        if let value = path {
            fileText.appendLine("path = \(value.openStepQuoted());")
        }
        if let value = sourceTree {
            fileText.appendLine("sourceTree = \(value.openStepQuoted());")
        }
        if let value = tabWidth {
            fileText.appendLine("tabWidth = \(value);")
        }
        if let value = usesTabs {
            fileText.appendLine("usesTabs = \(value ? 1 : 0);")
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
