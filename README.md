本專案夾存放2022年練習100 Days of Swift的30個練習Project。以下介紹各Project的練習重點。

100 Days of Swift 教材網址:
https://www.hackingwithswift.com/100

## Project1 Storm Viewer 相片檢視
1. 使用TableViewController，並設定numberOfRowsInSection與cellForRowAt。
2. 使用dequeueReusableCell，提高記憶體使用效率。
3. FileManager 練習使用FileManager讀取Bundle中具有某檔名的圖片。
4. 使用as?，嘗試將物件轉型至某一類別型態。
5. 使用storyboard設計Layout，並使用AutoLayout contraints設計imageView的大小。

## Project2 國旗國名小遊戲
1. 使用storyboard設計三個國旗按鈕，並設計AutoLayout，將國旗放置整齊。
2. 使用NavigationController，設定標題。
3. 使用Int.Random，讓各題的答案皆在不同位置(如：第一題正確答案為A，第二題正確答案為C)。
4. 使用shuffle()，讓各題的選項皆不同(如：第一題為US、Japan、UK，第二題為Spain、Franch、Russian)。
5. 使用AlertController，提示玩家答對或答錯。

## Project3 Storm Viewer圖片存入手機相簿
1. 使用rightBarButtonItem，設定ActionButton。
2. 設定Button點選後要觸發的function，以@objc設定funcion。

## Project4 WebView網頁載入與進度條設計
1. 實作網頁載入進度條ProgressView，並以observeValue更新載入進度狀態。
2. 透過WKNavigationDelegate，接收webView的行為事件通知。
3. 以webView的decidePolicyFor來控管即將前往的網頁。

## Project5 Word Scramble文字腦力激盪遊戲
1. 參照迴圈reference cycle(strong, weak, unowned)問題練習。
2. contentsOfFiles讀取Bundle中的檔案，設定至標題作為題目。
3. 設計Alert中的TextField，讓User在Alert中可以輸入文字。
4. 利用Array.firstIndex(of:)取得array中第一個符合條件的位置。
5. insertRow(at)在TableView中的特定位置，加入新的Cell。
6. 使用UITextChecker檢查文字是否為一真實單字

## Project6 以VFL設定AutoLayout
1. 利用AutoLayout統一頁面中按鈕的大小，並調整長寬比例
2. 利用Visual Format Language (VFL)設定AutoLayout
3. 利用Anchor設定AutoLayout

## Project7 白宮請願API調用
1. 在storyboard中，NavigationController內設計UITabBarController
2. 利用URL()調用網路API的資料，並用Data(contentsOf:)擷取 
3. 設計請願petition，並遵循Codable protocol
4. 以JSONDecoder將API截取的資料轉換成Codable結構
5. 以webView.loadHTMLString呈現HTML的源碼

## Project8 Swifty Words iPad文字拼湊遊戲
1. 程式設定Layout Contraints
2. 設定Label的TextAlignment
3. 設定元件的ContentHuggingProiority，調整元件被拉長的容易度
4. 載入Bundle中的文字檔，並以符號拆解字串

## Project9 GCD 背景調用API資料

## Project10 以ImagePicker將相簿內容存放於CollectionView
1. 利用CollectionViewController設計圖片Layout
2. 利用ImagePicker取得手機相簿照片
3. 設定取用相簿權限
4. 以UUID命名相片元件
5. 利用FileManager，取得App的documentDirectory路徑，並存放圖片檔案
6. 設計fatalError，於找不到Cell時觸發
7. 建立繼承NSObject的Person類別，存放圖片與User輸入的名稱
8. CALayer設定元件邊框border與圓角cornerRadius

## Project11 SpriteKit彈珠台iPad小遊戲
1. 利用SpriteKit建立iPad遊戲
2. 利用SKSpriteNode、SKPhysicsBody建立可碰撞的實體物件
3. 設定isDynamic，讓物體有重力加速度與碰撞加速度
4. 以CGPoint設定障礙物與彈珠物件在遊戲中的位置

## Project12AB UserDefaults長久儲存資料
1. 使用UserDefault將使用者資料長期儲存(persist storage)
2. 使用NSCoding、NSKeyedArchiver、NSKeyedUnarchiver儲存與讀取資料
3. 使用JSONEncoder、JSONDecoder、Codable儲存讀取資料

## Project13 Instafilter 圖片濾鏡
1. 使用CoreImage的CIContext與CIFilter設計圖片濾鏡
2. 以kCIInputIntensityKeygk設定濾鏡參數
3. 使用UISlider調整濾鏡處理相片的程度
4. 將處理完成的相片存入手機相簿中

## Project14 Whack-a-Penguin 打企鵝小遊戲
1. 使用SpriteKit創建遊戲
2. 繼承SKNode建立WhackSlot類別，
3. 使用SKCropNode建立遮蔽Mask，讓企鵝可以像躲在洞內
4. 使用DispatchQueue的asyncAfter設計一段時間後執行工作
5. 使用SKTexture調整node的圖片內容(好壞企鵝交替)
6. 使用node.run執行SKAction動畫(企鵝出現與隱藏)
7. 使用SKAction.sequence設計序列動畫
8. 使用SKAction.playSoundFileNamed播放打擊音效

