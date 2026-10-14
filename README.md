# Mobile Applications – Homework 5: Profile Card App

**Student:** Farah Alhasan  
**Student Number:** 21120205709

The Week 5 profile card app (async data, `setState`, `initState`, conditional rendering), extended with messaging and extra pages.

## Homework

- [x] A **Send Message** button next to **Refresh User**
- [x] The button opens a UBYS-style dialog for an instant message or an e-mail. It is a UI design only, so nothing is really sent. It has:
  - a Message / E-mail switch
  - the recipient
  - a category, a subject, and the message with a character counter
  - a "send a copy to my e-mail" option
  - validation and a short "Sending..." state
- [x] Extra pages: **About**, **Mission & Vision** and **Contact**
- [x] Mobile-friendly navigation:
  - a bottom navigation bar and a side menu (drawer) on phones
  - a navigation rail on wide screens

## Project structure

```
lib/
├── main.dart                   # App, navigation, async user data (setState)
├── pages/
│   ├── profile_page.dart       # Profile card from the lecture
│   ├── about_page.dart         # Biography, skills, experience
│   ├── mission_vision_page.dart
│   └── contact_page.dart       # Contact details + message / e-mail buttons
└── widgets/
    └── message_dialog.dart     # UBYS-style message dialog
```

## How to run

```bash
flutter pub get
flutter run -d chrome     # or: flutter run -d macos
flutter test
```
