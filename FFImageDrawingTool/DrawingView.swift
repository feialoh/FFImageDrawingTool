//
//  DrawingView.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 10/02/16.
//  Copyright © 2016 Feialoh Francis. All rights reserved.
//

import UIKit


enum DrawingMode:Int{
    case none = 0,
    paint,
    erase
}

class DrawingView: UIView,UIGestureRecognizerDelegate, UITextViewDelegate {
    
    var previousPoint:CGPoint?
    var currentPoint:CGPoint?
    var selectedColor:UIColor?
    var drawingMode:DrawingMode?
    var viewImage=UIImage()
    var lineWidth: CGFloat = 1.0
    var newView = UIView()
    var textFieldArray = [UITextView]()
    var selectedTextView:UITextView?
    
    override func awakeFromNib() {
        initialize()
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        self.viewImage.draw(in: self.bounds)
    }
    
      
    
    /*===============================================================================*/
    // MARK: - Helper methods
    /*===============================================================================*/
    
    func initialize()
    {
        currentPoint = CGPoint(x: 0, y: 0)
        previousPoint = currentPoint
        
        self.drawingMode = DrawingMode.none
        
        self.selectedColor = UIColor.black
    }
    
    //To clear the line drawn
    func reset()
    {
        self.viewImage = UIImage()
        setNeedsDisplay()
        
    }
    
    //To erase the line drawn
    func eraseLine()
    {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.viewImage.draw(in: self.bounds)
        
        UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.clear)
        
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineWidth)
        UIGraphicsGetCurrentContext()?.beginPath()
        UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.clear)
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: previousPoint!.x, y: previousPoint!.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint!.x, y: currentPoint!.y))
        
        UIGraphicsGetCurrentContext()?.strokePath();
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        previousPoint = currentPoint;
        
        setNeedsDisplay()
    }
    
    //To draw the line
    func drawLineNew()
    {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.viewImage.draw(in: self.bounds)
        
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round);
        UIGraphicsGetCurrentContext()?.setStrokeColor(self.selectedColor!.cgColor)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineWidth);
        UIGraphicsGetCurrentContext()?.beginPath();
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: previousPoint!.x, y: previousPoint!.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint!.x, y: currentPoint!.y))
        
        UIGraphicsGetCurrentContext()?.strokePath()
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        previousPoint = currentPoint
        
        setNeedsDisplay()
    }
    
    //To handle touch events
    func handleTouches()
    {
        if (self.drawingMode == DrawingMode.none) {
            // do nothing
        }
        else if (self.drawingMode == DrawingMode.paint) {
           drawLineNew()
        }
        else
        {
           eraseLine()
        }
    }
    
    //To save the new image
    func saveImage(_ mainView:UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(mainView.layer.frame.size, false, 0.0);
        mainView.layer.render(in: UIGraphicsGetCurrentContext()!)
        for items in textFieldArray{
            mainView.addSubview(items)
        }
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return myImage!

    }
    
    //To add a new textView
    
    func addTextView()
    {
        let fieldFrame = CGRect(x: self.center.x, y: self.center.y, width: 75, height: 20)
        newView.frame = fieldFrame
        newView.backgroundColor = UIColor.white
        self.addSubview(newView)
        self.bringSubview(toFront: newView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DrawingView.textFieldMoved(_:)))
        pan.delegate = self
        pan.view?.backgroundColor = UIColor.blue
        newView.addGestureRecognizer(pan)
    }
    
    func removeTextView()
    {
        if selectedTextView != nil{
            
            selectedTextView!.removeFromSuperview()
            if let viewIndex = textFieldArray.index(of: selectedTextView!){
                textFieldArray.remove(at: viewIndex)
            }
        }
    }
    
    /*===============================================================================*/
    // MARK: - Touches methods
    /*===============================================================================*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = (touches.first)  {
            previousPoint = touch.location(in: self)
        }

        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            currentPoint = touch.location(in: self)
            handleTouches()
        }
        
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            currentPoint = touch.location(in: self)
            handleTouches()
        }
        
        
    }
    
    /*===============================================================================*/
    // MARK: - Textfield delegate methods
    /*===============================================================================*/
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectedTextView = textView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var newFrame = textView.frame
        newFrame.size.height = textView.contentSize.height < self.frame.height/8 ? textView.contentSize.height : self.frame.height/8
        textView.frame = newFrame
    }
    
    func textFieldMoved(_ sender: UIPanGestureRecognizer){
        
        switch sender.state {
            
        case UIGestureRecognizerState.began :
            
            break
            
        case UIGestureRecognizerState.changed :
            
            let point = sender.location(in: self)
            newView.center = point
            break
            
        case UIGestureRecognizerState.ended :
            
            let point = sender.location(in: self)
            newView.center = point
            let newField = UITextView(frame: newView.frame)
            newField.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2)
            newField.layer.cornerRadius = 3
            newField.layer.borderWidth = 0.5
            newField.backgroundColor = UIColor.clear
            newField.delegate = self
            self.addSubview(newField)
            textFieldArray.append(newField)
            self.bringSubview(toFront: newField)
            newView.removeFromSuperview()
            
            break
            
        default :
            
            break
            
        }
    }

}
