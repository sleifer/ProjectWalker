//
//  XCBuildConfiguration.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class XCBuildConfiguration: ProjectObject {
    public var baseConfigurationReference: String?
    public var buildSettings: ProjectFileDictionary?
    public var name: String?

    public override var openStepComment: String {
        return name ?? "<build configuration>"
    }

    public override init() {
        super.init()
        self.isa = "XCBuildConfiguration"
    }

    public required init(items: ProjectFileDictionary) {
        self.baseConfigurationReference = items.string(forKey: "baseConfigurationReference")
        self.buildSettings = items.dictionary(forKey: "buildSettings")
        self.name = items.string(forKey: "name")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("baseConfigurationReference")
        keys.remove("buildSettings")
        keys.remove("name")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = baseConfigurationReference {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("baseConfigurationReference = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("baseConfigurationReference = \(value.openStepQuoted());")
            }
        }
        if let value = buildSettings {
            fileText.appendLine("buildSettings = {")
            fileText.indent()
            try value.write(to: fileText)
            fileText.outdent()
            fileText.appendLine("};")
        }
        if let value = name {
            fileText.appendLine("name = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }
}
