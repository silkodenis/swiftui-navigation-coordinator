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
This project provides a lightweight Navigation Coordinator, implemented in just 50 lines of code and using SwiftUI NavigationStack (available in iOS 16 and later).

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
- The implementation of the `unwind` transition may be of particular interest to those who have already attempted to create similar transitions in SwiftUI.
- In addition to the specific task of multi-level return, the `unwind()` can also be used instead of the usual `pop()` when it is necessary to pass data back to the previous screen. This can be critically important for unidirectional architectures. The `onUnwind()` call will always be made before the `onAppear()` call.

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
            coordinator.unwind(to: "identifier" /*, with: Any?*/)
        }
    }
}

// A View
// 🟦🟦🅰️
struct A: View {
    var body: some View {
        VStack {}
            .onUnwind(segue: "identifier") /*{ Any? in }*/
    }
}
```
`onUnwind()` will always be called before `onAppear()`.

</details>

## Using into Your Project
Feel free to take it, modify it, and use it as you see fit.

You can take only the [NavigationCoordinator](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Navigation/Navigation/NavigationCoordinator.swift) and use it as you see fit in your project. It is an independent and tested component that manages the `NavigationPath`.

But I recommend taking advantage of some [features](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Navigation/Navigation) from my example:

<details open>
<summary><b>RootView</b></summary>

Configure the App to start with `RootView` as the initial view.

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

<details open>
<summary><b>Scene</b></summary>

Configure the `Scene` for your project. In the view property, I recommend avoiding direct View initialization. Instead, use your preferred Dependency Injection pattern, such as **View Factory**, to externally connect various dependencies to your **ViewModel**.

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

<details open>
<summary><b>UnwindSegueModifier</b></summary>

Finally, add the `UnwindViewModifier` to your project to implement the `onUnwind()` call in your view, similar to `onAppear()`.

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

## Reporting Issues

I welcome any issues you find within the project. If you encounter bugs or have suggestions for improvements, please feel free to create an issue on the GitHub repository.


## License

**Apache License 2.0**. See the [LICENSE](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE) file for details.
