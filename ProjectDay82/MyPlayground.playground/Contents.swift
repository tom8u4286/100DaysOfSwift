import UIKit
import PlaygroundSupport

let rect = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

rect.backgroundColor = .red

extension UIView {
    /** 在若干時間內，動畫縮小至幾乎消失。
     */
    func bounceOut(duration: TimeInterval){
        UIView.animate(withDuration: duration, delay: 0, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

PlaygroundPage.current.liveView = rect
rect.bounceOut(duration: 3)

extension Int {
    /** 依本身數值，作為執行closure的次數。
     * 如: 5.times{ print("test")} 將印出test五次。
     */
    func times(closure: () -> Void){
        guard self > 0 else { return }
        for _ in 1...self{
            closure()
        }
    }
}

3.times { print("test") }


extension Array where Element: Comparable {
    // 將某元素從Array中移除
    mutating func remove(item: Element){
        if let firstIndex = self.firstIndex(of: item){
            self.remove(at: firstIndex)
        }
    }
}

var array = ["one","two", "three"]
array.remove(item: "two")
