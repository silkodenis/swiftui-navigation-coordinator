# SwiftUI Navigation Coordinator

[![License](https://img.shields.io/github/license/silkodenis/swiftui-navigation-coordinator.svg)](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE)
![IOS](https://github.com/silkodenis/swiftui-navigation-coordinator/actions/workflows/ios.yml/badge.svg?branch=main)

<p align="center">
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/orange.png?raw=true" alt="Screenshot 1" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/red.png?raw=true" alt="Screenshot 2" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/green.png?raw=true" alt="Screenshot 3" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/blue.png?raw=true" alt="Screenshot 4" width="200"/>
</p>

## About the Project
This is my example of an easy-to-use **Navigation Coordinator**, written in just 50 lines of code and built using SwiftUI **NavigationStack** (iOS 16).

## Core Features
The current implementation covers 4 main transitions:
- `push` — navigates forward to a new view.
- `pop` — returns to the previous view.
- `popToRoot` — returns to the root view.
- `unwind` — performs a multi-level return.

## Requirements

- iOS 16.0+
- Xcode 14.0.x+
- Swift 5.7+

## Why This Is Interesting
The implementation of the `unwind` transition may be of particular interest to those who have already attempted to create similar transitions in SwiftUI.

## Usage Examples

<details open>
<summary><b>Push</b></summary>

```swift
struct SomeView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("info") {
            coordinator.push(.info)
        }
    }
}
```
</details>

<details open>
<summary><b>Pop</b></summary>

```swift
struct SomeView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("back") {
            coordinator.pop()
        }
    }
}
```
</details>

<details open>
<summary><b>PopToRoot</b></summary>

```swift
struct SomeView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("login") {
            coordinator.popToRoot()
        }
    }
}
```
</details>

<details open>
<summary><b>Unwind</b></summary>
Use a unique identifier for your unwind segues. If a segue becomes no longer relevant, it will be automatically removed from the coordinator. Using `onUnwind()` modifier is completely safe, tested, and does not involve any memory leaks or unintended calls. 



```swift
// B View
// 🟦🟦🅰🟦🟦🟦🟦🟦🟦🅱️  
struct B: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("pop to A") {
            coordinator.unwind(to: "A" /*, with: Any?*/)
        }
    }
}
```

```swift
// A View
// 🟦🟦🅰️
struct A: View {
    var body: some View {
        VStack {}
            .onUnwind(segue: "A") /*{ Any? in }*/
    }
}
```
`onUnwind()` will always be called before `onAppear()`.

</details>

## Using into Your Project
This is simply an example of a navigation approach. Feel free to take it, modify it, and use it as you see fit.

You can simply take the [NavigationCoordinator.swift](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Navigation/Navigation/NavigationCoordinator.swift) and use it as you see fit in your project. It is an independent and tested component that manages `NavigationPath`. 

Or you can utilize the full [infrastructure](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Navigation/Navigation) from my example:

<details>
<summary><b>RootView</b></summary>

Configure the App to run with RootView.

```swift
import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = NavigationCoordinator<Screen>()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Screen.root.view
                .navigationDestination(for: Screen.self) { screen in
                    screen.view
                }
        }
        .environmentObject(coordinator)
    }
}

@main
struct SomeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```
</details>

<details>
<summary><b>Scene</b></summary>

Configure the `Scene` for your project. In the view property, I recommend not using direct View initialization, but instead employing your favorite Dependency Injection pattern, such as 'View Factory', to connect various dependencies to your 'ViewModel' from outside.

```swift
import SwiftUI

// Example

enum Screen: Hashable {
    case login
    case movies
    case detail(id: Int)
    case info
}

extension Screen {
    static var root: Self {
        .login
    }
    
    // Unwind segue identifiers
    
    static let moviesSegue = "unwindToMovies"
}

extension Screen {
    // You can set up DI in this property
    @ViewBuilder
    var view: some View {
        switch self {
        case .login:
            viewFactory.makeLoginView()
            
        case .movies:
            viewFactory.makeMoviesView()
            
        case .detail(let id):
            viewFactory.makeDetailView(id)
            
        case .info:
            viewFactory.makeInfoView()
        }
    }
}
```
</details>

<details>
<summary><b>UnwindSegueModifier</b></summary>

Finally, add `UnwindViewModifier.swift` to your project.

```swift
import SwiftUI

struct UnwindSegueModifier: ViewModifier {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    let identifier: String
    let action: ((Any?) -> Void)?
    
    func body(content: Content) -> some View {
        content.onAppear {
            coordinator.registerSegue(with: identifier, action: action)
        }
    }
}

extension View {
    func onUnwind(segue identifier: String, perform action: ((Any?) -> Void)? = nil) -> some View {
        modifier(UnwindSegueModifier(identifier: identifier, action: action))
    }
}
```
</details>

## License

Apache License 2.0 license. See the [LICENSE](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE) file for details.
