# 🚀 Flash Chat – iOS Firebase Messaging App

A sleek, real-time chat app for iOS built with Swift and Firebase.  
Send and receive messages instantly, with secure authentication, live updates, and a modern chat experience.  
Inspired by Angela Yu’s Flash Chat, extended for 2025 iOS best practices.

## ✨ Features

- **Modern Chat UI:** Real-time messaging with instant updates.
- **Firebase Authentication:** Secure login/logout, supports only authenticated users.
- **Firestore Database:** Messages stored and synced live with cloud.
- **Message Ordering:** Always shows latest messages in correct (chronological) order using timestamps.
- **Keyboard Experience:** Seamless chat input above the keyboard (manual handling, production-ready).
- **Clean MVC Structure:** Easy to understand, modify, and extend.

## 🏗️ Project Structure

```
FlashChat/
 ├── Controllers/
 │    ├── ChatViewController.swift
 │    └── ...
 ├── Models/
 │    ├── Message.swift
 │    └── ...
 ├── Views/
 │    ├── MessageCellTableViewCell.swift
 │    └── ...
 ├── Constants/
 │    ├── K.swift
 ├── AppDelegate.swift
 ├── Info.plist
 └── ...
```

## 🔑 Prerequisites

- CocoaPods or **Swift Package Manager** (for dependencies)
- A Firebase project with:
  - Firestore enabled
  - Firebase Authentication (Email/Password at minimum)

## ⚡️ Firebase Setup

1. **Create a Firebase Project:** [console.firebase.google.com](https://console.firebase.google.com/)
2. **Add an iOS App** in Firebase & download `GoogleService-Info.plist`.
3. **Enable Firestore** in the Firebase Console.
4. **Enable Firebase Authentication** (Email/Password).
5. **Set Firestore Security Rules** to restrict access to authenticated users:
   ```plaintext
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## 🛠️ Installation

### 1. **Clone This Repo**

```sh
git clone https://github.com/YOUR_USERNAME/flash-chat-firebase-ios.git
cd flash-chat-firebase-ios
```

### 2. **Install Dependencies**

#### Using Swift Package Manager
- Go to **Xcode > File > Add Packages...**
- Add:
  - `https://github.com/firebase/firebase-ios-sdk.git`
  - (Optional, for keyboard management in forms)  
    `https://github.com/hackiftekhar/IQKeyboardManager`

#### Using CocoaPods
- Run: `pod install`

### 3. **Configure Firebase**
- Add `GoogleService-Info.plist` to your Xcode project’s root.

## 🧑‍💻 Core Implementation Details

### Firestore Database Structure

- **Collection:** `messages`
- **Document fields:**
  - `sender`: (String) email of the user
  - `body`: (String) message text
  - `date`: (Firestore Timestamp) when message was sent

### Sending a Message

```swift
db.collection("messages").addDocument(data: [
    "sender": Auth.auth().currentUser?.email ?? "",
    "body": messageBody,
    "date": FieldValue.serverTimestamp()
])
```

### Real-Time Chat Updates

- **Listens for live updates from Firestore using:**

```swift
listener = db.collection("messages")
    .order(by: "date")
    .addSnapshotListener { [weak self] querySnapshot, error in
        // Update UI
    }
```

- **All message queries use `.order(by: "date")`** for correct chat order.

### Keyboard Handling

- **Manual keyboard handling** is used for the input bar (recommended for chat apps):
  - Adjusts the bottom constraint of the input bar in response to keyboard appearance.
  - IQKeyboardManager is disabled for chat VC, enabled elsewhere.

### ViewController Life Cycle

- Listeners and observers are **added** in `viewWillAppear` or `viewDidLoad`, **removed** in `viewWillDisappear` or `deinit` to prevent memory leaks.

## 📝 Best Practices Followed

- **[weak self]** in all Firestore and async closures to avoid retain cycles.
- **Remove Firestore listeners** when VC disappears to avoid extra updates/memory leaks.
- **Ordered chat messages** with a `date` field (Firestore timestamp).
- **Secure Firestore rules:** only authenticated users can read/write.
- **Proper VC lifecycle management** and keyboard handling for a flawless chat UX.

## 🙋 FAQ

### Q: Why aren’t my messages in the right order?
A: All queries must use `.order(by: "date")` and save messages with `FieldValue.serverTimestamp()`.

### Q: How do you keep the input bar above the keyboard?
A: The bottom constraint of the input bar is adjusted on keyboard show/hide notifications. IQKeyboardManager is disabled on the chat screen.

### Q: Why use `[weak self]` in closures?
A: To prevent retain cycles and memory leaks caused by Firestore listeners holding strong references to your view controllers.

### Q: Do I need a timestamp field in each message?
A: Yes. Firestore does not sort documents by creation; you must add and query a `date` field.

## 🙌 Credits

- [Angela Yu](https://github.com/angelabauer) for the original Flash Chat concept.
- [Firebase Team](https://firebase.google.com/)
- [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager) library (for form input screens).
