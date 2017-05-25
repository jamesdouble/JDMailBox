//
//  JDMailBoxTransition.swift
//  JDMailBox
//
//  Created by 郭介騵 on 2017/5/13.
//  Copyright © 2017年 james12345. All rights reserved.
//

import UIKit

extension JDMailBoxComposeVC:UIViewControllerTransitioningDelegate
{
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        print(#function)
        let jdmailboxpresentanimation:JDMailBoxPresentAnimationController = JDMailBoxPresentAnimationController()
        jdmailboxpresentanimation.originFrame = self.view.frame
        jdmailboxpresentanimation.UserDefinedText = getUserDefinedText()
       // jdmailboxpresentanimation.isCancel = self.isCancel
        return jdmailboxpresentanimation
    }
    
}


class JDMailBoxPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var originFrame:CGRect = CGRect()
    fileprivate var UserDefinedText:String?
    fileprivate var isCancel:Bool = false
    private let Envelopeduration = 8.0
    private let FoldDuration = 6.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return Envelopeduration + FoldDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        print(#function)
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
        var isCancel:Bool = false
        if let mailVC:JDMailBoxComposeVC = fromVC as? JDMailBoxComposeVC
        {
            isCancel = mailVC.isCancel
        }
        if(isCancel)
        {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        //
        let toVCView = toVC.view
        toVCView?.alpha = 0
        let containerView = transitionContext.containerView
        containerView.addSubview(toVCView!)
        /**
            1 Envelope
        **/
       
        let envelopeStartFrame = CGRect(origin: CGPoint(x: originFrame.width, y: 0), size: originFrame.size)
        let EnvelopeView = JDEnvelope(frame: envelopeStartFrame)
        containerView.addSubview(EnvelopeView)
        
        UIView.animateKeyframes(withDuration: Envelopeduration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5, animations: {
                EnvelopeView.frame = self.originFrame
            })
            // Put mail in Envelope
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1.9/5, animations: {
                EnvelopeView.RightsealimgView.frame = CGRect(x: EnvelopeView.sealPaperView.frame.width / 2, y: 0, width: EnvelopeView.sealPaperView.frame.width / 2 , height: EnvelopeView.sealPaperView.frame.height)
            })
            // Sealing
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 3/5, animations: {
                EnvelopeView.LeftsealimgView.layer.transform = CATransform3DIdentity
            })
            UIView.addKeyframe(withRelativeStartTime: 1.5/5, relativeDuration: 3/5, animations: {
                EnvelopeView.RightsealimgView.layer.transform = CATransform3DIdentity
            })
            // Scale
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                EnvelopeView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                fromVC.view.alpha = 0
            })
        })
        { (_) in
            var UpperEnvelopImg:UIImageView?
            var UpperEnvelopCoverImg:UIImageView?
            var BottomEnvelopImg:JDEnvelopImage?
            // TypeText
            let TextFreeEnvelopeImg:UIImage? = self.ViewToImage(view: EnvelopeView,update: true)
            func TypeTextOnMail()
            {
                guard let TheText = self.UserDefinedText else {
                    cutImageToTwo()
                    return
                }
                let LeftFrame:CGRect = EnvelopeView.LeftsealimgView.frame
                let Frame:CGRect = CGRect(x: LeftFrame.width / 2 - LeftFrame.height/2 , y: LeftFrame.height / 2 - LeftFrame.width / 2, width: LeftFrame.height, height: LeftFrame.width)
                let signatureLabel:UILabel = JDMailSignatureLabel(frame: Frame)
                EnvelopeView.addSubview(signatureLabel)
                let charecterTime:Double = 3.0 / Double(TheText.characters.count)
                DispatchQueue.main.async {
                    signatureLabel.text = ""
                    for (index, character) in TheText.characters.enumerated() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + charecterTime * Double(index)) {
                            signatureLabel.text = (signatureLabel.text!) + String(character)
                            if(index == TheText.characters.count - 1 )
                            {
                               cutImageToTwo()
                            }
                        }
                    }
                }
            }
            TypeTextOnMail()
            // Cut EnvelopeImg into two
            func cutImageToTwo()
            {
                guard let TextedEnvelopeImg:UIImage = self.ViewToImage(view: EnvelopeView,update: true)
                    else {
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        return
                }
                let EnvelopeFrame:CGRect = EnvelopeView.frame
                let PieceSize:CGSize = CGSize(width: EnvelopeFrame.width, height: EnvelopeFrame.height/2)
                BottomEnvelopImg = JDEnvelopImage(image: TextedEnvelopeImg, isDown: true, frame: EnvelopeFrame, size: PieceSize)
                containerView.addSubview(BottomEnvelopImg!)
                UpperEnvelopCoverImg = JDEnvelopImage(image: TextFreeEnvelopeImg, isDown: false, frame: EnvelopeFrame, size: PieceSize)
                containerView.addSubview(UpperEnvelopCoverImg!)
                UpperEnvelopImg = JDEnvelopImage(image: TextedEnvelopeImg, isDown: false, frame: EnvelopeFrame, size: PieceSize)
                containerView.addSubview(UpperEnvelopImg!)
                EnvelopeView.isHidden = true
                foldMail()
            }
            /**
             2 Fold the mail
             **/
            func foldMail()
            {
                guard let up = UpperEnvelopImg,let up2 = UpperEnvelopCoverImg,let down = BottomEnvelopImg else {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    return
                }
               
                let flash = CABasicAnimation(keyPath: "opacity")
                flash.fromValue = 0.0
                flash.toValue = 1.0
                flash.duration = self.FoldDuration
                down.shadowLayer.add(flash, forKey: nil)
                UIView.animateKeyframes(withDuration: self.FoldDuration * 5/6, delay: 0.0, options: .calculationModeLinear, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                        up.layer.transform = self.config3DTransformWithRotateAngle(angle: -150, y: -up.frame.height / 4)
                        up2.layer.transform = self.config3DTransformWithRotateAngle(angle: -150, y: -up.frame.height / 4)
                        down.layer.transform = self.config3DTransformWithRotateAngle(angle: 0, y: -up.frame.height / 4)
                    })
                }){ (_) in
                    UpperEnvelopImg!.removeFromSuperview()
                    containerView.bringSubview(toFront: UpperEnvelopCoverImg!)
                    foldMailEnd()
                }
                func foldMailEnd()
                {
                    UIView.animateKeyframes(withDuration: self.FoldDuration * 1/6, delay: 0.0, options: .calculationModeLinear, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                            up2.layer.transform = self.config3DTransformWithRotateAngle(angle: -180, y: -up.frame.height / 4 )
                            down.layer.transform = self.config3DTransformWithRotateAngle(angle: 0, y: -up.frame.height / 4)
                        })
                    }){ (_) in
                        BottomEnvelopImg!.removeFromSuperview()
                        sendIt()
                    }
                }
            }
            /**
             2 Send the mail
             **/
            func sendIt()
            {
                guard let cover = UpperEnvelopCoverImg
                    else
                {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    return
                }
                UIView.animate(withDuration: 3, animations: {
                    cover.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.0)
                }, completion: {    (_) in
                    UIView.animate(withDuration: 4, animations: { 
                        cover.frame.origin.y = -300
                        toVCView?.alpha = 1.0
                    }, completion: { (_) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                })
            }
            
        }
    }

    func animationEnded(_ transitionCompleted: Bool)
    {
        print(#function)
    }
}

extension JDMailBoxPresentAnimationController
{
    //refrence http://www.jianshu.com/p/4b26a1f641a3
    func config3DTransformWithRotateAngle(angle:Double,y:CGFloat)->CATransform3D
    {
        var transform = CATransform3DIdentity
        transform.m34 = -1/1000.0
        let rotateTransform = CATransform3DRotate(transform, CGFloat(Double.pi * angle / 180), 1, 0, 0)
        let moveTransform = CATransform3DMakeAffineTransform(CGAffineTransform.init(translationX: 0, y: y))
        let concatTransform = CATransform3DConcat(rotateTransform, moveTransform)
        return concatTransform
    }
    
    func ViewToImage(view:UIView,update:Bool)->UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        let sucess = view.drawHierarchy(in: view.bounds, afterScreenUpdates: update)
        if(sucess)
        {
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    
}
