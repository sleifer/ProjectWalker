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
}
