# Firestore Database Setup for Intellect Connect

## Database Structure

### 1. Users Collection
**Collection: `users`**
- **Document ID**: User's UID (from Firebase Auth)
- **Fields**:
  ```json
  {
    "uid": "string",
    "firstName": "string",
    "lastName": "string",
    "grade": "string", // "Grade 1", "Grade 2", etc.
    "parentEmail": "string",
    "phoneNumber": "string",
    "address": "string",
    "gender": "string", // "Male", "Female", "Prefer not to say"
    "profileImageUrl": "string", // URL to profile image in Firebase Storage
    "createdAt": "timestamp",
    "updatedAt": "timestamp",
    "isActive": "boolean",
    "lastLoginAt": "timestamp"
  }
  ```

### 2. Subjects Collection
**Collection: `subjects`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "subjectId": "string",
    "name": "string", // "Database Magic", "Networking Fun", etc.
    "displayName": "string", // "Database Magic 🗄️"
    "description": "string",
    "icon": "string", // Icon name or emoji
    "color": "string", // Hex color code
    "gradeLevels": ["array"], // ["Grade 1", "Grade 2", etc.]
    "isActive": "boolean",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
  ```

### 3. Tutors Collection
**Collection: `tutors`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "tutorId": "string",
    "firstName": "string",
    "lastName": "string",
    "email": "string",
    "phoneNumber": "string",
    "profileImageUrl": "string",
    "bio": "string",
    "qualifications": ["array"], // ["Bachelor's in Computer Science", etc.]
    "subjects": ["array"], // Array of subject IDs
    "hourlyRate": "number",
    "rating": "number", // Average rating (1-5)
    "totalReviews": "number",
    "isAvailable": "boolean",
    "isVerified": "boolean",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
  ```

### 4. Subject-Tutor Relationships
**Collection: `subject_tutors`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "subjectId": "string",
    "tutorId": "string",
    "isActive": "boolean",
    "createdAt": "timestamp"
  }
  ```

### 5. Sessions Collection
**Collection: `sessions`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "sessionId": "string",
    "studentId": "string", // User UID
    "tutorId": "string",
    "subjectId": "string",
    "title": "string",
    "description": "string",
    "startTime": "timestamp",
    "endTime": "timestamp",
    "duration": "number", // in minutes
    "status": "string", // "scheduled", "in-progress", "completed", "cancelled"
    "meetingLink": "string", // Video call link
    "notes": "string",
    "rating": "number", // Student's rating (1-5)
    "review": "string", // Student's review
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
  ```

### 6. Messages Collection
**Collection: `messages`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "messageId": "string",
    "senderId": "string", // User UID or Tutor ID
    "receiverId": "string", // User UID or Tutor ID
    "senderType": "string", // "student" or "tutor"
    "content": "string",
    "messageType": "string", // "text", "image", "file"
    "fileUrl": "string", // URL if message contains file
    "isRead": "boolean",
    "readAt": "timestamp",
    "createdAt": "timestamp"
  }
  ```

### 7. Achievements Collection
**Collection: `achievements`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "achievementId": "string",
    "name": "string", // "First Session", "Perfect Score", etc.
    "description": "string",
    "icon": "string", // Emoji or icon name
    "points": "number", // Points awarded
    "criteria": "string", // How to earn this achievement
    "isActive": "boolean",
    "createdAt": "timestamp"
  }
  ```

### 8. User Achievements Collection
**Collection: `user_achievements`**
- **Document ID**: Auto-generated
- **Fields**:
  ```json
  {
    "userId": "string", // User UID
    "achievementId": "string",
    "earnedAt": "timestamp",
    "sessionId": "string" // Optional: related session
  }
  ```

### 9. User Stats Collection
**Collection: `user_stats`**
- **Document ID**: User's UID
- **Fields**:
  ```json
  {
    "userId": "string",
    "totalSessions": "number",
    "totalHours": "number",
    "achievementsEarned": "number",
    "subjectsStudied": ["array"], // Array of subject IDs
    "tutorsWorkedWith": ["array"], // Array of tutor IDs
    "averageRating": "number",
    "lastSessionAt": "timestamp",
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
  ```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read subjects
    match /subjects/{subjectId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can modify subjects
    }
    
    // Users can read tutors
    match /tutors/{tutorId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can modify tutors
    }
    
    // Users can read subject-tutor relationships
    match /subject_tutors/{docId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Users can read/write their own sessions
    match /sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        (resource.data.studentId == request.auth.uid || 
         resource.data.tutorId == request.auth.uid);
    }
    
    // Users can read/write messages they're involved in
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (resource.data.senderId == request.auth.uid || 
         resource.data.receiverId == request.auth.uid);
    }
    
    // Users can read achievements
    match /achievements/{achievementId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Users can read their own achievements
    match /user_achievements/{docId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Users can read/write their own stats
    match /user_stats/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
    }
  }
}
```

## Sample Data for Initial Setup

### Sample Subjects
```json
[
  {
    "subjectId": "db_001",
    "name": "Database Magic",
    "displayName": "Database Magic 🗄️",
    "description": "Learn the fundamentals of database systems",
    "icon": "storage",
    "color": "#2196F3",
    "gradeLevels": ["Grade 3", "Grade 4", "Grade 5", "Grade 6"],
    "isActive": true
  },
  {
    "subjectId": "net_001",
    "name": "Networking Fun",
    "displayName": "Networking Fun 🌐",
    "description": "Explore computer networks and connectivity",
    "icon": "dns",
    "color": "#4CAF50",
    "gradeLevels": ["Grade 4", "Grade 5", "Grade 6"],
    "isActive": true
  },
  {
    "subjectId": "js_001",
    "name": "JavaScript Adventure",
    "displayName": "JavaScript Adventure 💻",
    "description": "Learn to code with JavaScript",
    "icon": "code",
    "color": "#FF9800",
    "gradeLevels": ["Grade 5", "Grade 6"],
    "isActive": true
  },
  {
    "subjectId": "comp_001",
    "name": "Computer Explorer",
    "displayName": "Computer Explorer 🖥️",
    "description": "Discover the world of computers",
    "icon": "computer",
    "color": "#9C27B0",
    "gradeLevels": ["Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6"],
    "isActive": true
  }
]
```

### Sample Achievements
```json
[
  {
    "achievementId": "first_session",
    "name": "First Steps",
    "description": "Complete your first learning session",
    "icon": "🎯",
    "points": 10,
    "criteria": "Complete 1 session"
  },
  {
    "achievementId": "subject_master",
    "name": "Subject Master",
    "description": "Complete 5 sessions in one subject",
    "icon": "🏆",
    "points": 50,
    "criteria": "Complete 5 sessions in a single subject"
  },
  {
    "achievementId": "perfect_score",
    "name": "Perfect Score",
    "description": "Get a perfect rating from your tutor",
    "icon": "⭐",
    "points": 25,
    "criteria": "Receive a 5-star rating"
  }
]
```

## Implementation Steps

1. **Enable Firestore** in your Firebase Console
2. **Set up Security Rules** as provided above
3. **Create Collections** and add sample data
4. **Update your Flutter app** to use these collections
5. **Test the database** with your app

## Next Steps

After setting up the database structure, you'll need to:

1. Update your Flutter app to read/write to these collections
2. Implement real-time listeners for messages and sessions
3. Add Firebase Storage for profile images
4. Implement authentication flows
5. Add data validation and error handling

Would you like me to help you implement any of these next steps in your Flutter app? 