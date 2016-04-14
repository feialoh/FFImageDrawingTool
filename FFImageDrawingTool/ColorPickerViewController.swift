//
//  ColorPickerViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 30/03/16.
//  Copyright © 2016 Cabot. All rights reserved.
//

import UIKit


protocol ColorPickerDelegate : class{
    func selectedWithColor (chosenColor:UIColor)
}

class ColorPickerViewController: UIViewController,SwiftHUEColorPickerDelegate {
    
    
    var delegate:ColorPickerDelegate!
    
    var selectedColor:UIColor!
    
    @IBOutlet weak var colorView: UIView!
    
    // MARK: - Horizontal pickers
    
    @IBOutlet weak var horizontalColorPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalSaturationPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalBrightnessPicker: SwiftHUEColorPicker!
    @IBOutlet weak var horizontalAlphaPicker: SwiftHUEColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        horizontalColorPicker.delegate = self
        horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Color
        
        horizontalSaturationPicker.delegate = self
        horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.Saturation
        
        horizontalBrightnessPicker.delegate = self
        horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.Brightness
        
        horizontalAlphaPicker.delegate = self
        horizontalAlphaPicker.direction = SwiftHUEColorPicker.PickerDirection.Horizontal
        horizontalAlphaPicker.type = SwiftHUEColorPicker.PickerType.Alpha
        
        colorView.backgroundColor = selectedColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        delegate.selectedWithColor(colorView.backgroundColor!)
    }
    
    
    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        colorView.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.Color:
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.Saturation:
            horizontalColorPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.Brightness:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.Alpha:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
