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
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    
    @objc func fetchJSON(){
        var urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                // we're OK to parse
                parse(json: data)
                return
            }
        }
        
        /** 因為alert是UI相關的工作，
         *  不能讓showError在background thread跑，
         *  要改回main thread。
         */
        DispatchQueue.main.async { [weak self] in
            self?.showError()
        }
    }
    
    @objc func showError(){
        let ac = UIAlertController(
            title:"Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title:"OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
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

