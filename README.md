## Instagram Reels Demo – Clean Architecture (Swift, SwiftUI, SwiftData)

This repository contains a demo project that replicates the core functionality of Instagram Reels, built in Swift and SwiftUI. The project is architected using Clean Architecture principles, leveraging SwiftData for persistent storage and Swift Testing for robust unit tests.

---

### **Project Overview**

The goal of this demo is to showcase a modular, scalable, and testable approach to building a Reels-like feature, focusing on separation of concerns and best practices for modern iOS development. The codebase is structured to facilitate easy maintenance, extensibility, and high test coverage.

---

## **Features**

- **Instagram Reels Experience:** Core UI and logic to browse, view, and interact with short video content.
- **Clean Architecture:** Clear separation between UI, business logic (Interactors), data repositories, and dependency injection.
- **SwiftUI:** Modern, declarative UI framework for building responsive and interactive views.
- **SwiftData:** Efficient local data storage and management.
- **Unit Testing:** Comprehensive suite of tests using Swift Testing, with mocks for isolation and reliability.

---

## **Project Structure**

The project is organized into the following main modules and folders:

| Folder / Module         | Description                                                                 |
|------------------------ |-----------------------------------------------------------------------------|
| **Core**                | Core utilities and shared logic.                                            |
| **DependencyInjection** | Handles dependency management and environment setup (`AppEnvironment`, `DIContainer`). |
| **Interactors**         | Business logic layer, e.g., `PostsInteractor`.                              |
| **Repositories**        | Data access layer, split into `Database` (e.g., `CommentsDBRepository`, `PostsDBRepository`) and `WebAPI` (e.g., `PostsWebRepository`, `WebRepository`). |
| **Mocks**               | Mocked data and repositories for testing.                                   |
| **Models**              | Data models such as `Post`, `Comment`, `User`, `Schema`.                    |
| **UI**                  | SwiftUI components, structured into `Common` and `Feed` (e.g., `FeedPost`, `FeedPostComments`, `FeedPostControls`, `FeedView`). |
| **Utilities**           | Helper utilities (e.g., `CancelBag`, `Date+Time`, `Loadable`).              |
| **Preview Content**     | Sample data for SwiftUI previews.                                           |
| **Tests**               | Unit tests organized by feature and layer, using mocks for isolation.        |

---

## **Testing**

- The project includes a dedicated test target with a comprehensive suite of unit tests.
- Tests are organized to mirror the main codebase structure, with mocks for interactors, repositories, and network responses.
- Swift Testing is used for fast and reliable test execution.

---

## **Why Clean Architecture?**

- **Testability:** Each layer can be tested in isolation.
- **Maintainability:** Easy to extend and refactor.
- **Separation of Concerns:** UI, business logic, and data management are clearly separated.

---

## **Contributing**

Feel free to fork the repo

---

## **License**

This is a demonstration project and not affiliated with Instagram or Meta.

---
