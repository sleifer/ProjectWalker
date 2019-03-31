//
//  XCConfigurationList.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

class XCConfigurationList: ProjectObject {
    var buildConfigurations: [Reference]?
    var defaultConfigurationIsVisible: Bool?
    var defaultConfigurationName: String?

    override init(items: ProjectFileDictionary) {
        self.buildConfigurations = items.stringArray(forKey: "buildConfigurations")
        self.defaultConfigurationIsVisible = items.bool(forKey: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = items.string(forKey: "defaultConfigurationName")

        super.init(items: items)

    }
}
