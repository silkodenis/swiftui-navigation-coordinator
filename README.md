[![License](https://img.shields.io/github/license/silkodenis/swiftui-navigation-coordinator.svg)](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE)
![swift](https://github.com/silkodenis/swiftui-navigation-coordinator/actions/workflows/swift.yml/badge.svg?branch=main)

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

## Why This Is Interesting
- The implementation of the `unwind` transition may be of particular interest to those who have already attempted to create similar transitions in SwiftUI.
- In addition to the specific task of multi-level return, the `unwind()` can also be used instead of the usual `pop()` when it is necessary to pass data back to the previous screen. The `onUnwind()` call will always be made before the `onAppear()` call.

## Requirements

- **iOS**: iOS 16.0+
- **macOS**: macOS 13.0+
- **watchOS**: watchOS 9.0+
- **tvOS**: tvOS 16.0+

## Add with Swift Package Manager:

1. Open Xcode and select “File” > “Add Packages…”
2. Enter the URL of the package repository.
3. Follow the instructions to complete the installation.

## Getting Started

<details open>
<summary><b>1. Configure the NavigableScreen Enum</b></summary>
  
Start by creating an enum Screen to represent the different screens in your app. Ensure it conforms to the NavigableScreen protocol:

```swift
import NavigationCoordinator

enum Screen {
    case login
    case movies
    case settings
}

extension Screen: NavigableScreen {
    @ViewBuilder
    var view: some View {
        switch self {
        case .login: LoginView()
        case .movies: MoviesView()
        case .settings: SettingsView()
        }
    }
}
```
</details>

<details open>
<summary><b>2. Define Typealiases</b></summary>
  
Define typealias to simplify the usage of the types used with your coordinator:

```swift
import NavigationCoordinator

typealias SegueModifier = RegisterSegueModifier<Screen>
typealias Coordinator = NavigationCoordinator<Screen>
typealias RootView = NavigationStackRootView<Screen>
```
</details>

<details open>
<summary><b>3. Configure the App Entry Point</b></summary>
  
Set up the app entry point using the RootView to define the initial screen:

```swift
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(.login)
        }
    }
}
```
</details>

## Usage Examples

<details open>
<summary><b>Push</b></summary>

```swift
struct LoginView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        Button("Movies") {
            coordinator.push(.movies)
        }
    }
}
```
</details>

<details>
<summary><b>Pop</b></summary>

```swift
struct MoviesView: View {
    @EnvironmentObject var coordinator: Coordinator
    
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
struct SettingsView: View {
    @EnvironmentObject var coordinator: Coordinator
    
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
    @EnvironmentObject var coordinator: Coordinator
    
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
    @EnvironmentObject var coordinator: Coordinator
    
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
    @EnvironmentObject var coordinator: Coordinator
    
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
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {}
            // Not necessary. Only if you need to capture an onDismiss event.
            .onDismiss(segue: "identifier") /*{ Any? in }*/
    }
}

```
</details>

## Project examples
- [Original Example](https://github.com/silkodenis/swiftui-navigation-coordinator/tree/main/Example)
- [SwiftUI Redux TMDB Demo App](https://github.com/silkodenis/swiftui-moviesdb-redux-app)

## Reporting Issues

I welcome any issues you find within the project. If you encounter bugs or have suggestions for improvements, please feel free to create an issue on the GitHub repository.


## License

**Apache License 2.0**. See the [LICENSE](https://github.com/silkodenis/swiftui-navigation-coordinator/blob/main/LICENSE) file for details.
