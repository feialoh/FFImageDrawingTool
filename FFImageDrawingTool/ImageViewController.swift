//
//  ImageViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 31/03/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//
import UIKit

protocol ImageSelectorDelegate : class{
    func selectedWithImage (chosenImage:UIImage,parent:AnyObject)
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
        
        imageEditorToolView.hidden = viewType == "Show"
        drawerView.hidden = viewType == "Show"
        
        drawerView.selectedColor = UIColor.whiteColor()
        drawerView.drawingMode = DrawingMode.Paint
        drawerView.lineWidth = CGFloat(brushWidthSlider.value)
        segmentControl.selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImageViewController.deviceRotatedInImageView), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController as! ColorPickerViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.delegate = self
            popoverViewController.selectedColor = drawerView.selectedColor
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    //Device Rotated
    
    func deviceRotatedInImageView()
    {
        drawerView.setNeedsDisplay()
        
    }
    
    /*===============================================================================*/
    // MARK: - ColorPickerDelegate Actions
    /*===============================================================================*/
    
    
    func selectedWithColor(chosenColor: UIColor) {
        
        drawerView.selectedColor = chosenColor
        colorPickerButton.backgroundColor = chosenColor
    }
    
    /*===============================================================================*/
    // MARK: - Button Actions
    /*===============================================================================*/

    
    //Done/Save button
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if viewType == "Picker"
        {
            imageContainerScrollView.scrollEnabled = false
            imageContainerScrollView.zoomScale = 1
            chatImageView.image = drawerView.saveImage(mainImageView)
            delegate.selectedWithImage(chatImageView.image!, parent: self)
        }
    }
    
    
    @IBAction func removeTextFieldAction(sender: UIButton) {
        
        drawerView.removeTextView()
    }
    
    
    
    //Drawing action buttons
    
    @IBAction func toolSegmentControlAction(sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex)
        {
            case 0 :        //Draw
                
                    drawerView.drawingMode = DrawingMode.Paint
                    imageContainerScrollView.scrollEnabled = false
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 1.0
                    break
            
            case 1 :        //Erase
                    drawerView.drawingMode = DrawingMode.Erase
                    imageContainerScrollView.scrollEnabled = false
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 1.0
                    break
            
            case 2 :        //Reset
                    drawerView.reset()
                    drawerView.drawingMode = DrawingMode.Paint
                    imageContainerScrollView.scrollEnabled = false
                    imageContainerScrollView.zoomScale = 1
                    sender.selectedSegmentIndex = 0
                    break
            
            case 3 :        //Zoom
                    drawerView.drawingMode = DrawingMode.Paint
                    imageContainerScrollView.minimumZoomScale = 1.0
                    imageContainerScrollView.maximumZoomScale = 2.0
                    imageContainerScrollView.scrollEnabled = true
                    break
            
            case 4 :    //Text
                    drawerView.addTextView()
                    drawerView.drawingMode = DrawingMode.None
                    
            default :
                    break
        }
        
    }
    
    //Brush/Eraser slider action
    
    @IBAction func sliderChanged(sender: UISlider) {
            drawerView.lineWidth = CGFloat(sender.value)
        
    }
    
    
    
    //ColorPicker Action
    
    @IBAction func colorPickerAction(sender: UIButton) {
        
    }
    

}
