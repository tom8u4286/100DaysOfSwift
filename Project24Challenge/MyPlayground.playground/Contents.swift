import UIKit

extension String {
    func withPrefix(_ str: String) -> String{
        guard str != "" else {return self}
        if self.hasPrefix(str){
            return self
        }else{
            return str + self
        }
    }
    
    var isNumeric: Bool{
        // 確認此字串中只有數字
        for char in self.replacingOccurrences(of: ".", with: ""){
            /** 檢查如果有一個char無法轉換成Int(即轉出來為nil)
             * 即為「此字串無法轉換成數字」
             */
            if char.wholeNumberValue == nil{
                return false
            }
        }
        return true
    }
    
    var lines: [String]{
        return self.components(separatedBy: "\n")
    }
    
}

"pet".withPrefix("car")
"1234/57".isNumeric

"this\nis\na\ntest".lines
