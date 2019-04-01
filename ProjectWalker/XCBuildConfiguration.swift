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
    public var buildSettings: [String: String]?
    public var name: String?

    public override init(items: ProjectFileDictionary) {
        self.baseConfigurationReference = items.string(forKey: "baseConfigurationReference")
        self.buildSettings = items["buildSettings"] as? [String: String]
        self.name = items.string(forKey: "name")

        super.init(items: items)
    }
}
