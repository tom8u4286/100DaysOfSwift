//
//  ViewController.swift
//  Project10
//
//  Created by 曲奕帆 on 2022/10/6.

import UIKit

class ViewController: UICollectionViewController,
                    UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        
        // allowsEditing可以允許User編輯剪裁picker內的相片內容
        picker.allowsEditing = true

        /** 將picker的delegate設定為self時，
         *  必須follow UIImagePickerControllerDelegate, UINavigationControllerDelegate
         */
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    // didFinishPickingMediaWithInfo於User在相片選擇結束後被觸發
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("✅ 相片選擇完畢 didFinishPickingMediaWithInfo被觸發！")
        // 確認info所帶的image資料內容，可以被轉換成UIImage格式
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // 產生一組隨機的UUID作為image名稱
        let imageName = UUID().uuidString
        
        /** getDocumentsDirectory將取得app的路徑位置，
         * appendingPathComponent將在app的路徑下，
         * 新增一個我們預計要存放image的路徑位置。
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // 將圖片的檔案寫入我們設計好的路徑
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        
        // 重新整理collectionView
        collectionView.reloadData()
        
        /** 此處的dimiss沒有說明被dismiss的controller
         *  會主動將最上層的Controller dismiss。
         */
        dismiss(animated: true)
        
    }
    
    /** 實作當User點選一個Cell時，
     * 要彈出Alert讓User可以編輯Cell的名稱
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "更改名稱", message: nil, preferredStyle: .alert)
        
        // 新增一個文字輸入欄
        ac.addTextField()
        
        // 新增取消
        ac.addAction(UIAlertAction(title: "取消", style: .default))
        
        // 新增確認，並將TextField中User填寫的文字存入person物件中
        ac.addAction(UIAlertAction(title: "確認", style: .default){ [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            
            person.name = newName
            
            // 重新刷新頁面
            self?.collectionView.reloadData()
            
        })
        
        present(ac, animated: true)
    }
    
    /** 取得本app的documentDirectory
     *  FileManager說明
     *  .documentDirectory: asks for the documents directory,
     *  .userDomainMask: the path to be relative to the user's home directory.
     */
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("getDocumentsDirectory: \(path[0])")
        return path[0]
    }
    
    /** 設定本UICollectionView的Cell的數量
     *  關鍵字 numberOfItemsInSection
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 回傳目前people陣列的數量
        return people.count
    }
    
    /** 設定各個Cell的內容
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
        
        let person = people[indexPath.item]
        
        /** cell已經被轉型成PersonCell
         *  PersonCell內有兩個儲存變數: imageView(UIImageView)與 name(UILabel)
         */
        cell.name.text = person.name
        
        /** Person類別中有兩變數
         * name(String) 與 image(String)
         */
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // 在CALayer中設定元件border與cornerRadius
        cell.imageView.layer.borderColor = UIColor(white: 0.1, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3 // 這是Cell裡面的imageView的cornerRadius
        
        // 設定cell的cornerRadius
        cell.layer.cornerRadius = 7

        return cell
    }
    
}

