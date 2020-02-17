//
//  XCRemoteSwiftPackageReference.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class XCRemoteSwiftPackageReference: ProjectObject {
    public var repositoryURL: String?
    public var requirements: ProjectFileDictionary?

    public required init(items: ProjectFileDictionary) {
        self.repositoryURL = items.string(forKey: "repositoryURL")
        self.requirements = items.dictionary(forKey: "requirements")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("repositoryURL")
        keys.remove("requirements")

        super.removeRead(keys: &keys)
    }
}
