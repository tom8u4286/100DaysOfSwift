//
//  ViewController.swift
//  ProjectDay50
//
//  Created by 曲奕帆 on 2022/10/15.
//

import UIKit

class ViewController: UITableViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate{

    // User挑選照片後，照片會被加入進此陣列
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 新增左上方加號按鈕
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
        let defaults = UserDefaults.standard
        
        // 將先前存進UserDefaults的資料存放入變數var中
        if let savedPicture = defaults.object(forKey: "pictures") as? Data{
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPicture)
            } catch {
                print("讀取失敗！")
            }
            
        }
        
    }
    
    // 加入新照片
    @objc func addNewPicture(){
        let picker = UIImagePickerController()
        
        // 設定picker為相機
        picker.sourceType = .camera
        
        /** 將picker的delegate設定為self時，
         *  必須follow UIImagePickerControllerDelegate, UINavigationControllerDelegate
         */
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 隨機產生一個相片的UUID
        let imageName = UUID().uuidString
        /** getDocumentsDirectory將取得app的路徑位置，
         * appendingPathComponent將在app的路徑下，
         * 新增一個我們預計要存放image的路徑位置。
         */
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // 以下彈出輸入Caption的對話框
        let ac = UIAlertController(title: "設定名稱", message: nil, preferredStyle: .alert)
        // 新增一個文字輸入欄
        ac.addTextField()
        // 新增取消按鈕
        ac.addAction(UIAlertAction(title: "取消", style: .default))
        // 新增確認按鈕
        ac.addAction(UIAlertAction(title: "確認", style: .default){ [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            
            guard let image = info[.originalImage] as? UIImage else { return }
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
            
            let picture = Picture(filename: imageName, caption: newName)
            self?.pictures.append(picture)
            
            // 頁面重新整理
            self?.tableView.reloadData()
            
            // 將picture存入UserDefault DB
            self?.save()
            
        })
        
        dismiss(animated: true){ [weak self] in
            self?. present(ac, animated: true)
        }
        
    }
    
    
    // 將變數picture存入UserDefault DB
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
            
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
    
    
    // 數兩設定為pictures的內容數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // 設定每一個Cell的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row].caption
        
        return cell
    }
    
    // 當點選某一Cell時的動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.filename = pictures[indexPath.row].filename
            vc.imageCaption = pictures[indexPath.row].caption
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }


}

