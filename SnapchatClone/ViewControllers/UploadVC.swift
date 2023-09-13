//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        uploadImageView.addGestureRecognizer(imageTapRecognizer)
    }
    @objc func tapImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder =  storageReferance.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpeg")
            
            imageReferance.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            let imageUrl =  url?.absoluteString
                            
                            
                            // FireStore
                            
                            let fireStore = Firestore.firestore()
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username)
                                .getDocuments { snapshot, error in
                                    if error != nil {
                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    } else {
                                        if snapshot?.isEmpty == false && snapshot != nil {
                                            for document in snapshot!.documents {
                                                let documentId = document.documentID
                                                
                                                if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                    imageUrlArray.append(imageUrl!)
                                                    
                                                    let additionalDictionary =  ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                    
                                                    fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                        if error == nil {
                                                            self.tabBarController?.selectedIndex = 0
                                                            self.uploadImageView.image = UIImage(named: "SelectImage")
                                                        }else {
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            let snapDict = ["imageUrlArray" : [imageUrl!] , "snapOwner" : UserSingleton.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String : Any]
                                            fireStore.collection("Snaps").addDocument(data: snapDict) { error in
                                                if error != nil {
                                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                } else {
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.uploadImageView.image = UIImage(named: "SelectImage")
                                                }
                                            }
                                        }
                                    }
                                }
                            
                        }
                    }
                }
            }
        }
        
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }

    

}
