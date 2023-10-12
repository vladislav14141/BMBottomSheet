# BMBottomSheet

https://github.com/vladislav14141/BMBottomSheet/assets/45051757/84f9cd89-b14e-4d34-8f9c-455b9d6e77ad

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
