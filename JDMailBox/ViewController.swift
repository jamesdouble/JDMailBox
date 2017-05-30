//
//  ViewController.swift
//  JDMailBox
//
//  Created by 郭介騵 on 2017/5/13.
//  Copyright © 2017年 james12345. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {

    var jdmailbox:JDMailBoxComposeVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func demo(_ sender: Any) {
        if(JDMailBoxComposeVC.canSendMail())   /* importnat */
        {
            jdmailbox = JDMailBoxComposeVC(rootVC: self)
            jdmailbox.maildelegate = self
            jdmailbox.setSignature(signature: "JamesDouble")
            self.present(jdmailbox, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        print("User Defined Delegate")
    }
}
