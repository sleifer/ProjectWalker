//
//  ProcessRunner.swift
//  project-tool
//
//  Created by Simeon Leifer on 10/10/17.
//  Copyright © 2017 droolingcat.com. All rights reserved.
//

import Foundation

public typealias ProcessRunnerCompletionHandler = (_ runner: ProcessRunner) -> Void
public typealias ProcessRunnerOutputHandler = (_ runner: ProcessRunner, _ stdOutLine: String?, _ stdErrLine: String?) -> Void

open class ProcessRunner {
    public let command: String
    public let arguments: [String]
    var process: Process?
    public var status: Int32 = -999
    public var stdOut: String = ""
    public var stdErr: String = ""
    public var echo: Bool = false
    public var echoRepeatLines: Bool = true
    public var commandString: String {
        return "\(command) \(arguments.joined(separator: " "))"
    }
    public var outputHandler: ProcessRunnerOutputHandler?

    internal init(_ cmd: String, args: [String]) {
        command = cmd
        arguments = args
    }

    @discardableResult
    public func printErrors() -> ProcessRunner {
        if status != 0 && stdErr.trimmed().count > 0 {
            print(ANSIColor.red + "Error output running process" + ANSIColor.reset)
            if echo == false {
                let msg = ">> \(command) \(arguments.joined(separator: " ")) <<"
                print(ANSIColor.blue + msg + ANSIColor.reset)
            }
            print(stdErr)
            print(ANSIColor.red + "^---^" + ANSIColor.reset)
        }
        return self
    }

    public func getOutput(_ trimmed: Bool = false) -> String? {
        if status == 0 {
            if trimmed == true {
                return stdOut.trimmed()
            }
            return stdOut
        }
        return nil
    }

    // swiftlint:disable cyclomatic_complexity

    internal func start(_ completion: ProcessRunnerCompletionHandler? = nil) {
        let proc = Process()
        process = proc
        proc.launchPath = command
        proc.arguments = arguments
        let outPipe = Pipe()
        proc.standardOutput = outPipe
        let errPipe = Pipe()
        proc.standardError = errPipe
        var lastLine: String = "-<<<-><->>>-"

        if echo == true {
            outPipe.fileHandleForReading.readabilityHandler = { [weak self] (handle) in
                let outData = handle.availableData
                if let str = String(data: outData, encoding: .utf8) {
                    if str.trimmed().count > 0 {
                        if self?.echoRepeatLines == true || lastLine != str {
                            print(str, terminator: "")
                        }
                        if let self = self, let outputHandler = self.outputHandler {
                            outputHandler(self, str, nil)
                        }
                        lastLine = str
                    }
                    self?.stdOut.append(str)
                }
            }

            errPipe.fileHandleForReading.readabilityHandler = { [weak self] (handle) in
                let outData = handle.availableData
                if let str = String(data: outData, encoding: .utf8) {
                    if str.trimmed().count > 0 {
                        if self?.echoRepeatLines == true || lastLine != str {
                            print(str, terminator: "")
                        }
                        if let self = self, let outputHandler = self.outputHandler {
                            outputHandler(self, nil, str)
                        }
                        lastLine = str
                    }
                    self?.stdErr.append(str)
                }
            }
        } else if outputHandler != nil {
            outPipe.fileHandleForReading.readabilityHandler = { [weak self] (handle) in
                let outData = handle.availableData
                if let str = String(data: outData, encoding: .utf8) {
                    if str.trimmed().count > 0 {
                        if let self = self, let outputHandler = self.outputHandler {
                            outputHandler(self, str, nil)
                        }
                    }
                    self?.stdOut.append(str)
                }
            }

            errPipe.fileHandleForReading.readabilityHandler = { [weak self] (handle) in
                let outData = handle.availableData
                if let str = String(data: outData, encoding: .utf8) {
                    if str.trimmed().count > 0 {
                        if let self = self, let outputHandler = self.outputHandler {
                            outputHandler(self, nil, str)
                        }
                    }
                    self?.stdErr.append(str)
                }
            }
        }

        proc.terminationHandler = { (process: Process) -> Void in
            self.status = process.terminationStatus

            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            if let str = String(data: outData, encoding: .utf8) {
                if self.echo == true {
                    if str.trimmed().count > 0 {
                        if self.echoRepeatLines == true || lastLine != str {
                            print(str)
                        }
                        lastLine = str
                    }
                }
                self.stdOut.append(str)
            }

            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
            if let str = String(data: errData, encoding: .utf8) {
                if self.echo == true {
                    if str.trimmed().count > 0 {
                        if self.echoRepeatLines == true || lastLine != str {
                            print(str)
                        }
                        lastLine = str
                    }
                }
                self.stdErr.append(str)
            }

            DispatchQueue.main.async {
                if let completion = completion {
                    completion(self)
                }
                CommandLineRunLoop.shared.endBackgroundTask()
                self.process = nil
            }
        }

        CommandLineRunLoop.shared.startBackgroundTask()
        proc.launch()
    }

