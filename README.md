[![License](https://img.shields.io/github/license/silkodenis/swiftui-navigation-coordinator.svg)](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE)
![IOS](https://github.com/silkodenis/swiftui-navigation-coordinator/actions/workflows/ios.yml/badge.svg?branch=main)

# SwiftUI Navigation Coordinator

<p align="center">
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/orange.png?raw=true" alt="Screenshot 1" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/red.png?raw=true" alt="Screenshot 2" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/green.png?raw=true" alt="Screenshot 3" width="200"/>
  <img src="https://github.com/silkodenis/swiftui-navigation-coordinator/blob/readme_assets/screenshots/blue.png?raw=true" alt="Screenshot 4" width="200"/>
</p>

## About the Project
This project provides a lightweight Navigation Coordinator, using SwiftUI NavigationStack (available from iOS 16).

## Core Features
The current implementation covers 6 main transitions:

<details open>
<summary>Stack Navigation:</summary>

- `push` — navigates forward to a new view.
- `pop` — returns to the previous view.
- `unwind` — performs a multi-level return.
- `popToRoot` — returns to the root view.

</details>

<details open>
<summary>Modal Presentation:</summary>

- `present` — displays a modal view, overlaying it on top of current content.
- `dismiss` — closes the current modal view and returns to the underlying content.

</details>

## Requirements

- iOS 16.0+

## Why This Is Interesting
- The implementation of the `unwind` transition may be of particular interest to those who have already attempted to create similar transitions in SwiftUI.
- In addition to the specific task of multi-level return, the `unwind()` can also be used instead of the usual `pop()` when it is necessary to pass data back to the previous screen. The `onUnwind()` call will always be made before the `onAppear()` call.

## Usage Examples

<details>
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

<details>
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

<details>
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

<details>
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

<details>
<summary><b>Present</b></summary>

```swift
/*
               [B]
[ ][ ][ ][ ][ ][A]
*/
struct A: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("present") {
            coordinator.present(.B)
        }
    }
}
```
</details>

<details>
<summary><b>Dismiss</b></summary>

```swift
/*
               [B][ ][ ][ ][CL]
[ ][ ][ ][ ][ ][A]
*/
struct CL: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        Button("dismiss") {
            coordinator.dismiss(/*to: "identifier" /*, with: Any?*/*/)
        }
    }
}

/*
[ ][ ][ ][ ][ ][A]
*/
struct A: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    var body: some View {
        VStack {}
            // Not necessary. Only if you need to capture an onDismiss event.
            .onDismiss(segue: "identifier") /*{ Any? in }*/
    }
}

```
</details>

## Using into Your Project
Add [NavigationCoordinator](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Navigation/Navigation/NavigationCoordinator.swift) to your project.

<details>
<summary><b>Configure the App to start with `RootView` as the initial view.</b></summary>

```swift
import SwiftUI

struct RootView: View {
    @ObservedObject private var coordinator: NavigationCoordinator<Screen>
    private let root: Screen
    
    internal init(_ root: Screen, withParent coordinator: NavigationCoordinator<Screen>? = nil) {
        self.root = root
        self.coordinator = NavigationCoordinator<Screen>()
        self.coordinator.parent = coordinator
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            root.view
                .navigationDestination(for: Screen.self) { screen in
                    screen.view
                }
                .sheet(item: $coordinator.modal) { screen in
                    RootView(screen, withParent: coordinator)
                }
        }
        .environmentObject(coordinator)
    }
}
```

```swift
import SwiftUI

@main
struct SomeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(.login)
        }
    }
}
```
</details>

<details>
<summary><b>Configure the `NavigableScreen` for your project.</b></summary>

In the view property, I recommend avoiding direct View initialization. Instead, use your preferred Dependency Injection pattern, such as **View Factory**, to externally connect various dependencies to your **ViewModel**.

```swift
import SwiftUI

// Example

enum Screen {
    case login
    case movies
    case detail(id: Int)
    case info
    
    /// Used to uniquely identify segues that either navigate back to a previous screen or dismiss a modal view.
    static let toDetail = "toDetail"
    static let toMovies = "toMovies"
}

extension Screen: NavigableScreen {
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
<summary><b>Finally, add the `RegisterSegueModifier` to your project.</b></summary>

To implement the `onUnwind()` and `onDismiss()` calls in your views, similar to how `onAppear()` is used.

```swift
import SwiftUI

struct RegisterSegueModifier: ViewModifier {
    @EnvironmentObject var coordinator: NavigationCoordinator<Screen>
    
    let type: NavigationCoordinator<Screen>.Segue.SegueType
    let identifier: String
    let action: ((Any?) -> Void)?
    
    func body(content: Content) -> some View {
        content.onAppear {
            coordinator.registerSegue(type, with: identifier, action: action)
        }
    }
}

extension View {
    func onUnwind(segue identifier: String, perform action: ((Any?) -> Void)? = nil) -> some View {
        modifier(RegisterSegueModifier(type: .unwind, identifier: identifier, action: action))
    }
    
    func onDismiss(segue identifier: String, perform action: ((Any?) -> Void)? = nil) -> some View {
        modifier(RegisterSegueModifier(type: .dismiss, identifier: identifier, action: action))
    }
}
```
</details>

Feel free to take it, modify it, and use it as you see fit.

## Reporting Issues

I welcome any issues you find within the project. If you encounter bugs or have suggestions for improvements, please feel free to create an issue on the GitHub repository.


## License

**Apache License 2.0**. See the [LICENSE](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE) file for details.
