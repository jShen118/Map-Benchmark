//
//  benchmark.swift
//  Benchmarking Maps
//
//  Created by Joshua Shen on 11/6/18.
//  Copyright © 2018 Joshua Shen. All rights reserved.
//

import Foundation

func getCurrentNano() -> Int64{
    return Int64(NSDate().timeIntervalSince1970 * 1000000)
}

public class MapBenchmark{
    var stringList = [String]()
    let chars = Array("abcdefghijklmnopqrstuvwxyz".characters)
    
    let MAX_SIZE = 400000
    let NUMBER_GETS = 200000
    let NUMBER_PUTS = 200000
    
    var startTaskms: Int64 = 0
    var endTaskms: Int64 = 0
    
    func startTimer() {startTaskms = getCurrentNano()}
    func stopTimer() {endTaskms = getCurrentNano()}
    func elapsedTimeMillionth()-> Int {return Int(endTaskms - startTaskms)}
    func elapsedTimeSeconds()-> Int {return elapsedTimeMillionth() / 1000000}
    func elapsedTimeTenthsSeconds()-> Int {return elapsedTimeMillionth() / 100000}
    func benchmarkMessageTenths(mess: String) {print("\(mess) took \(elapsedTimeTenthsSeconds) tenths of a second")}
    
    func getRandomInt(range: Int)-> Int {return Int(arc4random_uniform(UInt32(range)))}
    
    func makeString(length: Int) -> String{
        var s = ""
        let numberChars = chars.count
        for _ in 0..<length{
            s.append(chars[getRandomInt(range: numberChars)])
        }
        return s
    }
    
    func makeStringList(size: Int){
        stringList = [String]()
        for _ in 0..<size{
            stringList.append(makeString(length: 10))
        }
    }
    
    func makeMap(type: MapType, size: Int)-> FakeMap<String, String> {
        var newMap = FakeMap<String, String>()
        switch type {
            case .Linear: newMap = LinearMap<String, String>()
            case .Binary: newMap = BinaryMap<String, String>()
            case .Hash: newMap = HashMap<String, String>()
            default: newMap = FakeMap<String, String>()
        }
        for i in 0..<size {
            newMap.set(stringList[i], stringList[i])
        }
        return newMap
    }
}

//map test function
extension MapBenchmark {
    func mapTest(mapType: MapType) {
        makeStringList(size: 1000)
        var runTimes = RunTime()
        let testSizes = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]

        for s in testSizes {
            let lm = makeMap(type: mapType, size: s)
            
            startTimer()
            lm.set("key", "value")
            stopTimer()
            runTimes.SetRunTimes.append(Double(elapsedTimeMillionth()))
            
            startTimer()
            lm.get("key")
            stopTimer()
            runTimes.GetRunTimes.append(Double(elapsedTimeMillionth()))
            
            startTimer()
            lm.remove("key")
            stopTimer()
            runTimes.RemoveRunTimes.append(Double(elapsedTimeMillionth()))
        }
        
        print("set runtimes: \(runTimes.SetRunTimes)")
        print("get runtimes: \(runTimes.GetRunTimes)")
        print("remove runtimes: \(runTimes.RemoveRunTimes)")
        print(runTimes.getBigO())
    }
}


//struct that stores runtimes of get, set, and remove operations and analyzes them
struct RunTime: CustomStringConvertible {
    var GetRunTimes = [Double]()
    var SetRunTimes = [Double]()
    var RemoveRunTimes = [Double]()
    
    func getBigO()-> String {
        var result = ""
        result += "Set correlation coefficient: \(correlationCoefficient(SetRunTimes))\n"
        switch true {
            case BigO_n(SetRunTimes): result += "Set Big-O is n\n\n"
            case BigO_c(SetRunTimes): result += "Set Big-O is c\n\n"
            case BigO_logn(SetRunTimes): result += "Set Big-O is log n\n\n"
            default: result += "Set Big-O cannot be determined from runtimes\n\n"
        }

        result += "Get correlation coefficient: \(correlationCoefficient(GetRunTimes))\n"
        switch true {
            case BigO_n(GetRunTimes): result += "Get Big-O is n\n\n"
            case BigO_c(GetRunTimes): result += "Get Big-O is c\n\n"
            case BigO_logn(GetRunTimes): result += "Get Big-O is log n\n\n"
            default: result += "Get Big-O cannot be determined from runtimes\n\n"
        }
        
        result += "Remove correlation coefficient: \(correlationCoefficient(RemoveRunTimes))\n"
        switch true {
            case BigO_n(RemoveRunTimes): result += "Remove Big-O is n\n\n"
            case BigO_c(RemoveRunTimes): result += "Remove Big-O is c\n\n"
            case BigO_logn(RemoveRunTimes): result += "Remove Big-O is log n\n\n"
            default: result += "Remove Big-O cannot be determined from runtimes\n\n"
        }
        
        return result
    }
    
    //test to see if Big-O is n
    func BigO_n(_ runtimes: [Double])-> Bool {
        return correlationCoefficient(runtimes) > 0.9
    }
    
    //test to see if Big-O is logn
    func BigO_logn(_ runtimes: [Double])-> Bool {
        //first makes a data set of 2^(runtime) values
        var transformedRuntimes = [Double]()
        for r in runtimes {transformedRuntimes.append(pow(2.0, r))}
        return correlationCoefficient(transformedRuntimes) > 0.8
    }
    
    //test to see if Big-O is c
    func BigO_c(_ runtimes: [Double])-> Bool {
        return correlationCoefficient(runtimes) < 0.3 && correlationCoefficient(runtimes) > -0.3
    }
    
    var description: String {return "\(GetRunTimes)\n\(SetRunTimes)\n\(RemoveRunTimes)"}
}

//helpers for calculating correlation coefficient of runtime of operation on size of map
extension RunTime {
    private func mean(_ data: [Double])-> Double {
        var sum = 0.0
        for d in data {sum += d}
        return sum / Double(data.count)
    }
    
    private func standardDeviation(_ data: [Double])-> Double {
        let dataMean = mean(data)
        var sumOfDifferencesSquared = 0.0
        for d in data {
            sumOfDifferencesSquared += ((d - dataMean) * (d - dataMean))
        }
        return sqrt(sumOfDifferencesSquared / Double(data.count - 1))
    }
    
    private func zScores(_ data: [Double])-> [Double] {
        let dataStandardDeviation = standardDeviation(data)
        let dataMean = mean(data)
        var zScores = [Double]()
        for d in data {
            zScores.append((d - dataMean) / dataStandardDeviation)
        }
        return zScores
    }
    
    private func correlationCoefficient(_ runTimes: [Double])-> Double {
        let testSizes = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0]
        let testSizesZ = zScores(testSizes)
        let runTimesZ = zScores(runTimes)
        var result = 0.0
        
        for i in 0...10 {
            result += testSizesZ[i] * runTimesZ[i]
        }
        result = result / Double(runTimes.count - 1)
        return result
    }
}
