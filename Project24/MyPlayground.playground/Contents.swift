import UIKit

var greeting = "Hello, playground"
let name = "Taylor"

for letter in name {
    print(letter)
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]
let password = "12345"

// 是否包含字首、字尾
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
}


let weather = "it's going to rain"
// capitalized會將每一個單字的第一個字母都大寫
print(weather.capitalized)

// 我們也可以設計我們自己的function，只讓句子的第一個
extension String {
    var capitalizedFirst: String{
        guard let firstLetter = self.first else { return "" }
        /** 說明：
         * 1.uppercased()是型態Character 的function，而不是String的
         * 2.uppercased回傳的仍會是一個String型態
         * 有一些語言的大小寫並不是一對一的，(英文的 a -> A，是1對1的)
         * 如德文的 "ß"，大寫為"SS"。
         */
        return firstLetter.uppercased() + self.dropFirst()
    }
}
print(weather.capitalizedFirst)




/** 練習撰寫某String是否包含array其一元素的function(containsAny)
 */
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array{
            if self.contains(item){
                return true
            }
        }
        return false
    }
}
input.containsAny(of: languages)

/** contains(where:) 比較複雜，可參考原教材
 * https://www.hackingwithswift.com/read/24/3/working-with-strings-in-swift
 * 說明：contains(where:) will call its closure once for every element in the languages array until it finds one that returns true, at which point it stops.
 * 因此此function會先執行input.contains("Python")，再執行input.contains("Ruby")，再執行input.contains("Swift")，
 * 一直執行到有true為止。
 * 如此一來，就不用自己撰寫的containsAny()
 */
languages.contains(where: input.contains)


/** 字體更改練習
 */
let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

/** 以上皆可由UILable的設定達成，
 * 但是如果只要更改部分的內容，UILabel就無法做到。
 * 以下介紹NSMutableAttributedString。
 */
let mutableAttributedString = NSMutableAttributedString(string: string)

// This
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
// is
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
// a
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
// test
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
// string
mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


mutableAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 20))
mutableAttributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.double.rawValue, range: NSRange(location: 0, length: 20))

/** 因此 我們在修改UILabel, UITextField, UITextView, UIButton, UINavigationBar相關的文字格式時，
 * 要修改的是attributedText而非text。
 */
