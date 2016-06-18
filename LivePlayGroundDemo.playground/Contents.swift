//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class MyTableViewController: UITableViewController {
    var elementList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell Identifier")
        runRequest()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"Cell Identifier") else
        {
        return UITableViewCell()
        }
        cell.textLabel?.text = elementList[indexPath.row]
        return cell
    
    }

    func parseJson(data:Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let groups = json["table"] as? [[String: AnyObject]] else { return }
            for group in groups {
                if let elements = group["elements"] as? [[String:AnyObject]] {
                    for element in elements {
                        if let elementName = element["name"] as? String {
                            elementList.append(elementName)
                        }
                    }
                    DispatchQueue.main.async(execute: { [weak self] in
                        self?.tableView.reloadData()
                    })
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func runRequest() {
        let requestURL = URL(string: "https://raw.githubusercontent.com/tsunglintsai/LiveStoryboard/master/PeriodicalTable/periodicTable.json")!
        let session = URLSession.shared()
        let task = session.dataTask(with: requestURL) { [weak self] (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                self?.parseJson(data: data!)
            }
        }
        task.resume()
    }
}

let myTableView = MyTableViewController(style: .plain)
PlaygroundPage.current.liveView = myTableView
