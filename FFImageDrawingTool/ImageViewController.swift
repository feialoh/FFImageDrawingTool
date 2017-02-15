//
//  ImageViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 31/03/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//
import UIKit

protocol ImageSelectorDelegate : class{
    func selectedWithImage (_ chosenImage:UIImage,parent:AnyObject)
}


class ImageViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate,ColorPickerDelegate {

    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var imageContainerScrollView: UIScrollView!
    
    @IBOutlet weak var mainImageView: UIView!
    
    @IBOutlet weak var imageEditorToolView: UIView!
    
    @IBOutlet weak var brushWidthSlider: UISlider!
    
    @IBOutlet weak var drawerView: DrawingView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    @IBOutlet weak var colorPickerButton: UIButton!
    
    var delegate : ImageSelectorDelegate!
    
    var selectedImage = UIImage()
    
    var viewType = "Show"
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        chatImageView.image = selectedImage
        
        if viewType == "Show"
        {
            imageContainerScrollView.minimumZoomScale = 1
            imageContainerScrollView.maximumZoomScale = 2
        }
        
        imageEditorToolView.isHidden = viewType == "Show"
        drawerView.isHidden = viewType == "Show"
        
        drawerView.selectedColor = UIColor.white
        drawerView.drawingMode = DrawingMode.paint
        drawerView.lineWidth = CGFloat(brushWidthSlider.value)
        segmentControl.selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.deviceRotatedInImageView), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination as! ColorPickerViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
            popoverViewController.selectedColor = drawerView.selectedColor
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    //Device Rotated
    
    func deviceRotatedInImageView()
    {
        drawerView.setNeedsDisplay()
        
    }
    
    /*===============================================================================*/
    // MARK: - ColorPickerDelegate Actions
    /*===============================================================================*/
    
    
    func selectedWithColor(_ chosenColor: UIColor) {
        
        drawerView.selectedColor = chosenColor
        colorPickerButton.backgroundColor = chosenColor
    }
    
    /*===============================================================================*/
    // MARK: - Button Actions
    /*===============================================================================*/

    
    //Done/Save button
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        if viewType == "Picker"
        {
            imageContainerScrollView.isScrollEnabled = false
            imageContainerScrollView.zoomScale = 1
            chatImageView.image = drawerView.saveImage(mainImageView)
            delegate.selectedWithImage(chatImageView.image!, parent: self)
        }
    }
    
    
    @IBAction func removeTextFieldAction(_ sender: UIButton) {
        
        drawerView.removeTextView()
    }
    
    
    
    //Drawing action buttons
    
    @IBAction func toolSegmentControlAction(_ sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex)
        {
            case 0 :        //Draw
                
                    drawerView.drawingMode = DrawingMode.paint
                    imageContainerScrollView.isScrollEnabled = false
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 1.0
                    break
            
            case 1 :        //Erase
                    drawerView.drawingMode = DrawingMode.erase
                    imageContainerScrollView.isScrollEnabled = false
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 1.0
                    break
            
            case 2 :        //Reset
                    drawerView.reset()
                    drawerView.drawingMode = DrawingMode.paint
                    imageContainerScrollView.isScrollEnabled = false
                    imageContainerScrollView.zoomScale = 1
                    sender.selectedSegmentIndex = 0
                    break
            
            case 3 :        //Zoom
                    drawerView.drawingMode = DrawingMode.paint
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 2.0
                    imageContainerScrollView.isScrollEnabled = true
                    break
            
            case 4 :    //Text
                    drawerView.addTextView()
                    drawerView.drawingMode = DrawingMode.none
                    
            default :
                    break
        }
        
    }
    
    //Brush/Eraser slider action
    
    @IBAction func sliderChanged(_ sender: UISlider) {
            drawerView.lineWidth = CGFloat(sender.value)
        
    }
    
    
    
    //ColorPicker Action
    
    @IBAction func colorPickerAction(_ sender: UIButton) {
        
    }
    
    
    func addTextViews()  {
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ImageViewController.userDragged(_:)))
        let bottomTextField = UITextField(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
        bottomTextField.layer.borderColor = UIColor.blue.cgColor
        bottomTextField.layer.borderWidth = 1.0
        bottomTextField.addGestureRecognizer(gesture)
        bottomTextField.isUserInteractionEnabled = true
        
        bottomTextField.text = "Enter your text here"
        self.view.addSubview(bottomTextField)
    }
    
    func userDragged(_ gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        
        if ((gesture.view?.isKind(of: UITextField.self)) != nil)
        {
            gesture.view!.center = loc
        }
        
        
    }

}
