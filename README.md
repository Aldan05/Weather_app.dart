# Weather App - Professional Climate Forecasting

A modern, professional climate forecasting application built with Flutter, featuring real-time data, AI voice assistance, and advanced data visualization.

## 🌟 Key Features

*   **🌍 Global Search**: Explore 7-day weather trends for any district, city, or country worldwide.
*   **🎙️ AI Voice Assistant**: Search for weather data hands-free. Just say the name of a place, and the app fetches and speaks the results back to you.
*   **📊 Creative Visualizations**: 
    *   **Temperature Trend**: Large Histogram/Bar chart with bold white values showing "Today", "Yesterday", and upcoming trends.
    *   **Humidity Analysis**: Interactive Bar charts for tracking moisture levels.
    *   **Wind Speed Profile**: Detailed Histogram for wind distribution.
    *   **Climate Mix**: Pie charts visualizing weather conditions over the next week.
*   **🧠 Intelligent Predictions**: Predicts tomorrow's weather (Rain/Sun/Clouds) based on atmospheric trends like humidity changes and temperature shifts.
*   **📅 Weather Calendar**: A beautiful, modern grid-based calendar showing a 7-day forecast with icons and precise temperatures.
*   **🌗 Dynamic Themes**: Supports both Light and Dark modes with a manual toggle switch in the main interface.
*   **🔐 Secure Authentication**: Full Firebase Email/Password authentication with name profile creation and password verification.
*   **💾 Smart Storage**: Automatically saves and syncs your recent city searches using Firebase Realtime Database.
*   **🚀 Full-Screen Immersive UI**: Glassmorphism design over a stunning Earth background, optimized for every pixel.

## 🛠️ Tech Stack

*   **Framework**: Flutter (Dart)
*   **Backend**: Firebase Authentication & Realtime Database
*   **API**: WeatherAPI.com (7-Day Forecast & Historical Trends)
*   **Animations**: Lottie Animations (Rain, Sun, Clouds)
*   **State Management**: Provider (for Theming)
*   **Services**: Geolocator (GPS), Speech to Text, Flutter TTS (Voice), Awesome Notifications.

## 📁 Project Structure

```text
lib/
├── models/           # Data models (Weather, Recent Cities)
├── screens/
│   ├── auth/         # Login and Registration (White & Green Theme)
│   ├── dashboard/    # Main visualization hub
│   ├── visualize/    # Detailed charts (Line, Bar, Pie, Histogram)
│   ├── prediction/   # AI reasoning and forecasts
│   └── assistant/    # Voice interaction screen
├── services/         # API, Firebase, GPS, Theme, and Voice logic
└── widgets/          # Custom Reusable UI (Weather Cards, Graphs)
```

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK
*   A Firebase project with Email Auth and Realtime Database enabled.
*   A WeatherAPI.com API Key.

### Setup
1.  **Clone the repo**:
    ```bash
    git clone https://github.com/yourusername/weather_app.git
    ```
2.  **Add Firebase**:
    *   Place your `google-services.json` in `android/app/`.
    *   Update `main.dart` with your Firebase Web Config.
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

## 🎨 UI Style
*   **Primary Colors**: Emerald Green & Pure White.
*   **Design**: Modern minimalist with high-contrast readable numbers (Bold White/Black) and vibrant gradients.

## 📄 License
This project is licensed under the MIT License.
