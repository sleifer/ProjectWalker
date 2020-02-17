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
}
