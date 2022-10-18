//
//  ViewController.swift
//  ProjectDay59
//
//  Created by 曲奕帆 on 2022/10/18.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let jsonData = readLocalJSONFile(forName: "Data")

        if let data = jsonData {
            if let countriesObject = parse(jsonData: data) {
                countries = countriesObject.countries
            }
        }
        
    }
    
    // 讀取Local的JSON檔案
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error1: \(error)")
        }
        return nil
    }
    
    // 將Data轉換為Countries物件
    func parse(jsonData: Data) -> Countries? {
        do {
            let decodedData = try JSONDecoder().decode(Countries.self, from: jsonData)
            return decodedData
        } catch {
            print("error2: \(error)")
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.country = countries[indexPath.row]
        
        // 推入此頁面
        navigationController?.pushViewController(vc, animated: true)
    }
}

