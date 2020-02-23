//
//  PBXReferenceProxy.swift
//  
//
//  Created by Simeon Leifer on 2/23/20.
//

import Foundation

public class PBXReferenceProxy: ProjectObject {
    public var fileType: String?
    public var path: String?
    public var remoteRef: Reference?
    public var sourceTree: String?

    public override var openStepComment: String {
        return path ?? "PBXReferenceProxy"
    }

    public override init() {
        super.init()
        self.isa = "PBXReferenceProxy"
    }

    public required init(items: ProjectFileDictionary) {
        self.fileType = items.string(forKey: "fileType")
        self.path = items.string(forKey: "path")
        self.remoteRef = items.string(forKey: "remoteRef")
        self.sourceTree = items.string(forKey: "sourceTree")

        super.init(items: items)
    }

    override func removeRead(keys: inout Set<String>) {
        keys.remove("fileType")
        keys.remove("path")
        keys.remove("remoteRef")
        keys.remove("sourceTree")

        super.removeRead(keys: &keys)
    }

    override func write(to fileText: IndentableString) throws {
        fileText.appendLine("\(referenceKey) /* \(self.openStepComment) */ = {")
        fileText.indent()
        fileText.appendLine("isa = \(isa);")
        if let value = fileType {
            fileText.appendLine("fileType = \(value.openStepQuoted());")
        }
        if let value = path {
            fileText.appendLine("path = \(value.openStepQuoted());")
        }
        if let value = remoteRef {
            if let object = project?.object(withKey: value) {
                fileText.appendLine("remoteRef = \(value.openStepQuoted()) /* \(object.openStepComment) */;")
            } else {
                fileText.appendLine("remoteRef = \(value.openStepQuoted());")
            }
        }
        if let value = sourceTree {
            fileText.appendLine("sourceTree = \(value.openStepQuoted());")
        }
        fileText.outdent()
        fileText.appendLine("};")
    }

}



/*
 DB3CF04222C3E50F0000723B /* RemoteLogging.framework */ = {
     isa = PBXReferenceProxy;
     fileType = wrapper.framework;
     path = RemoteLogging.framework;
     remoteRef = DB3CF04122C3E50F0000723B /* PBXContainerItemProxy */;
     sourceTree = BUILT_PRODUCTS_DIR;
 };

 */
