//
//  ViewController.swift
//  Project25
//
//  Created by 曲奕帆 on 2022/10/31.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController,
                      UINavigationControllerDelegate, // imagePicker所需,
                      UIImagePickerControllerDelegate, // imagePicer所需
                      MCSessionDelegate, // 建立MCSession所需
                      MCBrowserViewControllerDelegate // 建立MCBrowserViewController所需
{
    // 存放User選擇的照片或其他會議中裝置傳進來的照片
    var images = [UIImage]()
    
    /** multipeer房間的相關編號
     *將於viewDidLoad中實體化。
     */
    var peerID: MCPeerID!
    var mcSession: MCSession!
    // 將用於創建新的Session時，在網路上廣播自己
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        // 右上新增圖片按鈕
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        // 左上新增加入或新創Session按鈕
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        // displayName指的是在其他裝置上會顯示我的名稱
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
    }
    
    // 讓User新創或加入Session的Alert
    @objc func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // 新創一個Session
    @objc func startHosting(action: UIAlertAction){
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    // 加入一個Session
    @objc func joinSession(action: UIAlertAction){
        let mcBrowser = MCBrowserViewController(serviceType: "hws", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // numberOfItemsInSection設定Cell的數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // 設定Cell的內容
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = images[indexPath.item]
        cell.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            cell.widthAnchor.constraint(equalToConstant: 145),
            cell.heightAnchor.constraint(equalToConstant: 145),
            imageView.widthAnchor.constraint(equalToConstant: 145),
            imageView.heightAnchor.constraint(equalToConstant: 145)
        ])
        
        return cell
    }
    
    // 使用imagePicker選擇相片
    @objc func importPicture(){
        // 顯示imagePicker
        let picker = UIImagePickerController()
        // 允許User編輯照片
        picker.allowsEditing = true
        // 本類別以指定為UINavigationControllerDelegate與UIImagePickerControllerDelegate
        picker.delegate = self
        present(picker, animated: true)
    }

    // User選擇完圖片後觸發
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        // 關閉imagePicker
        dismiss(animated: true)
        
        // 從頭加入images陣列
        images.insert(image, at: 0)
        
        /** 開始將圖片推給其他連線中的peer
         */
        guard let mcSession = mcSession else { return }
        // 確認目前有人是與我連線中的
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData(){
                do{
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 若傳送發生問題，彈出Alert
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    /** MCSessionDelegate有五個required的function。
     * 此處我們只使用到didChange與didReceive。
     */
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    // 連線狀態有改變時didChange會被呼叫
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    // didReceive將在 當有成員開啟一個byte stream connection穿送檔案來時被呼叫
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // 將接收到的圖片，在main thread推進UI中
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    /** browserViewControllerDidFinish與browserViewControllerWasCancelled
     * 為MCBrowserViewControllerDelegate所需function。
     */
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

}

