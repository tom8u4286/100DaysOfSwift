//
//  ViewController.swift
//  Project6b
//
//  Created by 曲奕帆 on 2022/6/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label1 = UILabel()
        // translatesAutoresizingMaskIntroConstraintsXcode裡可打"TAMIC"
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "THESE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .orange
        label5.text = "LABELS"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

        let viewDictionary = [
            "label1": label1,
            "label2": label2,
            "label3": label3,
            "label4": label4,
            "label5": label5,
        ]
        
        // view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label1]|", options:[], metrics: nil, views: viewDictionary))
        // view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label2]|", options:[], metrics: nil, views: viewDictionary))
        // view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label3]|", options:[], metrics: nil, views: viewDictionary))
        // view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label4]|", options:[], metrics: nil, views: viewDictionary))
        // view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label5]|", options:[], metrics: nil, views: viewDictionary))

//         for label in viewDictionary.keys{
//             view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options:[], metrics: nil, views: viewDictionary))
//         }
//
//         let matrics = ["labelHeight": 88]
//
//         view.addConstraints(
//             NSLayoutConstraint.constraints(
//                 withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|",
//                 options: [],
//                 metrics: matrics,
//                 views: viewDictionary
//             )
//         )

        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5]{
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            // 此處以if let previous = previous的撰寫方式，意思是:
            // 如果previous有值，則...
            // 意思是在判斷label是否為第一個lable
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previous = label
        }

    }


}

