//
//  ViewController.swift
//  Project13
//
//  Created by 曲奕帆 on 2022/10/17.
//


import CoreImage
import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    // 當前頁面上的ImageView，預計讓User加入圖庫中的圖片進來
    @IBOutlet var imageView: UIImageView!
    
    // intensity可以翻譯為"強度"，是UI滑桿
    @IBOutlet var intensity: UISlider!
    
    // 更改Filter的按鈕
    @IBOutlet var changeFilterButton: UIButton!

    // 用currentImage作為濾鏡currentFilter的input
    var currentImage: UIImage!

    // CI表示Core Image，CIContext負責Rendering
    var context: CIContext!
    // 當前使用的濾鏡
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "圖片濾鏡"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        
        // 設定Core Image的環境
        context = CIContext()
        
        // 設定預設的濾鏡為"CISepiaTone"
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    // 用imagePicker載入圖片
    @objc func importImage(){
        // 使用imagePicker時，記得要在plist中加入權限要求提示
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        /** 當self作為UIImagePickerController的delegate時，
         *  self需要遵循UIImagePickerControllerDelegate與UINavigationControllerDelegate。
         */
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // 當User選取完照片時觸發
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 確認選到照片正確無誤，關閉PickerController
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        // 輸入進CIFilter的圖片必須為CIImage型態(currentImage為UIImage型態)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    
    // User設定要使用的濾鏡
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Change Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        /** 此處的popoverController可以讓iPad介面在點選按鈕時，
         *  選單彈框會出現在按鈕上。
         */
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
                     
        present(ac, animated: true)
    }
    
    // User點選要使用的濾鏡後的行為
    func setFilter(action: UIAlertAction){
        // 檢查User是否已經選擇圖片
        guard currentImage != nil else { return }
        
        guard let actionTitle = action.title else { return }
        
        // 將ChangeFilter的按鈕文字改為當前的Filter名稱
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        // 初始新的CIFilter
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    // 將濾鏡調整過後的圖片存入手機相簿中
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "沒有圖片", message: "請先加入圖片", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            // 顯示警示彈框
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    // 滑桿值發生改變時觸發
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // 讓濾鏡處理相片
    func applyProcessing(){
        /** 由於不同的Filter有不同的key，
         * 此處我們先將filter有的key取出，以便後續操作。
         */
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey){
            currentFilter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

