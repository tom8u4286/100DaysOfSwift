//
//  ViewController.swift
//  Project27
//
//  Created by 曲奕帆 on 2022/11/1.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType{
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        default:
            break
        }
        
    }
    
    func drawRectangle(){
        /** UIGraphicsImageRenderer是UIKit的Class，而不是CG的Class，
         * 他扮演一個CG與UIKit世界的接口角色。
         * 原教材說明：
         * https://www.hackingwithswift.com/read/27/3/drawing-into-a-core-graphics-context-with-uigraphicsimagerenderer
         */
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in // cxt為context
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // 若設為10，此Line會在border內5點寬，border外5點寬
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    func drawCircle(){
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in // cxt為context
            /** 由於我們設計rectangle的大小正好等於renderer的大小，
             * 因此會發現圓形產生出來時，我們畫的邊緣會切掉(setLineWidth)。
             * 因此我們設定rectangle的inset，排除被切掉的問題。
             */
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            // 若設為10，此Line會在border內5點寬，border外5點寬
            ctx.cgContext.setLineWidth(10)
            
            // Ellipse n.橢圓
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
    // 棋盤花格
    func drawCheckerBoard(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in // cxt為context
            
            for row in 0...7 {
                for col in 0...7 {
                    /** 觀察西洋棋的座標，可發現座標相加為偶數時，皆為黑色格，
                     * 奇數皆為白色格。
                     * .isMultiple可以取得是否為某數的倍數。
                     */
                    if (row + col).isMultiple(of: 2){
                        ctx.cgContext.fill(CGRect(x: 64*row, y: 64*col, width: 64, height: 64))
                    }
                }
            }
            
        }
        imageView.image = image
    }
    
    func drawRotatedSquares(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            /** ctx.cgContext的起始座標皆在左上角，
             * 我們先將起點座標移動至renderer的正中央。
             */
            ctx.cgContext.translateBy(x: 256, y: 256)
            // 設定我們想要旋轉次數
            let rotation = 16
            let amount = Double.pi / Double(rotation)
            
            for _ in 0 ..< rotation {
                ctx.cgContext.rotate(by: CGFloat(amount))
                // 將此正方形的最左上角，從剛剛的(256,256)往左往上移動128點
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    func drawLines(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                /** rotate會將整個座標平面，以逆時針方向旋轉
                 *  因此當rotate 90度時，
                 *  數字邏輯上向右畫，例如向(x: 100, y:0)處畫，
                 *  畫面上實際會呈現向下畫。
                 */
                
                ctx.cgContext.rotate(by: .pi / 2)
            
                if first {
                    /** 由於rotate 90度，
                     * 執行move(:to)後，整條線的最起始位置，約在畫面的下測。
                     */
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    /** 說明，
                     * for迴圈的每一輪，此處的CGPoint位置都會改變，約會在畫面的下、左、上、右。
                     * 因此for迴圈的第二輪，
                     * 再次執行rotate後，addLine(to:)會從剛剛move(to)到達的下側，畫到旋轉後的CGPoint新的位置(約在畫面的左側)。
                     * for迴圈的第三輪，會從左側，畫到新的位置(約在畫面的上側)。
                     *
                     * 簡而言之，先前畫過的內容、位置，不會因爲rotate而更改。
                     * 而是rotate之後，再呼叫CGPoint時，該位置會是旋轉後的新位置。
                     */
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    
    func drawImagesAndText(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448),options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
}

