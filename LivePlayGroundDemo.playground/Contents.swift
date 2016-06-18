//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"


let requestURL = URL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
let urlRequest = URLRequest(url: requestURL)
let session = URLSession.shared()
let task = session.dataTask(with: requestURL) { (data, response, error) in
    let httpResponse = response as! HTTPURLResponse
    let statusCode = httpResponse.statusCode
    if (statusCode == 200) {
        print("Everyone is fine, file downloaded successfully.")
    }
}

task.resume()