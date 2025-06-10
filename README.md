# KitchenPal: A Smart Culinary Assistant

KitchenPal is a cross-platform mobile application developed for a university project. It's designed to help users manage their kitchen inventory and discover new recipes through the power of generative AI.

![KitchenPal App Screenshot](<Your Screenshot URL Here>)

---

## 🌟 Features

- **Inventory Management:** Easily add, edit, and delete ingredients in your virtual kitchen.
- **Smart Recipe Browsing:** View a curated list of recipes you can make with your current ingredients, or discover new ones.
- **AI Chef:** The core feature! Provide a prompt (e.g., "a quick pasta dish") and the app uses your inventory and the Google Gemini AI to generate a brand new recipe on the fly.
- **Dynamic Shopping List:** Manually add items, or automatically add missing ingredients from a recipe. Supports checking off, clearing, and swipe-to-delete.
- **Secure Authentication:** User data is kept private and secure with Firebase Authentication (Google Sign-In & Email/Password).
- **Modern UI:** A clean, responsive, and intuitive user interface built with Flutter's Material 3 design system.

---

## 🛠️ Technologies Used

- **Framework:** Flutter
- **Language:** Dart
- **Backend:** Google Firebase (Authentication, Firestore Realtime Database)
- **Generative AI:** Google Gemini API
- **State Management:** Provider
- **UI Packages:** `google_fonts`, `shimmer`

---

## ⚙️ Setup and Installation

To run this project locally, you will need to have the Flutter SDK and a configured IDE (like Android Studio) installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/RazvanAga/MCCA.git
    cd MCCA
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Set up Firebase:**
    - You will need to create your own Firebase project.
    - Run `flutterfire configure` to generate your own `firebase_options.dart` file (this file is not checked into version control).

4.  **Add Secret API Keys:**
    - Create a file at `lib/api/api_keys.dart`.
    - Add the following content with your own Gemini API key:
      ```dart
      const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
      ```

5.  **Run the app:**
    ```bash
    flutter run
    ```

---

*This project was developed as part of coursework for [Your Course Name] at [Your University Name].*
