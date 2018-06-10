//
//  ImageVC.swift
//  
//
//  Created by Local Account 436-05 on 6/9/18.
//

import UIKit
import Firebase

class ImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    lazy var vision = Vision.vision()
    var textDetector : VisionTextDetector?
    var imagePicker : UIImagePickerController?
    var parsed = [VisionText]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDetector = vision.textDetector()
        
        photoLibrary()

    }
    
    @IBAction func donePressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "unwindFromCamera") {
            let destinationVC = segue.destination as! MainTVC
            destinationVC.parsed = self.parsed
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func photoLibrary(){
        
        print("In photoLibrary")
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            self.imagePicker = UIImagePickerController()
            self.imagePicker?.delegate = self
            self.imagePicker?.sourceType = .photoLibrary
            self.present((self.imagePicker)!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let image = VisionImage(image: pickedImage)
            
            textDetector?.detect(in: image) { (features, error) in
                guard error == nil, let features = features, !features.isEmpty else {
                    // Error. You should also check the console for error messages.
                    // ...
                    return
                }
                
                // Recognized and extracted text
                print("Detected text has: \(features.count) blocks")
                
                self.parsed = features
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
