# Firebase Setup for Real-time Messaging

This guide will help you set up Firebase for real-time messaging between your Flutter mobile app and web interface.

## 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable the following services:
   - Authentication
   - Cloud Firestore
   - Storage (optional, for image sharing)

## 2. Flutter App Configuration

### Android Setup
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`
3. Update `android/build.gradle.kts`:
   ```kotlin
   buildscript {
       dependencies {
           classpath("com.google.gms:google-services:4.3.15")
       }
   }
   ```
4. Update `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

### iOS Setup
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to your iOS project using Xcode
3. Update `ios/Runner/Info.plist` if needed

### Web Setup
1. In Firebase Console, go to Project Settings > General
2. Scroll down to "Your apps" section
3. Click "Add app" and select Web
4. Copy the Firebase config object
5. Replace the config in `web/messaging.html`:
   ```javascript
   const firebaseConfig = {
       apiKey: "your-api-key",
       authDomain: "your-project.firebaseapp.com",
       projectId: "your-project-id",
       storageBucket: "your-project.appspot.com",
       messagingSenderId: "123456789",
       appId: "your-app-id"
   };
   ```

## 3. Firestore Security Rules

Update your Firestore security rules to allow read/write access:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /messages/{messageId} {
      allow read, write: if true; // For development - make more secure for production
    }
  }
}
```

## 4. Dependencies Installation

Run the following command in your Flutter project:
```bash
flutter pub get
```

## 5. Testing the Setup

1. **Mobile App**: Run your Flutter app and navigate to the Messages page
2. **Web Interface**: Open `web/messaging.html` in a browser
3. **Test Messaging**: Send messages from both interfaces to verify real-time communication

## 6. Features Included

- Real-time message synchronization
- User authentication (basic)
- Message timestamps
- Responsive design
- Image sharing capability (mobile)
- Cross-platform messaging

## 7. Security Considerations

For production use, implement:
- Proper user authentication
- Message encryption
- Rate limiting
- User permissions
- Input validation

## 8. Troubleshooting

- Ensure Firebase project is properly configured
- Check internet connectivity
- Verify Firestore rules allow read/write
- Check browser console for JavaScript errors
- Ensure all dependencies are installed

## 9. Next Steps

- Implement user authentication
- Add message encryption
- Implement push notifications
- Add file sharing capabilities
- Create user profiles
- Add message search functionality 