//
//  JDMailBox.swift
//  JDMailBox
//
//  Created by 郭介騵 on 2017/5/13.
//  Copyright © 2017年 james12345. All rights reserved.
//

import UIKit
import MessageUI

public class JDMailBoxComposeVC:MFMailComposeViewController
{
    var root:UIViewController?
    public var maildelegate:MFMailComposeViewControllerDelegate?
    var UserDefinedText:String?
    var isCancel:Bool = false
    
    public init(rootVC:UIViewController)
    {
        super.init(nibName: nil, bundle: nil)
        root = rootVC
        self.transitioningDelegate = self
        self.mailComposeDelegate = self
    }
   
    public func setSignature(signature:String)
    {
        UserDefinedText = signature
    }
    
    func getUserDefinedText()->String?
    {
        return UserDefinedText
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JDMailBoxComposeVC:MFMailComposeViewControllerDelegate
{
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
        print(#function)
        if(maildelegate != nil)
        {
            maildelegate?.mailComposeController!(controller, didFinishWith: result, error: error)
        }
        if(result == .cancelled || result == .failed)
        {
            isCancel = true
        }
        else
        {
            isCancel = false
        }
    }
}


