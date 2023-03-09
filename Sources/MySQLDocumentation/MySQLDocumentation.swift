import Foundation
import Logging
import SQLiteNIO

public class MySQLDocumentationFunction: CustomDebugStringConvertible {
  public internal(set) var name = ""
  public internal(set) var help = ""
  public internal(set) var example = ""

  init() {}

  public var debugDescription: String {
    "<\(Self.self) \(name) -- \(help) (\(example))>"
  }
}

public struct MySQLDocumentation {
  var threadPool: NIOThreadPool!
  var eventLoopGroup: EventLoopGroup!
  var eventLoop: EventLoop { eventLoopGroup.any() }

  var functions = [MySQLDocumentationFunction]()

  public init() {
    threadPool = NIOThreadPool(numberOfThreads: 1)
    threadPool.start()
    eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    do {
      let conn = try SQLiteConnection.open(storage: .memory, threadPool: threadPool, on: eventLoop).wait()
      defer { try! conn.close().wait() }

      (try String(contentsOfFile: Bundle.module.path(forResource: "create_help_tables", ofType: "sql")!))
        .enumerateLines { line, stop in _ = try! conn.query(line).wait() }

      (try String(contentsOfFile: Bundle.module.path(forResource: "fill_help_tables", ofType: "sql")!))
        .enumerateLines { line, stop in
          guard !line.hasPrefix("--") else { return }
          do {
            _ = try conn.query(line.replacingOccurrences(of: "\\'", with: "''")).wait()
          } catch {
            print(error)
          }
        }

//      let c = try conn.query("select * from help_category").wait()
//      print(c)

      let t = try conn.query("select * from help_topic").wait()
      //print(t)
      for t in t {
        let name = t.column("name")!.string!
        guard !["HELP_DATE", "HELP_VERSION", "HELP COMMAND"].contains(name) else { continue }

        //print(t.column("name")!.string!.lowercased())

        let desc = t.column("description")!.string!
        let lines = desc.components(separatedBy: "\\n")
        //print(lines.count)

        var signature = ""
        guard lines.count > 1, lines[0].hasPrefix("Syntax:") else { continue }
        signature = lines[1]

        let f = MySQLDocumentationFunction()
        f.name = signature
        functions.append(f)
      }

    } catch {
      print(error)
    }

    print(functions as NSArray)
    print(functions.count)
  }
}
