//
//  PBXBuildFile.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class PBXBuildFile: ProjectObject {
    public var fileRef: Reference?
    public var productRef: Reference?
    public var settings: ProjectFileDictionary?
    public var platformFilter: String?

    public override var openStepComment: String {
        if let value = fileRef, let file = project?.object(withKey: value), let buildPhase = project?.buildPhaseForObject(withKey: referenceKey) {
            return "\(file.openStepComment) in \(buildPhase.openStepComment)"
        } else if let value = productRef, let file = project?.object(withKey: value), let buildPhase = project?.buildPhaseForObject(withKey: referenceKey) {
            return "\(file.openStepComment) in \(buildPhase.openStepComment)"
        } else {
            return "<build file>"
        }
    }

    public override init() {
        super.init()
        self.isa = "PBXBuildFile"
    }

    public required init(items: ProjectFileDictionary) {
        self.fileRef = items.string(forKey: "fileRef")
        self.productRef = items.string(forKey: "productRef")
        self.settings = items.dictionary(forKey: "settings")
        self.platformFilter = items.string(forKey: "platformFilter")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("fileRef")
        keys.remove("productRef")
        keys.remove("settings")
        keys.remove("platformFilter")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        if let value = fileRef, let file = project?.object(withKey: value), let buildPhase = project?.buildPhaseForObject(withKey: referenceKey) {
            fileText.append("\(referenceKey) /* \(file.openStepComment) in \(buildPhase.openStepComment) */ = {isa = \(isa); ")
            fileText.append("fileRef = \(file.referenceKey) /* \(file.openStepComment) */; ", ignoreIndent: true)
            if let platformFilter = platformFilter {
                fileText.append("platformFilter = \(platformFilter.openStepQuoted()); ", ignoreIndent: true)
            }
            if let settings = settings {
                let subText = IndentableString()
                try settings.write(to: subText, oneLine: true)
                fileText.append("settings = {\(subText.text)}; ", ignoreIndent: true)
            }
            fileText.appendLine("};", ignoreIndent: true)
        } else if let value = productRef, let file = project?.object(withKey: value), let buildPhase = project?.buildPhaseForObject(withKey: referenceKey) {
            fileText.append("\(referenceKey) /* \(file.openStepComment) in \(buildPhase.openStepComment) */ = {isa = \(isa); ")
            if let platformFilter = platformFilter {
                fileText.append("platformFilter = \(platformFilter.openStepQuoted()); ", ignoreIndent: true)
            }
            fileText.append("productRef = \(file.referenceKey) /* \(file.openStepComment) */; ", ignoreIndent: true)
            if let settings = settings {
                let subText = IndentableString()
                try settings.write(to: subText, oneLine: true)
                fileText.append("settings = {\(subText.text)}; ", ignoreIndent: true)
            }
            fileText.appendLine("};", ignoreIndent: true)
        } else {
            throw XcodeProjectError.objectWrite(self)
        }
    }

    public func getFileRef() -> PBXFileReference? {
        return project?.object(withKey: fileRef) as? PBXFileReference
    }
}
