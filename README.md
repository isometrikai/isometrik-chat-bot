
<p align="center">
  <a href="https://www.swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-compatible-darkgreen?style=flat-square"/></a>
   <a href="https://getstream.io/chat/docs/sdk/ios/"><img src="https://img.shields.io/badge/iOS-16%2B-lightblue?style=flat-square" /></a>
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.7%2B-orange.svg?style=flat-square" /></a>
</p>

# Isometrik ChatBot SDK

Customer support chat bot, which can solve customers query related to products and their orders. Customer can ask about the order status and details. They can ask for best restaurants in respective area. 

## Setup

1. Get your Ids and keys ready
   
For SDK to work you need to make sure you have these keys ready
``chatBotId``, ``userId``, ``licensekey`` , ``appSecret`` , ``storeCategoryId``

2. Initialize your SDK

- You need to create a object of ``AppConfigurationManager`` as show below

```swift

 let appConfig = AppConfigurationManager(
      chatBotId: "YOUR CHAT BOT ID",
      userId: "YOUR USER ID",
      appSecret: "YOUR APP SECRET ID",
      licenseKey: "YOUR LICENSE KEY",
      storeCategoryId: "YOUR STORE CATEGORY ID"
  )

```

- Now you have to pass this object to ``LaunchViewModel`` and further pass the viewModel to the ``LaunchView``

``` swift

let launchViewModel = LaunchViewModel(appConfigurations: appConfig)
let launchView = LaunchView(viewModel: launchViewModel)

```
- Now navigation using ``UIHostingViewController`` to chatBot as shown below

``` swift

let hostingController = UIHostingController(rootView: launchView)
hostingController.modalPresentationStyle = .fullScreen
self.present(hostingController, animated: true, completion: nil)

```

### Quick links
- [how to handle delegates](./Readme_doc/external_delegate.md) : ChatBot SDK provides you external delegate to handle action on the content that ChatBot suggests.



