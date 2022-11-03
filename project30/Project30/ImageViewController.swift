//
//  ImageViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    /** 此處用「強參考」，
     * 參考其母頁面SelectionViewController，
     * 可能造成reference cycle，
     * 導致記憶體一直未被釋放而out of memory。
     * 因此，我們可以修改為weak。
     * https://www.hackingwithswift.com/read/30/6/fixing-the-bugs-running-out-of-memory
     */
    weak var owner: SelectionViewController!
    
    
	var image: String!
	var animTimer: Timer!

	var imageView: UIImageView!

	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.black

		// create an image view that fills the screen
		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.alpha = 0

		view.addSubview(imageView)

		// make the image view fill the screen
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

		// schedule an animation that does something vaguely interesting
		animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
			
            /** 此處應注意，這裡的self與timer已經造成reference cycle，
             * 因此我們應將此處的self設定為weak被傳入，
             * 或是我們設計再離開imageView時移除timer。
             *
             * https://www.hackingwithswift.com/read/30/6/fixing-the-bugs-running-out-of-memory
             */
            // do something exciting with our image
			self.imageView.transform = CGAffineTransform.identity

			UIView.animate(withDuration: 3) {
				self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			}
		}
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 離開imageView時，
        animTimer.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		title = image.replacingOccurrences(of: "-Large.jpg", with: "")
        
        /** 在創建UIImage(named: image)時，
         *  iOS 會將圖片載入後放進記憶體中。
         *  因此若圖片很大，且之後不常用到這個UIImage，
         *  不應過早宣告，節省記憶體空間。
         *
         *  我們也可以透過以下方式避免存入快取記憶體：
         *  let path = Bundle.main.path(forResource: image, ofType: nil)!
         *  let original = UIImage(contentsOfFile: path)!
         *
         *  教材原文：
         *  https://www.hackingwithswift.com/read/30/6/fixing-the-bugs-running-out-of-memory
         *  
         */
		let original = UIImage(named: image)!

		let renderer = UIGraphicsImageRenderer(size: original.size)

		let rounded = renderer.image { ctx in
			ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
			ctx.cgContext.closePath()

			original.draw(at: CGPoint.zero)
		}

		imageView.image = rounded
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		imageView.alpha = 0

		UIView.animate(withDuration: 3) { [unowned self] in
			self.imageView.alpha = 1
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let defaults = UserDefaults.standard
		var currentVal = defaults.integer(forKey: image)
		currentVal += 1

		defaults.set(currentVal, forKey:image)

		// tell the parent view controller that it should refresh its table counters when we go back
		owner.dirty = true
	}
}
