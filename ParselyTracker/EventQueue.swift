import Foundation
import os.log

extension Array {
    mutating func take(_ elementsCount: Int) -> [Element] {
        if elementsCount <= 0 {
            return []
        }
        let min = Swift.min(elementsCount, count)
        let segment = Array(self[0..<min])
        self.removeFirst(min)
        return segment
    }
}

class EventQueue<T> {
    private(set) var list = [T]()
    private let queue = DispatchQueue(label: "\(UUID().uuidString)_EventQueye", qos: .background)
    
    func push(_ element:T) {
        queue.sync {
            os_log("Event pushed into queue", log: OSLog.tracker, type: .debug)
            list.append(element)
        }
    }

    func push<Collection>(contentsOf elements:Collection) where T == Collection.Element, Collection: Sequence {
        queue.sync {
            os_log("Events pushed into queue", log: OSLog.tracker, type: .debug)
            list.append(contentsOf: elements)
        }
    }
    
    func pop() -> T? {
        var value: T?
        queue.sync {
            if list.isEmpty {
                return
            }
            os_log("Event popped from queue", log: OSLog.tracker, type: .debug)
            value = list.removeFirst()
        }
        return value
    }
    
    func get(count:Int = 0) -> [T] {
        var items: [T] = []
        queue.sync {
            if count == 0 {
                os_log("Got %zd events from queue", log: OSLog.tracker, type: .debug, list.count)
                items = list.take(list.count)
                return
            }
            os_log("Got %zd events from queue", log: OSLog.tracker, type: .debug, count)
            items = list.take(count)
        }
        return items
    }
    
    public func length() -> Int {
        var length: Int!
        
        queue.sync {
            length = list.count
        }
        return length
    }
}
