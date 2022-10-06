//
//  ViewController.swift
//  Project10
//
//  Created by 曲奕帆 on 2022/10/6.

import UIKit

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /** 設定Cell的數量
     *  關鍵字 numberOfItemsInSection
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    /** 設定Cell的內容
     *  關鍵字: cellForItemAt
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /** 此處應注意型態！
         * dequeueReusableCell回傳的是通用的UICollectionViewCell，
         * 而非我們設計的PersonCell。
         * 因此此處應使用guard來轉型成PersonCell
         */
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("無法找到PersonCell")
        }
        
        return cell
    }
    
}

