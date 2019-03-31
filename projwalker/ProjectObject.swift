import Foundation

class ProjectObject {
    var items: ProjectFileDictionary

    init() {
        items = [:]
    }

    init(items: ProjectFileDictionary) {
        self.items = items
    }

    static func decode(from items: ProjectFileDictionary) -> ProjectObject? {
        if let isa = items["isa"] as? String {
            switch isa {
            case "PBXFileReference":
                return PBXFileReference(items: items)
            case "PBXGroup":
                return PBXGroup(items: items)
            case "PBXBuildFile":
                return PBXBuildFile(items: items)
            case "PBXProject":
                return PBXProject(items: items)
            case "PBXNativeTarget":
                return PBXNativeTarget(items: items)
            case "XCBuildConfiguration":
                return XCBuildConfiguration(items: items)
            case "XCConfigurationList":
                return XCConfigurationList(items: items)
            case "PBXFrameworksBuildPhase":
                return PBXFrameworksBuildPhase(items: items)
            case "PBXShellScriptBuildPhase":
                return PBXShellScriptBuildPhase(items: items)
            case "PBXCopyFilesBuildPhase":
                return PBXCopyFilesBuildPhase(items: items)
            case "PBXSourcesBuildPhase":
                return PBXSourcesBuildPhase(items: items)
            default:
                return ProjectObject(items: items)
            }
        }
        return nil
    }

    func debugDumpItems() {
        print(">>> ProjectObject")
        dump(items)
        print("<<<")
    }
}
