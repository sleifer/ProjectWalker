//
//  PBXVariantGroup.swift
//  
//
//  Created by Simeon Leifer on 2/16/20.
//

import Foundation

public class PBXResourcesBuildPhase: ProjectObject {
    public var buildActionMask: Int?
    public var files: [Reference]?
    public var runOnlyForDeploymentPostprocessing: Bool?

    public override init(items: ProjectFileDictionary) {
        self.buildActionMask = items.int(forKey: "buildActionMask")
        self.files = items.stringArray(forKey: "files")
        self.runOnlyForDeploymentPostprocessing = items.bool(forKey: "runOnlyForDeploymentPostprocessing")

        super.init(items: items)
    }

    public func getFiles() -> [PBXBuildFile]? {
        if let objects = project?.objects, let files = files {
            return files.compactMap({ (key) -> PBXBuildFile? in
                return objects[key] as? PBXBuildFile
            })
        }
        return nil
    }
}
