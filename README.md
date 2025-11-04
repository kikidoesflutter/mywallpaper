# 🖼 Flutter Wallpaper Desktop App

A modern and responsive **Flutter desktop application** that allows users to **browse high-quality wallpapers**, view them in **category-based collections**, and preview how they’ll look on a **phone mockup** — all with a sleek, minimal UI.

---

##  Features

-  **Wallpaper Categories** – Explore wallpapers organized into multiple visual categories.
-  **Phone Mockup Preview** – Instantly see how a wallpaper would appear on a mobile screen.
-  **Smooth Desktop Experience** – Built for Windows/macOS/Linux using Flutter’s desktop support.
-  **Fast Loading & Caching** – Efficient image loading and local caching for better performance.
-  **Modern UI Design** – Clean layout with responsive scaling and dark theme support.
-  **Search Functionality (Future addition)** – Quickly find wallpapers by keyword or tag.
-  **Favorites ** – Save your best picks locally for easy access.

---

---

##  Folder Structure

lib/
├── main.dart # Entry point 
├── data/ # Data models (Wallpaper, Category)
├── providers/ #Wallpaper provider
├── screens/ # Main screens (Home, Category, Details)
├── widgets/ # Reusable UI components
└── assets/ # fonts

---

##  Installation & Setup

Follow these steps to get started:

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- A desktop environment (Windows/macOS/Linux)
- Microsoft Visual studio
- Visual Studio Code or Android Studio (optional but recommended)

### Steps
```bash
# 1️⃣ Clone this repository
git clone https://github.com/yourusername/flutter_wallpaper_desktop.git

# 2️⃣ Navigate into the project
cd flutter_wallpaper_desktop

# 3️⃣ Get dependencies
flutter pub get

# 4️⃣ Run the app
flutter run -d windows    # or macos / linux

 Build for Release
To create a release build for your platform:

bash
Copy code
# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
The built files will be available inside the /build directory.

 Future Improvements
✅ Add wallpaper download and set-as-wallpaper functionality

✅ Integrate with Unsplash or Pexels API for live wallpapers

✅ Add user themes (light/dark/custom accent)

✅ Enable drag-and-drop wallpaper imports


 License
This project is licensed under the MIT License – see the LICENSE file for details.

 Author
Oyekola Okikiola
Flutter Developer | UI/UX Enthusiast | Creative Technologist
 [oyekolaokikiolami@gmail.com]

Link for download:
** https://drive.google.com/drive/folders/1eJQ4YOhzsMWShXEPTK4b0rX_UTaFj5iq?usp=sharing **