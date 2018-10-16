//
//  MainViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 31/03/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,ImageSelectorDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate  {

    
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var imageContainerScrollView: UIScrollView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imageContainerScrollView.minimumZoomScale = 1.0
        imageContainerScrollView.maximumZoomScale = 2.0
        imageContainerScrollView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func imagePickerAction(_ sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            {
                UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    
    

    /*===============================================================================*/
    // MARK: - Image picker helper methods
    /*===============================================================================*/
    
    //To open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertView(title: "Camera is unavailable", message: "Error", delegate: [], cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    //To open photo library
    func openLibrary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*===============================================================================*/
    // MARK: - Custom Image view delegate methods
    /*===============================================================================*/
    
    func selectedWithImage(_ chosenImage: UIImage, parent: AnyObject) {
        
        selectedImage.image = chosenImage
        imageContainerScrollView.zoomScale = 1
        imageContainerScrollView.minimumZoomScale = 1.0
        imageContainerScrollView.maximumZoomScale = 2.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImage
    }
    
    /*===============================================================================*/
    // MARK: - UIImagePickerControllerDelegate
    /*===============================================================================*/
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage //2
        
        picker.dismiss(animated: true, completion: { () -> Void in
            
            
        })
        
        let imageView = self.storyboard?.instantiateViewController(withIdentifier: "ImageView") as! ImageViewController
        
        imageView.delegate = self
        
        imageView.selectedImage = chosenImage
        
        imageView.viewType = "Picker"
        
        self.present(imageView, animated: true, completion: nil)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