    // swiftlint:enable cyclomatic_complexity

    static let whichCmd = "/usr/bin/which"
    static var whichLookup: [String: String] = [:]

    class func which(_ cmd: String) -> String {
        if let lookup = whichLookup[cmd] {
            return lookup
        }
        let proc = ProcessRunner.runCommand(whichCmd, args: [cmd])
        if proc.status == 0 {
            let foundCmd = proc.stdOut.trimmingCharacters(in: .whitespacesAndNewlines)
            whichLookup[cmd] = foundCmd
            return foundCmd
        }
        whichLookup[cmd] = cmd
        return cmd
    }

    @discardableResult
    public class func runCommand(_ fullCmd: String, echoCommand: Bool = false, echoOutput: Bool = false, echoRepeatOutput: Bool = true, dryrun: Bool = false, outputHandler: ProcessRunnerOutputHandler? = nil, completion: ProcessRunnerCompletionHandler? = nil) -> ProcessRunner {
        let args = fullCmd.quoteSafeWords()
        let cmd = args[0]
        var sargs = args
        sargs.remove(at: 0)
        return runCommand(cmd, args: sargs, echoCommand: echoCommand, echoOutput: echoOutput, echoRepeatOutput: echoRepeatOutput, dryrun: dryrun, outputHandler: outputHandler, completion: completion)
    }

    @discardableResult
    public class func runCommand(_ args: [String], echoCommand: Bool = false, echoOutput: Bool = false, echoRepeatOutput: Bool = true, dryrun: Bool = false, outputHandler: ProcessRunnerOutputHandler? = nil, completion: ProcessRunnerCompletionHandler? = nil) -> ProcessRunner {
        let cmd = args[0]
        var sargs = args
        sargs.remove(at: 0)
        return runCommand(cmd, args: sargs, echoCommand: echoCommand, echoOutput: echoOutput, echoRepeatOutput: echoRepeatOutput, dryrun: dryrun, outputHandler: outputHandler, completion: completion)
    }

    @discardableResult
    public class func runCommand(_ cmd: String, args: [String], echoCommand: Bool = false, echoOutput: Bool = false, echoRepeatOutput: Bool = true, dryrun: Bool = false, outputHandler: ProcessRunnerOutputHandler? = nil, completion: ProcessRunnerCompletionHandler? = nil) -> ProcessRunner {
        let fullCmd: String
        if cmd == whichCmd {
            fullCmd = cmd
        } else {
            fullCmd = which(cmd)
        }
        let runner = ProcessRunner(fullCmd, args: args)
        if cmd != whichCmd {
            runner.echo = echoOutput
            runner.echoRepeatLines = echoRepeatOutput
            runner.outputHandler = outputHandler
            if echoCommand == true || dryrun == true {
                let msg = ">> \(cmd) \(args.joined(separator: " ")) <<"
                print(ANSIColor.blue + msg + ANSIColor.reset)
            }
        }

        if dryrun == true {
            runner.status = 0
            if let completion = completion {
                completion(runner)
            }
            return runner
        }

        var done: Bool = false
        runner.start { (runner) in
            if let completion = completion {
                completion(runner)
            }
            done = true
        }
        if completion == nil {
            while done == false {
                CommandLineRunLoop.shared.spinRunLoop()
            }
            return runner
        }
        return runner
    }
}
