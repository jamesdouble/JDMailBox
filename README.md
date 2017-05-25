# JDMailBox
(IOS)An animation after the mail send.
***
# Introduction
JDMailBox is basically a **MFMailComposeViewController** :mailbox_with_mail: , but I think it will be more interesting with an animation.:yum::yum::yum:

<img src="/../master/Readme_img/JDMailBoxLogo.png" width="100%">

# Installation
1. **Cocoapod**
	
	```
	pod 'JDMailBox'
	```
2. **Fork my reop.**

# Demo

<img src="/../master/Readme_img/JDMailBoxDemo.gif" width="30%">

# Usage

:e-mail: JDMailBox is a kind of MFMailComposeViewController, so all you need to do is treat it like this: 

### Basic
```Swift
  jdmailbox = JDMailBoxComposeVC(rootVC: self)
  self.present(jdmailbox, animated: true, completion: nil)
```
### Signature :pencil2:
```Swift
  jdmailbox = JDMailBoxComposeVC(rootVC: self)
  jdmailbox.setSignature(signature: "JamesDouble")
  self.present(jdmailbox, animated: true, completion: nil)
```



### More About MFMailComposeViewController Usage
You should reference:
https://developer.apple.com/reference/messageui/mfmailcomposeviewcontroller





