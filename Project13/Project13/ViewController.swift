//
//  ViewController.swift
//  Project13
//
//  Created by 曲奕帆 on 2022/10/17.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var intensity: UISlider!
    
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        
    }
    
    // 用imagePicker載入圖片
    @objc func importImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        /** 當self作為UIImagePickerController的delegate時，
         *  self需要遵循UIImagePickerControllerDelegate與UINavigationControllerDelegate。
         */
        picker.delegate = self
        
    }
    
    // 當User選取完照片時觸發
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
    }
    

    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    
    // 滑桿值發生改變時觸發
    @IBAction func intensityChanged(_ sender: Any) {
        
    }
    
}

