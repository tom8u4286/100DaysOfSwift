本專案夾存放2022年練習100 Days of Swift的30個練習Project。以下介紹各Project的練習重點。

## Project1 Storm Viewer TableView相片檢視
1. TableViewController 練習使用TableViewController，並設定numberOfRowsInSection與cellForRowAt。
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

## Project15

## Project16

## Project17
## Project18
## Project19
## Project20
## Project21
## Project22
## Project23
## Project24
## Project25
## Project26
## Project27
## Project28
## Project29
## Project30
