//
//  XCSwiftPackageProductDependency.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class XCSwiftPackageProductDependency: ProjectObject {
    public var package: Reference?
    public var productName: String?

    public override var openStepComment: String {
        return productName ?? "XCSwiftPackageProductDependency"
    }

    public required init(items: ProjectFileDictionary) {
        self.package = items.string(forKey: "package")
        self.productName = items.string(forKey: "productName")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("package")
        keys.remove("productName")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = package {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("package = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("package = \(value.openStepQuoted());")
            }
        }
        if let value = productName {
            fileText.appendLine("productName = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }
}
