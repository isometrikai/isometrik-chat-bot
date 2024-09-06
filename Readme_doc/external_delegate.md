### Handling ChatBot SDK delegates

ChatBotSDK provides a delegate to handle actions for the responses it provide for either store or dish, which requires conforming to the `ChatBotDelegate` protocol. An example implementation is provided below:

``` swift

extension ViewController: ChatBotDelegate {
    
    func navigateFromBot(withData: ChatBotWidget?, forType: WidgetType?) {
        // add your controller to handle the action using given data
    }
    
}

```

- [DemoViewController](./Readme_doc/external_delegate.md) : check complete code example here how to handle delegate
