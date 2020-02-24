//
//  Tests.swift
//  ProjectWalkerTestApp
//
//  Created by Simeon Leifer on 2/16/20.
//  Copyright © 2020 droolingcat.com. All rights reserved.
//

import Foundation
import ProjectWalker

class Tests: ObservableObject {
    @Published var project: XcodeProject?
    @Published var readWriteResult: String = ""

    let readPath = "/Users/simeon/Desktop/test/test.xcodeproj"
    let writePath = "/Users/simeon/Desktop/test.pbxproj"
    let batchTestPath = "/Users/simeon/Documents/Code"

    func readTest() {
        project = XcodeProject(contentsOf: URL(fileURLWithPath: readPath))
        if let project = project {
            let filtered = project.unhandledTypes()

            if filtered.count != 0 {
                print("Unhandled Object Types: \(filtered.count)")
                for item in filtered {
                    print(" \(item)")
                }
            }
        }
    }

    func writeTest() {
        if project == nil {
            readTest()
        }
        if let project = project {
            do {
                try project.write(to: URL(fileURLWithPath: writePath))
            } catch {
                print(error)
            }
        }
    }

    func infoOnUnhandled() {
        if let project = project {
            let types = project.unhandledTypes()

            for oneType in types {
                let objects = project.objects.values.filter { (obj) -> Bool in
                    if obj.isa == oneType {
                        return true
                    }
                    return false
                }

                print("\(oneType): \(objects.count)")
                if let first = objects.first {
                    print("referenceKey: \(first.referenceKey)")
                    print("items:")
                    dump(first.items)
                }
                print("- - -")
            }

            if types.count == 0 {
                print("No unhandled types.")
            }
        }
    }

    func readWriteTest(_ path: String) {
        readWriteResult = "Testing: \(path)"

        if let xproj = XcodeProject(contentsOf: URL(fileURLWithPath: path), unknownTypeIsError: true, unusedKeyIsError: true) {
            if xproj.hadDecodeErrors == true {
                readWriteResult = "Error: had unknown types or missing keys"
            } else {
                do {
                    let original = try String(contentsOf: xproj.path)
                    let rewritten = try xproj.writeToString()
                    if original != rewritten {
                        readWriteResult = "Error: rewritten does not match original"
                        try rewritten.write(toFile: writePath, atomically: true, encoding: .utf8)
                        ProcessRunner.runCommand("open \"\(xproj.path.path)\" -a BBEdit")
                        ProcessRunner.runCommand("open \"\(writePath)\" -a BBEdit")
                    } else {
                        readWriteResult = "Pass"
                    }
                } catch {
                    readWriteResult = "Error comparing rewritten: \(error)"
                }
            }
        } else {
            readWriteResult = "Error: failed to read"
        }
    }

    func batchTest() {
        var projectCount: Int = 0
        let repos = collectRepositoryPaths(from: URL(fileURLWithPath: batchTestPath))
        for repo in repos {
            let projects = xcodeProjects(from: repo)
            for project in projects {
                projectCount += 1
                let logPrefix = "\nTesting: \(project.path)\n"

                if let xproj = XcodeProject(contentsOf: project, unknownTypeIsError: true, unusedKeyIsError: true) {
                    if xproj.hadDecodeErrors == true {
                        print("\(logPrefix)Error: had unknown types or missing keys")
                    } else {
                        do {
                            let original = try String(contentsOf: xproj.path)
                            let rewritten = try xproj.writeToString()
                            if original != rewritten {
                                print("\(logPrefix)Error: rewritten does not match original")
                            } else {
//                                print("Pass")
                            }
                        } catch {
                            print("\(logPrefix)Error comparing rewritten: \(error)")
                        }
                    }
                } else {
                    print("\(logPrefix)Error: failed to read")
                }
            }
        }
        print()
        print("Done testing \(projectCount) projects.")
    }

    @discardableResult
    func collectRepositoryPaths(from rootDirectory: URL, _ handler: ((URL) -> Void)? = nil) -> [URL] {
        var directories: [URL] = []

        let searchDirs: [URL]
        searchDirs = [rootDirectory]

        for searchDirPath in searchDirs {
            let fm = FileManager.default
            let enumerator = fm.enumerator(at: searchDirPath, includingPropertiesForKeys: nil)
            while let file = enumerator?.nextObject() as? URL {
                if file.lastPathComponent == ".git" {
                    let dir = file.deletingLastPathComponent()
                    if let handler = handler {
                        handler(dir)
                    }
                    directories.append(dir)
                }
            }
        }
        return directories
    }

    func xcodeProjects(from directory: URL) -> [URL] {
        do {
            let fileManager = FileManager.default
            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            let projects = files.filter { (file) -> Bool in
                if file.lastPathComponent.hasSuffix(".xcodeproj") {
                    if fileManager.fileExists(atPath: file.appendingPathComponent("project.pbxproj").path) == true {
                        return true
                    }
                }
                return false
            }
            return projects
        } catch {}
        return []
    }
}
