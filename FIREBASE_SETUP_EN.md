
# 🔥 Firebase Setup Guide

This guide helps developers who clone the project configure their own Firebase settings and correctly add the `GoogleService-Info.plist` file to the project.

---

## ✅ 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project or use an existing one.
3. Add your iOS app to the Firebase project.
   - Make sure to enter the correct **Bundle Identifier**.
4. Firebase will generate a `GoogleService-Info.plist` file for your app.
5. Download this file to your computer.

---

## 📅 2. Add the File to Your Xcode Project

1. Drag and drop the `GoogleService-Info.plist` file into the root of your Xcode project.
2. Check the "**Copy items if needed**" option.
3. Make sure your app's target is selected.

> ⚠️ Ensure the file is listed under `Build Phases > Copy Bundle Resources`.

---

## ⛔️ 3. Version Control - .gitignore

The `.gitignore` file in the project includes the following rule:

```bash
# Firebase config
googleService-Info.plist
```

This ensures that the `GoogleService-Info.plist` file is not committed to version control. Each developer must download and add their own copy to the project.

---

## 🔍 4. Verify the Setup

Before using Firebase services:

- Ensure the Firebase SDK is installed and integrated properly.
- Confirm that the `GoogleService-Info.plist` file is correctly added.
- Check that your app’s Bundle ID matches the settings in the Firebase Console.

Otherwise, Firebase features like Auth, Firestore, or Analytics may not work properly.

---

