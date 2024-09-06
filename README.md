
<p align="center">
  <a href="https://www.swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-compatible-darkgreen?style=flat-square"/></a>
   <a href="https://getstream.io/chat/docs/sdk/ios/"><img src="https://img.shields.io/badge/iOS-16%2B-lightblue?style=flat-square" /></a>
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.7%2B-orange.svg?style=flat-square" /></a>
</p>

# Isometrik ChatBot SDK

This is the official Livestream SDK for integrating advanced streaming capabilities into your application. It includes a comprehensive set of features for live video broadcasting, stream chat interactions, and real-time viewer analytics, along with reusable UI components for seamless integration and more.

## Setup

1. Get your Ids and keys ready
   
For SDK to work you need to make sure you have these configurations ready before you move to initializing your SDK, ``chatBotId``, ``userId``, ``licensekey`` , ``appSecret`` , ``storeCategoryId``

2. Initialize your SDK

call ``createConfiguration`` method for initialization

```swift

let streamUser = ISMStreamUser(
    userId: userId,
    name: name,
    identifier: identifier,
    imagePath: imagePath,
    userToken: userToken
)

IsometrikSDK.getInstance().createConfiguration(
    accountId: "YOUR ACCOUNT ID",
    projectId: "YOUR PROJECT ID",
    keysetId: "YOUR KEYSET ID",
    licenseKey: "YOUR LICENSE KEY",
    appSecret: "YOUR APP SECRET",
    userSecret: "YOUR USER SECRET",
    rtcAppId: "YOUR RTCAPP ID",
    userInfo: streamUser
)
```
