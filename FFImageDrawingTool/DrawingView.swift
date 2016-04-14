//
//  DrawingView.swift
//  FFImageDrawingTool
//
//  Created by feialoh on 10/02/16.
//  Copyright © 2016 Cabot. All rights reserved.
//

import UIKit


enum DrawingMode:Int{
    case None = 0,
    Paint,
    Erase
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
    
    
    override func drawRect(rect: CGRect) {
        
        self.viewImage.drawInRect(self.bounds)
    }
    
      
    
    /*===============================================================================*/
    // MARK: - Helper methods
    /*===============================================================================*/
    
    func initialize()
    {
        currentPoint = CGPointMake(0, 0)
        previousPoint = currentPoint
        
        self.drawingMode = DrawingMode.None
        
        self.selectedColor = UIColor.blackColor()
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
        self.viewImage.drawInRect(self.bounds)
        
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Clear)
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Clear)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint!.x, previousPoint!.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint!.x, currentPoint!.y)
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        previousPoint = currentPoint;
        
        setNeedsDisplay()
    }
    
    //To draw the line
    func drawLineNew()
    {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.viewImage.drawInRect(self.bounds)
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round);
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor!.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint!.x, previousPoint!.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint!.x, currentPoint!.y)
        
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        previousPoint = currentPoint
        
        setNeedsDisplay()
    }
    
    //To handle touch events
    func handleTouches()
    {
        if (self.drawingMode == DrawingMode.None) {
            // do nothing
        }
        else if (self.drawingMode == DrawingMode.Paint) {
           drawLineNew()
        }
        else
        {
           eraseLine()
        }
    }
    
    //To save the new image
    func saveImage(mainView:UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(mainView.layer.frame.size, false, 0.0);
        mainView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        for items in textFieldArray{
            mainView.addSubview(items)
        }
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return myImage

    }
    
    //To add a new textView
    
    func addTextView()
    {
        let fieldFrame = CGRectMake(self.center.x, self.center.y, 75, 20)
        newView.frame = fieldFrame
        newView.backgroundColor = UIColor.whiteColor()
        self.addSubview(newView)
        self.bringSubviewToFront(newView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DrawingView.textFieldMoved(_:)))
        pan.delegate = self
        pan.view?.backgroundColor = UIColor.blueColor()
        newView.addGestureRecognizer(pan)
    }
    
    func removeTextView()
    {
        if selectedTextView != nil{
            
            selectedTextView!.removeFromSuperview()
            if let viewIndex = textFieldArray.indexOf(selectedTextView!){
                textFieldArray.removeAtIndex(viewIndex)
            }
        }
    }
    
    /*===============================================================================*/
    // MARK: - Touches methods
    /*===============================================================================*/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if let touch = (touches.first)  {
            previousPoint = touch.locationInView(self)
        }

        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            currentPoint = touch.locationInView(self)
            handleTouches()
        }
        
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            currentPoint = touch.locationInView(self)
            handleTouches()
        }
        
        
    }
    
    /*===============================================================================*/
    // MARK: - Textfield delegate methods
    /*===============================================================================*/
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        selectedTextView = textView
    }
    
    func textViewDidChange(textView: UITextView) {
        var newFrame = textView.frame
        newFrame.size.height = textView.contentSize.height < self.frame.height/8 ? textView.contentSize.height : self.frame.height/8
        textView.frame = newFrame
    }
    
    func textFieldMoved(sender: UIPanGestureRecognizer){
        
        switch sender.state {
            
        case UIGestureRecognizerState.Began :
            
            break
            
        case UIGestureRecognizerState.Changed :
            
            let point = sender.locationInView(self)
            newView.center = point
            break
            
        case UIGestureRecognizerState.Ended :
            
            let point = sender.locationInView(self)
            newView.center = point
            let newField = UITextView(frame: newView.frame)
            newField.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2)
            newField.layer.cornerRadius = 3
            newField.layer.borderWidth = 0.5
            newField.backgroundColor = UIColor.clearColor()
            newField.delegate = self
            self.addSubview(newField)
            textFieldArray.append(newField)
            self.bringSubviewToFront(newField)
            newView.removeFromSuperview()
            
            break
            
        default :
            
            break
            
        }
    }

}