## Project15 UIKit動畫
1. 使用UIView.animate、CGAffineTransform執行動畫
2. 設計圖片放大、縮小動畫
3. 設計位置移動動畫
4. 設計圖片旋轉動畫
5. 設計顏色、透明度改變動畫
6. 使用usingSpringWithDamping讓動畫有彈性效果 

## Project16 Capital Cities地圖與首都標記
1. 使用MapKit繪製地圖 
2. 設計Capital類別，存放標題、經緯度(CLLocationCoordinate2D)、說明
3. Capital遵循MKAnnotation協定，可作為地圖標的(如大頭針)
4. 利用is作為判斷式(判斷物件是否為Capital類別)
5. 利用dequeueReusableAnnotationView重複使用大頭針(類似TableView與Cell的概念)
6. 利用rightCalloutAccessoryView設定大頭針的資訊泡泡
7. 設定大頭針旁的小標籤annotation

## Project17 Space Race太空垃圾小遊戲
1. 使用SpriteKit設計遊戲
2. 設計Timer.scheduledTimer定期創建新的太空垃圾
3. 利用advanceSimulationTime，讓遊戲開始時星空即可佈滿畫面
4. 利用CGVector設定太空垃圾的移動速度
5. 設定太空垃圾的旋轉角速度
6. 垃圾離開畫面後，從遊戲中移除該物件，降低記憶體負擔
7. 利用SKPhysicsBody設定物品在遊戲場景中的物理實體(可觸發碰撞)

## Project18 Debug方法操作
1. print的terminator與separator
2. assert的使用與crash條件設定
3. Xcode的breakpoint與條件設定

## Project19

## Project20 Fireworks Night煙火小遊戲
1. 利用SpriteKit創建小遊戲
2. 利用Timer.scheduledTimer定時發送煙火 
3. 利用UIBezierPath設計路徑，讓煙火遵循路徑移動
4. 利用Array的enumerated()與.reversed()，將元素逐一從array中移除
5. touchesBegan與touchesMoved中設計判斷觸碰到的煙火
6. 煙火離開畫面後，將其從Scene中移除，降低記憶體負擔

## Project21 Local Notification事件通知
1. 利用UserNotifications Library實作 
2. 使用UNUserNotificationCenter請求App發送通知權限 
3. removeAllPendingNotificationRequests()移除手機鎖定頁面，App相關的所有通知
4. 使用UNMutableNotificationContent()可以
5. 使用DateComponents()建立日期與時間物件
6. 設計特定時間點觸發通知的UNCalendarNotificationTrigger與一段時間後觸發通知的UNTimeIntervalNotificationTrigger
7. 實作給通知中心的通知請求UNNotificationRequest
8. 實作通知類別UNNotificationCategory，並將此類別註冊給通知中心

## Project22 iBeacon裝置距離偵測
1. 利用CoreLocation實作，以requestAlwaysAuthorization請求User手機位置權限
2. 利用CLLocationManagerDelegate接收位置權限狀態改變事件 
3. 設定App要搜索iBeacon的CLBeaconRegion，UUID, Major與Minor
4. 根據didRangeBeacons收到的距離參數，動畫改變也面顏色與標題

## Project23 Swifty Ninja切水果小遊戲
1. 使用SpriteKit設計遊戲
2. 使用SKShapeNode繪製玩家劃過的刀光
3. 利用touchesBegan、touchesMoved與touchesEnded繪製玩家刀光
4. 設計遊戲投擲樣式(SequenceType)與「是否必投擲炸彈」(ForceBomb)的enum
5. 使用AVFoundation的AVAudioPlayer播放炸彈引線音效，並空停止播放時機
6. 設計遊戲中實體物品(physicsBody)被丟直出來的速度(velocity)與角速度(angularVelocity)
7. 利用DispatchQueue.main.asyncAfter設計延遲時間後再執行某closure
8. 使用SKAction.fadeOut設計刀光淡出動畫

## Project24 Swift字串操作
1. hasPrefix與hasSuffix判斷
2. 設計可刪除特定自首或字尾的extension函式
3. capitalized將字串內字母改為大寫
4. string.contains() 判斷是否包含某字串
5. NSAttributedString設計字體樣式，在同一字串中設定不同字體

## Project25 Selfie Share-鄰近iOS裝置圖片分享
1. 使用MultipeerConnectivity
2. 設計app創建與加入一個Session
3. 使用MCSessionDelegate與MCBrowserViewControllerDelegater接收MC相關事件
4. 使用imagePicker選擇相簿照片
5. 使用CollectionView設計照片放置區
6. 使用NSLayoutConstraint設計View的AutoLayout

## Project26

## Project27
## Project28
## Project29
## Project30
