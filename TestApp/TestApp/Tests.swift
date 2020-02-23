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

    func configurationsTest() {
        if let project = project {
            if let proj = project.project() {
                print(proj)
                if let targets = proj.getTargets() {
                    for target in targets {
                        print(target)
                        if let configList = target.getBuildConfigurationList() {
                            print(configList)
                            print("default: \(configList.defaultConfigurationName ?? "<none>")")
                            if let configurations = configList.getBuildConfigurations() {
                                for configuration in configurations {
                                    print(configuration)
                                    if let settings = configuration.buildSettings {
                                        for (key, value) in settings {
                                            print("\(key) = \(value) .. \(type(of: value))")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
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

    func batchTest() {
        let repos = collectRepositoryPaths(from: URL(fileURLWithPath: batchTestPath))
        for repo in repos {
            let projects = xcodeProjects(from: repo)
            for project in projects {
                print()
                print("Testing: \(project.path)")

                if let xproj = XcodeProject(contentsOf: project, unknownTypeIsError: true, unusedKeyIsError: true) {
                    if xproj.hadDecodeErrors == true {
                        print("Error: had unknown types or missing keys")
                    } else {
                        do {
                            let original = try String(contentsOf: xproj.path)
                            let rewritten = try xproj.writeToString()
                            if original != rewritten {
                                print("Error: rewritten does not match original")
                            } else {
                                print("Pass")
                            }
                        } catch {
                            print("Error comparing rewritten: \(error)")
                        }
                    }
                } else {
                    print("Error: failed to read")
                }
            }
        }
        print()
        print("Done.")
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
