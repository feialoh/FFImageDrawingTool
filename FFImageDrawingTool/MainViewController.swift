//
//  MainViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 31/03/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,ImageSelectorDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var imageContainerScrollView: UIScrollView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imageContainerScrollView.minimumZoomScale = 1.0
        imageContainerScrollView.maximumZoomScale = 2.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func imagePickerAction(sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

    
    

    /*===============================================================================*/
    // MARK: - Image picker helper methods
    /*===============================================================================*/
    
    //To open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
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
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    /*===============================================================================*/
    // MARK: - Custom Image view delegate methods
    /*===============================================================================*/
    
    func selectedWithImage(chosenImage: UIImage, parent: AnyObject) {
        
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

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return selectedImage
    }
    
    /*===============================================================================*/
    // MARK: - UIImagePickerControllerDelegate
    /*===============================================================================*/
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            
        })
        
        let imageView = self.storyboard?.instantiateViewControllerWithIdentifier("ImageView") as! ImageViewController
        
        imageView.delegate = self
        
        imageView.selectedImage = chosenImage
        
        imageView.viewType = "Picker"
        
        self.presentViewController(imageView, animated: true, completion: nil)
    }

}
