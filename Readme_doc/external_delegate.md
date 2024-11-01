### Handling ChatBot SDK Delegates

The ChatBot SDK provides a delegate to handle actions from its responses, such as store or dish suggestions. To utilize this functionality, you must conform to the `ChatBotDelegate` protocol. Below is an example of how to implement the delegate:

```swift
extension ViewController: ChatBotDelegate {
    
    func navigateFromBot(withData: ChatBot.ChatBotWidget?, dismissOnSuccess: (Bool) -> ()) {
        // Implement your custom logic to handle the navigation using the provided data
    }
}
```

For a complete implementation example, check out the [DemoViewController](./DemoViewController.swift).
