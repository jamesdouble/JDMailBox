# JDMailBox
(IOS)An animation after the mail send.
***
# Introduction
JDMailBox is basically a **MFMailComposeViewController** :mailbox_with_mail: , but I think it will be more interesting with an animation.

<img src="/../master/Readme_img/Logomakr_3Y8BMT.png" width="100%">

# Installation
1. **Cocoapod**
	
	```
	pod 'JDGamesLoading'
	```
2. **Fork my reop.**


# Usage

:envelope: JDMailBox is a kind of MFMailComposeViewController, so all you need to do is treat it like this: 

###Basic
```Swift
  jdmailbox = JDMailBoxComposeVC(rootVC: self)
  self.present(jdmailbox, animated: true, completion: nil)
```




