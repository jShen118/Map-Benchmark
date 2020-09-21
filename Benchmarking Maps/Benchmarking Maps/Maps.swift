//
//  Maps.swift
//  Benchmarking Maps
//
//  Created by Joshua Shen on 11/6/18.
//  Copyright © 2018 Joshua Shen. All rights reserved.
//

enum MapType {
    case Fake, Linear, Binary, Hash
}

//abstract map class
class FakeMap<K, V>: CustomStringConvertible {
    var type: MapType {return .Fake}
    func getNumberCollisions()-> Int {return 0}
    func set(_ k: K, _ v: V) {return}
    func remove(_ k: K) {return}
    func get(_ k: K)-> V? {return nil}
    var count: Int {return 0}
    subscript(key: K)-> V? {return nil}
    var description: String {return "Fake Map!"}
}

class LinearMap<K: Equatable, V>: FakeMap<K, V> {
    override var type: MapType {return .Linear}
    var keys = Array<K>()
    var values = Array<V>()
    override var count: Int {return keys.count}
    
    func findKeyIndex(_ k : K)-> Int? {
        for i in 0..<keys.count {
            if keys[i] == k {
                return i
            }
        }
        return nil
    }
    
    override func set(_ k: K, _ v: V) {
        if findKeyIndex(k) != nil {
            values[findKeyIndex(k)!] = v
        } else {
            keys.append(k)
            values.append(v)
        }
    }
    
    override func remove(_ k: K) {
        let removePosition = findKeyIndex(k)
        if removePosition == nil {return}
        keys.remove(at: removePosition!)
        values.remove(at: removePosition!)
    }
    
    override func get(_ k: K)-> V? {
        if findKeyIndex(k) != nil {
            return values[findKeyIndex(k)!]
        }
        return nil
    }
    
    override subscript(key: K)-> V? {
        get {return get(key)}
        set(newValue) {set(key, newValue!)}
    }
    
    override var description: String {
        var description = "["
        for i in 0..<keys.count {
            description += "\n\(keys[i]) : \(values[i])"
        }
        description += "\n]\n"
        return description
    }
}

class BinaryMap<K: Comparable, V>: FakeMap<K, V> {
    var keys = Array<K>()
    var values = Array<V>()
    override var count : Int {return keys.count}
    
    override func set(_ k: K, _ v: V) {
        if binarySearch(elements: keys, target: k) != nil {
            values[binarySearch(elements: keys, target: k)!] = v
        } else {
            let insertAt = insertPosition(k)
            keys.insert(k, at: insertAt)
            values.insert(v, at: insertAt)
        }
    }
    
    override func get(_ k: K)-> V? {
        if binarySearch(elements: keys, target: k) != nil {
            return values[binarySearch(elements: keys, target: k)!]
        }
        return nil
    }
    
    override func remove(_ k: K) {
        let removePosition = binarySearch(elements: keys, target: k)
        if removePosition == nil {return}
        keys.remove(at: removePosition!)
        values.remove(at: removePosition!)
    }
    
    func insertPosition(_ k: K)-> Int {
        for i in 0..<count {
            if k < keys[i] {return i}
        }
        return keys.endIndex
    }
    
    func binarySearch(elements: Array<K>, target: K) -> Int? {
        var lowerIndex = 0
        var upperIndex = elements.count - 1
        
        while true {
            let currentIndex = (lowerIndex + upperIndex) / 2
            if lowerIndex > upperIndex {
                return nil
            } else if (elements[currentIndex] == target) {
                return currentIndex
            } else {
                if (elements[currentIndex] > target) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    
    
    override subscript(key: K)-> V? {
        get {return get(key)}
        set(newValue) {set(key, newValue!)}
    }
    
    override var description: String {
        var description = "["
        for i in 0..<keys.count {
            description += "\n\(keys[i]) : \(values[i])"
        }
        description += "\n]\n"
        return description
    }
}

class HashMap<K: Hashable, V>: FakeMap<K, V> {
    var keys: Array<K?>
    var values: Array<V?>
    var collisionMap = LinearMap<K, V>()
    override var count: Int {return keys.count + collisionMap.count}
    var initialArraySize: Int
    var numberCollisions = 0
    
    init(initialArraySize: Int = 2000) {
        keys = Array<K?>(repeating: nil, count: initialArraySize)
        values = Array<V?>(repeating: nil, count: initialArraySize)
        self.initialArraySize = initialArraySize
    }
    
    override func set(_ k: K, _ v: V) {
        let index = abs(k.hashValue % initialArraySize)
        if keys[index] == nil {
            keys[index] = k
            values[index] = v
        } else {
            if keys[index] == k {values[index] = v}
            else {handleCollision(k, v)}
        }
    }
    
    func handleCollision(_ k: K, _ v: V) {
        let oldCollisionCount = collisionMap.count
        collisionMap.set(k, v)
        if collisionMap.count > oldCollisionCount{
            numberCollisions += 1
        }
    }
    
    override func get(_ k: K)-> V? {
        let index = abs(k.hashValue % initialArraySize)
        if keys[index] == k {return values[index]}
        return collisionMap.get(k)
    }
    
    override subscript(key: K)-> V? {
        get {return get(key)}
        set(newValue) {set(key, newValue!)}
    }
    
    override var description: String {
        var description = "["
        for k in keys where k != nil {
            description += "\n\(k!) : \(get(k!)!)"
        }
        for i in 0..<numberCollisions {
            description += "\n\(collisionMap.keys[i]) : \(collisionMap.values[i])"
        }
        description += "\n]\n"
        return description
    }
}

