//
//  PBXBuildFile.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class PBXBuildFile: ProjectObject {
    var fileRef: String
    var settings: [String: String]

    override init(items: ProjectFileDictionary) {
        self.fileRef = items.string(forKey: "fileRef") ?? ""
        self.settings = items["settings"] as? [String: String] ?? [:]

        super.init(items: items)
    }
}
