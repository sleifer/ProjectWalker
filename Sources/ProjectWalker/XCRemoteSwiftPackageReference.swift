//
//  XCRemoteSwiftPackageReference.swift
//
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class XCRemoteSwiftPackageReference: ProjectObject {
    public var repositoryURL: String?
    public var requirement: ProjectFileDictionary?

    public override var openStepComment: String {
        if let dependency = project?.dependencyForPackage(withKey: referenceKey) {
            return "XCRemoteSwiftPackageReference \"\(dependency.openStepComment)\""
        } else {
            return "XCRemoteSwiftPackageReference"
        }
    }

    public override init() {
        super.init()
        self.isa = "XCRemoteSwiftPackageReference"
    }

    public required init(items: ProjectFileDictionary) {
        self.repositoryURL = items.string(forKey: "repositoryURL")
        self.requirement = items.dictionary(forKey: "requirement")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("repositoryURL")
        keys.remove("requirement")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = repositoryURL {
            fileText.appendLine("repositoryURL = \(value.openStepQuoted());")
        }
        if let value = requirement {
            fileText.appendLine("requirement = {")
            fileText.indent()
            try value.write(to: fileText)
            fileText.outdent()
            fileText.appendLine("};")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }
}
