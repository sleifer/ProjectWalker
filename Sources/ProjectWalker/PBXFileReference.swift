//
//  PBXFileReference.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXFileReference: PBXFileElement {
    public var fileEncoding: Int?
    public var explicitFileType: String?
    public var lastKnownFileType: String?
    public var name: String?
    public var path: String?
    public var plistStructureDefinitionIdentifier: String?
    public var sourceTree: String?
    public var includeInIndex: Bool?
    public var xcLanguageSpecificationIdentifier: String?
    public var lineEnding: Int?

    public override var openStepComment: String {
        return name ?? path ?? "<unknown>"
    }

    public override init() {
        super.init()
        self.isa = "PBXFileReference"
    }

    public required init(items: ProjectFileDictionary) {
        self.fileEncoding = items.int(forKey: "fileEncoding")
        self.explicitFileType = items.string(forKey: "explicitFileType")
        self.lastKnownFileType = items.string(forKey: "lastKnownFileType")
        self.name = items.string(forKey: "name")
        self.path = items.string(forKey: "path")
        self.plistStructureDefinitionIdentifier = items.string(forKey: "plistStructureDefinitionIdentifier")
        self.sourceTree = items.string(forKey: "sourceTree")
        self.includeInIndex = items.bool(forKey: "includeInIndex")
        self.xcLanguageSpecificationIdentifier = items.string(forKey: "xcLanguageSpecificationIdentifier")
        self.lineEnding = items.int(forKey: "lineEnding")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("fileEncoding")
        keys.remove("explicitFileType")
        keys.remove("lastKnownFileType")
        keys.remove("name")
        keys.remove("path")
        keys.remove("plistStructureDefinitionIdentifier")
        keys.remove("sourceTree")
        keys.remove("includeInIndex")
        keys.remove("xcLanguageSpecificationIdentifier")
        keys.remove("lineEnding")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        var propertyString: String = "isa = \(isa.openStepQuoted()); "
        if let value = explicitFileType {
            propertyString += "explicitFileType = \(value.openStepQuoted()); "
        }
        if let value = fileEncoding {
            propertyString += "fileEncoding = \(value); "
        }
        if let value = includeInIndex {
            propertyString += "includeInIndex = \(value ? 1 : 0); "
        }
        if let value = lastKnownFileType {
            propertyString += "lastKnownFileType = \(value.openStepQuoted()); "
        }
        if let value = lineEnding {
            propertyString += "lineEnding = \(value); "
        }
        if let value = name {
            propertyString += "name = \(value.openStepQuoted()); "
        }
        if let value = path {
            propertyString += "path = \(value.openStepQuoted()); "
        }
        if let value = plistStructureDefinitionIdentifier {
            propertyString += "plistStructureDefinitionIdentifier = \(value.openStepQuoted()); "
        }
        if let value = sourceTree {
            propertyString += "sourceTree = \(value.openStepQuoted()); "
        }
        if let value = xcLanguageSpecificationIdentifier {
            propertyString += "xcLanguageSpecificationIdentifier = \(value.openStepQuoted()); "
        }
        fileText.appendLine("\(referenceKey) /* \(openStepComment) */ = {\(propertyString)};")
    }
}
