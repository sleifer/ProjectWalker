import Foundation

class PBXFileReference: PBXFileElement {
    var fileEncoding: Int?
    var explicitFileType: String?
    var lastKnownFileType: String?
    var name: String?
    var path: String?
    var sourceTree: String?

    override init(items: ProjectFileDictionary) {
        self.fileEncoding = items.int(forKey: "fileEncoding")
        self.explicitFileType = items.string(forKey: "explicitFileType")
        self.lastKnownFileType = items.string(forKey: "lastKnownFileType")
        self.name = items.string(forKey: "name")
        self.path = items.string(forKey: "path")
        self.sourceTree = items.string(forKey: "sourceTree")

        super.init(items: items)
    }
}
