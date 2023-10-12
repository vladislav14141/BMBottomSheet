# BMBottomSheet
https://github.com/vladislav14141/BMBottomSheet/assets/45051757/0fc4c60b-45c1-4a9f-bd2a-a179882ebeb7



Using:
```swift
// Your controller
let qrCodeVC = QRCodeCartViewController()
qrCodeVC.setup(content: "https://chat.openai.com/chat")

// Create popup
let popupVC = BMBottomSheet(childController: qrCodeVC)

// Configure
popupVC.insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
popupVC.fadeBackgroundColor = UIColor.black.withAlphaComponent(0.4)

self.present(popupVC, animated: true)
```
