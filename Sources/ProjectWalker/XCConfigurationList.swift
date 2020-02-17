//
//  XCConfigurationList.swift
//  projwalker
//
//  Created by Simeon Leifer on 3/31/19.
//  Copyright © 2019 droolingcat.com. All rights reserved.
//

import Foundation

public class XCConfigurationList: ProjectObject {
    public var buildConfigurations: [Reference]?
    public var defaultConfigurationIsVisible: Bool?
    public var defaultConfigurationName: String?

    public required init(items: ProjectFileDictionary) {
        self.buildConfigurations = items.stringArray(forKey: "buildConfigurations")
        self.defaultConfigurationIsVisible = items.bool(forKey: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = items.string(forKey: "defaultConfigurationName")

        super.init(items: items)

    }

    public func getBuildConfigurations() -> [XCBuildConfiguration]? {
        if let objects = project?.objects, let keys = buildConfigurations {
            return keys.compactMap({ (key) -> XCBuildConfiguration? in
                return objects[key] as? XCBuildConfiguration
            })
        }
        return nil
    }
}
