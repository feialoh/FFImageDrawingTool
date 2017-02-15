//
//  ColorPickerViewController.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 30/03/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//

import UIKit


protocol ColorPickerDelegate : class{
    func selectedWithColor (_ chosenColor:UIColor)
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
        horizontalColorPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.color
        
        horizontalSaturationPicker.delegate = self
        horizontalSaturationPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        horizontalSaturationPicker.type = SwiftHUEColorPicker.PickerType.saturation
        
        horizontalBrightnessPicker.delegate = self
        horizontalBrightnessPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        horizontalBrightnessPicker.type = SwiftHUEColorPicker.PickerType.brightness
        
        horizontalAlphaPicker.delegate = self
        horizontalAlphaPicker.direction = SwiftHUEColorPicker.PickerDirection.horizontal
        horizontalAlphaPicker.type = SwiftHUEColorPicker.PickerType.alpha
        
        colorView.backgroundColor = selectedColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        delegate.selectedWithColor(colorView.backgroundColor!)
    }
    
    
    // MARK: - SwiftHUEColorPickerDelegate
    
    func valuePicked(_ color: UIColor, type: SwiftHUEColorPicker.PickerType) {
        colorView.backgroundColor = color
        
        switch type {
        case SwiftHUEColorPicker.PickerType.color:
            horizontalSaturationPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.saturation:
            horizontalColorPicker.currentColor = color
            horizontalBrightnessPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.brightness:
            horizontalColorPicker.currentColor = color
            horizontalSaturationPicker.currentColor = color
            horizontalAlphaPicker.currentColor = color
            break
        case SwiftHUEColorPicker.PickerType.alpha:
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
