//
//  ViewController.swift
//  Project7
//
//  Created by 曲奕帆 on 2022/6/21.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        var urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        /*  Dispatch (v.) 派遣、發送
            GCD: Grand Central Dispatch(操作執行緒的工作)
            QOS: quality of service(工作重要度)
            qos依照重要度排序，主要有四種:
            1.User Interactive
            2.User Initiated(由User觸發的)
            3.Utility
            4.Background
        */
        DispatchQueue.global(qos: .userInitiated).async {
            // 由於我們需要使用self裡的function parse，必須要代入參數
            [weak self] in
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self?.parse(json: data)
                    return
                }
            }
            /*
             此處應注意，由於showError是一份與"UI"相關的Alert工作，
             從背景的執行序呼叫是一個很不好的做法，
             因此也應修改showError內，改由主執行緒完成Alert的工作。
            */
            self?.showError()
        }
    }
    
    func showError(){
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(
                title:"Loading error",
                message: "There was a problem loading the feed; please check your connection and try again.",
                preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title:"OK", style: .default))
            self?.present(ac, animated: true)
        }  
    }

    // 載入Data時，回執行parse
    func parse(json: Data){
        let decoder = JSONDecoder()
         
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            
            /*
             由於在載入Data時，我們使用了userInitiated的執行緒
             因此此處完成載入後，要請主執行緒reload畫面
            */
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

