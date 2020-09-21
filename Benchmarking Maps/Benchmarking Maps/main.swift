//
//  main.swift
//  Benchmarking Maps
//
//  Created by Joshua Shen on 11/6/18.
//  Copyright © 2018 Joshua Shen. All rights reserved.
//

import Foundation

//test code
func bigO_Report() {
    let benchmark = MapBenchmark()
    print("***Running Big-O Report of Linear, Binary, and Hash Maps***\n")
    print("Linear Map Results: \n")
    benchmark.mapTest(mapType: .Linear)
    print("Binary Map Results: \n")
    benchmark.mapTest(mapType: .Binary)
    print("Hash Map Results: \n")
    benchmark.mapTest(mapType: .Hash)
}

bigO_Report()

/*
 ***Running Big-O Report of Linear, Binary, and Hash Maps***
 
 Linear Map Results:
 
 set runtimes: [77.0, 19.0, 36.0, 51.0, 72.0, 112.0, 100.0, 115.0, 131.0, 150.0, 162.0]
 get runtimes: [6.0, 36.0, 64.0, 97.0, 193.0, 173.0, 193.0, 225.0, 257.0, 289.0, 319.0]
 remove runtimes: [44.0, 19.0, 38.0, 55.0, 83.0, 87.0, 102.0, 117.0, 135.0, 150.0, 167.0]
 Set correlation coefficient: 0.903149758699099
 Set Big-O is n
 
 Get correlation coefficient: 0.983519756677938
 Get Big-O is n
 
 Remove correlation coefficient: 0.976977174796865
 Remove Big-O is n
 
 
 Binary Map Results:
 
 set runtimes: [70.0, 14.0, 22.0, 27.0, 36.0, 44.0, 52.0, 59.0, 63.0, 146.0, 108.0]
 get runtimes: [2.0, 1.0, 6.0, 3.0, 3.0, 5.0, 7.0, 6.0, 8.0, 9.0, 11.0]
 remove runtimes: [5.0, 3.0, 5.0, 4.0, 6.0, 6.0, 7.0, 8.0, 8.0, 12.0, 11.0]
 Set correlation coefficient: 0.709419271296731
 Set Big-O cannot be determined from runtimes
 
 Get correlation coefficient: 0.901596328658022
 Get Big-O is n
 
 Remove correlation coefficient: 0.908971676234591
 Remove Big-O is n
 
 
 Hash Map Results:
 
 set runtimes: [28.0, 1.0, 2.0, 2.0, 4.0, 2.0, 2.0, 2.0, 5.0, 3.0, 4.0]
 get runtimes: [3.0, 0.0, 1.0, 1.0, 3.0, 3.0, 1.0, 1.0, 1.0, 2.0, 1.0]
 remove runtimes: [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]
 Set correlation coefficient: -0.41008116876863
 Set Big-O cannot be determined from runtimes
 
 Get correlation coefficient: -0.116444501947916
 Get Big-O is c
 
 Remove correlation coefficient: 4.44089209850063e-17
 Remove Big-O is c
 */


