//
//  JDMailBoxComponent.swift
//  JDMailBox
//
//  Created by 郭介騵 on 2017/5/15.
//  Copyright © 2017年 james12345. All rights reserved.
//

import UIKit

class JDEnvelope: UIView {
    
    var bottmPaperView:UIView = UIView()
    var upperPaperView:UIView = UIView()
    var sealPaperView:UIView = UIView()
    var LeftsealimgView:UIImageView = UIImageView()
    var RightsealimgView:UIImageView = UIImageView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        bottmPaperView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        self.addSubview(bottmPaperView)
        upperPaperView = UIView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        self.addSubview(upperPaperView)
        let sealsize = CGSize(width: self.frame.width / 2 + 30, height: self.frame.height)
        sealPaperView = UIView(frame: CGRect(origin: CGPoint.zero, size: sealsize))
        initBottomView()
        initUpperView()
        initsealView()
    }
    
    func initBottomView()
    {
        //
        let Frame = bottmPaperView.frame
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: Frame.midX, y: Frame.midY))
        path.addLine(to: CGPoint(x: 0, y: Frame.maxY))
        path.addLine(to: CGPoint(x: Frame.maxX, y: Frame.maxY))
        path.addLine(to: CGPoint(x: Frame.maxX, y: 0))
        path.addLine(to: CGPoint.zero)
        
       let layer = createPapaerLayer(path: path.cgPath)
        // add the new layer to our custom view
        bottmPaperView.layer.addSublayer(layer)
    }
    
    func initUpperView()
    {
        let Frame = upperPaperView.frame
        let path = UIBezierPath()
        path.move(to: CGPoint(x: Frame.maxX, y: 0))
        path.addLine(to: CGPoint(x: Frame.midX - 20, y: Frame.midY - 20))
        path.addQuadCurve(to: CGPoint(x: Frame.midX - 20, y: Frame.midY + 20), controlPoint: CGPoint(x: Frame.midX - 30, y: Frame.midY))
        path.addLine(to: CGPoint(x: Frame.maxX, y: Frame.maxY))
        path.addLine(to: CGPoint(x: Frame.maxX, y: 0))
        let layer = createPapaerLayer(path: path.cgPath)
        // add the new layer to our custom view
        upperPaperView.layer.addSublayer(layer)
    }
    
    func initsealView()
    {
        sealPaperView.backgroundColor = UIColor.clear
        let Frame = sealPaperView.frame
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: Frame.maxX - 10, y: Frame.midY - 20))
        path.addQuadCurve(to: CGPoint(x: Frame.maxX - 10, y: Frame.midY + 20), controlPoint: CGPoint(x: Frame.maxX, y: Frame.midY))
        path.addLine(to: CGPoint(x: 0, y: Frame.maxY))
        path.addLine(to: CGPoint.zero)
        let layer = createPapaerLayer(path: path.cgPath)
        sealPaperView.layer.backgroundColor = UIColor.clear.cgColor
        sealPaperView.layer.addSublayer(layer)
        //
        func ViewToImage()->UIImage?
        {
            UIGraphicsBeginImageContextWithOptions(sealPaperView.bounds.size, false, 0)
            let sucess = sealPaperView.drawHierarchy(in: sealPaperView.bounds, afterScreenUpdates: true)
            if(sucess)
            {
                let image = UIGraphicsGetImageFromCurrentImageContext()
                return image
            }
            UIGraphicsEndImageContext()
            return nil
        }
        if let sealUIImage = ViewToImage()
        {
            LeftsealimgView = UIImageView(image: sealUIImage)
            LeftsealimgView.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.5, height: 1)
            LeftsealimgView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            LeftsealimgView.frame = CGRect(x: 0, y: 0, width: Frame.width / 2 , height: Frame.height)
            self.addSubview(LeftsealimgView)
            RightsealimgView = UIImageView(image: sealUIImage)
            RightsealimgView.layer.contentsRect = CGRect(x: 0.5, y: 0, width: 0.5, height: 1)
            RightsealimgView.layer.anchorPoint = CGPoint(x: -0.5, y: 0.5)
            RightsealimgView.frame = CGRect(x: 0, y: 0, width: Frame.width / 2 , height: Frame.height)
            self.addSubview(RightsealimgView)
        }
        var filpUp:CATransform3D = CATransform3DMakeRotation(-CGFloat(Double.pi * 0.5), 0, 1, 0)
        filpUp.m34 = -1 / 1000.0
        LeftsealimgView.layer.transform = filpUp
        RightsealimgView.layer.transform = filpUp
    }
    
    func createPapaerLayer(path:CGPath)->CAShapeLayer
    {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        // add the new layer to our custom view
        return shapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JDMailSignatureLabel:UILabel
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        self.textAlignment = .center
        self.lineBreakMode = .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 30.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JDEnvelopImage:UIImageView
{
    var shadowLayer:CAGradientLayer = CAGradientLayer()
    init(image: UIImage?,isDown:Bool,frame:CGRect,size:CGSize) {
        super.init(image: image)
        if(isDown)
        {
            self.layer.contentsRect = CGRect(x: 0, y: 0.5, width: 1, height: 0.5)
            self.frame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height/2), size: size)
            self.layer.masksToBounds = true
            //containerView.addSubview(downimg!)
            shadowLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
            shadowLayer.frame = CGRect(origin: CGPoint.zero, size: (self.frame.size))
            shadowLayer.opacity = 0
            self.layer.addSublayer(shadowLayer)
        }
        else
        {
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            self.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 0.5)
            self.frame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y), size: size)
            self.layer.masksToBounds = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






























