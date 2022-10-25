//
//  DetailViewController.swift
//  Project1
//
//  Created by 曲奕帆 on 2022/10/14.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        /** target設定要找到的view controller位置，我們設計在本VC裏面，因此設定為self。
         * action設定要觸發的function名稱。
         * 由於要使用objective-C的function，所以使用#selector，
         * 在撰寫function時，也要加上 objc
         */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("沒有可顯示的image。")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage], applicationActivities: [])
        
        /** popoverPresentationController是為了iPad而設計，
         * iPad會在按鈕處顯示popover的對話泡泡。
         */
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // 顯示本view controller
        present(vc, animated: true)
    }
}
