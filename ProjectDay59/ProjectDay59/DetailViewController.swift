//
//  DetailViewController.swift
//  ProjectDay59
//
//  Created by 曲奕帆 on 2022/10/18.
//

import UIKit

class DetailViewController: UIViewController {

    // 進入頁面時，母頁面將會assign好country進來
    var country: Country?
    
    // 國旗imageView
    var flagImageView: UIImageView!
    
    // 國家名稱Lable
    var nameLabel: UILabel!
    // 國家人口數Label
    var populationLabel: UILabel!
    // 國家面積Label
    var areaLabel: UILabel!
    
    override func loadView() {
        view = UIView()
        // 背景為白色
        view.backgroundColor = .white
        
        guard let countryName = country?.name else { return }
        
        // 將標題改為小標題
        navigationItem.largeTitleDisplayMode = .never
        // 標題名稱為國家名稱
        navigationItem.title = countryName
        
        // 國旗ImageView
        flagImageView = UIImageView(image: UIImage(named: countryName))
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        flagImageView.layer.borderWidth = 1
        flagImageView.contentMode = .scaleAspectFit
        view.addSubview(flagImageView)
        
        // 國家名稱Label
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = country?.name
        view.addSubview(nameLabel)
        
        // 人口數Label
        populationLabel = UILabel()
        populationLabel.translatesAutoresizingMaskIntoConstraints = false
        if let population = country?.population {
            populationLabel.text = "人口數: \(String(population))"
        }
        view.addSubview(populationLabel)
        
        
        // 面積大小Label
        areaLabel = UILabel()
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        if let area = country?.area {
            areaLabel.text = "面積: \(String(area))"
        }
        view.addSubview(areaLabel)
        
        
        NSLayoutConstraint.activate([
            // 設定國旗的Layout
            flagImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            flagImageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 200),
            flagImageView.heightAnchor.constraint(equalToConstant: 100),
            // 設定國家名稱的Layout
            nameLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            // 設定人口數Label
            populationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            populationLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            // 設定面積Label
            areaLabel.topAnchor.constraint(equalTo: populationLabel.bottomAnchor, constant: 20),
            areaLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
            
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

}
