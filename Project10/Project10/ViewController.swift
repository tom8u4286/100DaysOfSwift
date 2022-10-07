//
//  ViewController.swift
//  Project10
//
//  Created by 曲奕帆 on 2022/10/6.

import UIKit

class ViewController: UICollectionViewController,
                    UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    // didFinishPickingMediaWithInfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("✅ 相片選擇完畢 didFinishPickingMediaWithInfo被觸發！")
        // 確認info所帶的image資料內容，可以被轉換成UIImage格式
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // 產生一組隨機的UUID
        let imageName = UUID().uuidString
        
        //
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        /** 此處的dimiss沒有說明被dismiss的controller
         *  會主動將最上層的Controller dismiss。
         */
        dismiss(animated: true)
        
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

