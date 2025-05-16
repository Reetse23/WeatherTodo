# Todo-App & Weather App ☀️📝

This is a SwiftUI-based iOS application that combines a **to-do task manager** with **real-time weather updates** based on the user's current location. The app uses Realm for local task persistence and fetches weather data using a weather API.

---

## ✨ Features

- ✅ Create, complete, and delete to-do tasks
- 🔍 Search tasks by title or description
- 📍 Fetch current location with `CoreLocation`
- ☁️ Retrieve and display current weather and sunrise/sunset information
- 🗃️ Persist tasks locally using Realm database
- 🚀 Clean architecture using MVVM

---

## 🧱 Project Structure

### 📦 Models

- `Task`: A Realm object storing task title, description, and completion state.
- `WeatherData`: Codable structure matching the API response schema.
- `RealmTaskStorage`: Handles all CRUD operations for `Task` objects using Realm.
- `WeatherAPIService`: Makes a network call to retrieve weather data using `URLSession`.
- `WeatherServiceProtocol`: Protocol to allow testability and decoupling from the concrete API service.
- and more...

### 🖼 Views

- `ContentView`: Displays the main UI with task list and weather summary.
- `TaskRow`: View for each task row, with check and delete functionality.
- `TaskCreatorView`: Modal for adding a new task.
- and more...

### 🧠 Controllers

- `TaskManager`: Handles all logic around task creation, filtering, and persistence.
- `WeatherViewModel`: Fetches and stores weather data.
- `LocationManager`: Requests location permissions and fetches current coordinates.

---

## 🔧 Technologies Used

- SwiftUI
- RealmSwift
- CoreLocation
- URLSession
- MVC Design Pattern

---

## 🚀 Getting Started

### Prerequisites

- Xcode 14 or later
- iOS 15.0+
- CocoaPods or Swift Package Manager (for RealmSwift)
