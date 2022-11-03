//
//  ViewController.swift
//  Project7
//
//  Created by 曲奕帆 on 2022/6/21.
//

import UIKit

class ViewController: UITableViewController {

    // Petition(請願)的陣列
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        // 利用parse將url中的JSON資料解碼出來
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                // url與data都沒問題，可以進行json解碼
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
    }
    
    // 若解碼JSON的過程失敗顯示的Alert
    func showError(){
        let ac = UIAlertController(
            title:"Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title:"OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data){
        // JSON解碼器
        let decoder = JSONDecoder()
         
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            // 重新整理tableView，讓資料載入Cells中
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    // didSelectRowAt設定點選到Cell時的反應
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = DetailViewController()
        // 設定DetailView內的變數，供其參考
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

