//
//  ViewController.swift
//  Project10
//
//  Created by 曲奕帆 on 2022/10/6.

import UIKit

class ViewController: UICollectionViewController,
                    UIImagePickerControllerDelegate, // ImageController所需
                    UINavigationControllerDelegate // ImageController所需
    {
    
    /**  people為儲存Person物件的陣列。
     * Person的類別，儲存單一比相片資料。
     * Person內包含name與image兩個字串變數。
     *
     * Person設計為遵循Codable的Class，
     * 可以以JSON的方式，搭配JSONEncoder存入UserDefauts。
     */
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加號按鈕，讓User新增照片
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addNewPerson))
        
        /** 在App開啟時，先將people從DB中取出來。
         *  存放入people變數中。
         */
        let defaults = UserDefaults.standard
        
        /** 此處應注意，
         * defaults.object讀出來的型態為Any，要記得as?轉換為 Data型態
         */
        if let savedPeople = defaults.object(forKey: "people") as? Data{
            
            /** 使用JSONDecoder將資料以JSON的格式，
             * 從UserDefaults中讀取出來。
             */
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("讀取people失敗。")
            }
        }
            
    }
    
    // 讓User使用ImagePicker新增一張圖片
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
    
    /** User相片選擇完畢時會觸發didFinishPickingMediaWithInfo，
     *  可從info中取得所選圖片。
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 確認info所帶的image資料內容，可以被轉換成UIImage格式
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // 產生一組隨機的UUID
        let imageName = UUID().uuidString
        
        /** getDocumentsDirectory將取得app的路徑位置，
         * appendingPathComponent將在app的路徑下，
         * 新增一個我們預計要存放image的路徑位置。
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        
        // 將people存入UserDefault DB
        save()
        
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
        
        ac.addAction(UIAlertAction(title: "確認", style: .default){ [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            
            person.name = newName
            
            // 將person存入UserDefault DB
            self?.save()
            
            // 重新刷新頁面
            self?.collectionView.reloadData()
            
        })
        
        present(ac, animated: true)
    }
    
    /** 重點！ 此處將我們的資料格式存入UserDefault DB。
     *  此處我們使用JSONEncoder，將資料轉換後存入UserDefaults。
     *  將可搭配JSONDecoder，將資料從UserDefaults中取出。
     */
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
            
    }
    
    
    /** 取得本app的documentDirectory
     *  FileManager說明
     *  .documentDirectory: asks for the documents directory,
     *  .userDomainMask: the path to be relative to the user's home directory.
     */
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
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
        
        cell.imageView.layer.borderColor = UIColor(white: 0.1, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7

        return cell
    }
    
}

