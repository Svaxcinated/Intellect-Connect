import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Management
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'firstName': userData['firstName'],
          'lastName': userData['lastName'],
          'grade': userData['grade'],
          'parentEmail': userData['parentEmail'],
          'phoneNumber': userData['phoneNumber'],
          'address': userData['address'],
          'gender': userData['gender'],
          'profileImageUrl': userData['profileImageUrl'] ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isActive': true,
          'lastLoginAt': FieldValue.serverTimestamp(),
        });

        // Create user stats document
        await _firestore.collection('user_stats').doc(user.uid).set({
          'userId': user.uid,
          'totalSessions': 0,
          'totalHours': 0,
          'achievementsEarned': 0,
          'subjectsStudied': [],
          'tutorsWorkedWith': [],
          'averageRating': 0.0,
          'lastSessionAt': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  // Subjects Management
  Stream<QuerySnapshot> getSubjects() {
    return _firestore
        .collection('subjects')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getSubjectsForGrade(String grade) async {
    try {
      final querySnapshot = await _firestore
          .collection('subjects')
          .where('isActive', isEqualTo: true)
          .where('gradeLevels', arrayContains: grade)
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting subjects for grade: $e');
      return [];
    }
  }

  // Tutors Management
  Stream<QuerySnapshot> getTutorsForSubject(String subjectId) {
    return _firestore
        .collection('subject_tutors')
        .where('subjectId', isEqualTo: subjectId)
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getTutorData(String tutorId) async {
    try {
      final doc = await _firestore.collection('tutors').doc(tutorId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting tutor data: $e');
      return null;
    }
  }

  // Sessions Management
  Future<String> createSession(Map<String, dynamic> sessionData) async {
    try {
      final docRef = await _firestore.collection('sessions').add({
        'sessionId': '', // Will be updated after creation
        'studentId': sessionData['studentId'],
        'tutorId': sessionData['tutorId'],
        'subjectId': sessionData['subjectId'],
        'title': sessionData['title'],
        'description': sessionData['description'],
        'startTime': sessionData['startTime'],
        'endTime': sessionData['endTime'],
        'duration': sessionData['duration'],
        'status': 'scheduled',
        'meetingLink': sessionData['meetingLink'] ?? '',
        'notes': sessionData['notes'] ?? '',
        'rating': null,
        'review': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update the sessionId with the document ID
      await docRef.update({'sessionId': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating session: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUserSessions(String userId) {
    return _firestore
        .collection('sessions')
        .where('studentId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .snapshots();
  }

  Future<void> updateSessionStatus(String sessionId, String status) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating session status: $e');
      rethrow;
    }
  }

  Future<void> rateSession(String sessionId, int rating, String review) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).update({
        'rating': rating,
        'review': review,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error rating session: $e');
      rethrow;
    }
  }

  // Messages Management
  Future<String> sendMessage(Map<String, dynamic> messageData) async {
    try {
      final docRef = await _firestore.collection('messages').add({
        'messageId': '', // Will be updated after creation
        'senderId': messageData['senderId'],
        'receiverId': messageData['receiverId'],
        'senderType': messageData['senderType'],
        'content': messageData['content'],
        'messageType': messageData['messageType'] ?? 'text',
        'fileUrl': messageData['fileUrl'] ?? '',
        'isRead': false,
        'readAt': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the messageId with the document ID
      await docRef.update({'messageId': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessages(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId1, userId2])
        .where('receiverId', whereIn: [userId1, userId2])
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error marking message as read: $e');
      rethrow;
    }
  }

  // Achievements Management
  Stream<QuerySnapshot> getAchievements() {
    return _firestore
        .collection('achievements')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('user_achievements')
          .where('userId', isEqualTo: userId)
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting user achievements: $e');
      return [];
    }
  }

  Future<void> awardAchievement(String userId, String achievementId, {String? sessionId}) async {
    try {
      // Check if user already has this achievement
      final existing = await _firestore
          .collection('user_achievements')
          .where('userId', isEqualTo: userId)
          .where('achievementId', isEqualTo: achievementId)
          .get();
      
      if (existing.docs.isEmpty) {
        await _firestore.collection('user_achievements').add({
          'userId': userId,
          'achievementId': achievementId,
          'earnedAt': FieldValue.serverTimestamp(),
          'sessionId': sessionId,
        });

        // Update user stats
        await _firestore.collection('user_stats').doc(userId).update({
          'achievementsEarned': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error awarding achievement: $e');
      rethrow;
    }
  }

  // User Stats Management
  Future<Map<String, dynamic>?> getUserStats(String userId) async {
    try {
      final doc = await _firestore.collection('user_stats').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }

  Future<void> updateUserStats(String userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('user_stats').doc(userId).update(updates);
    } catch (e) {
      print('Error updating user stats: $e');
      rethrow;
    }
  }

  // Utility Methods
  Future<void> updateLastLogin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  // Real-time listeners for notifications
  Stream<QuerySnapshot> getUnreadMessages(String userId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUpcomingSessions(String userId) {
    final now = Timestamp.now();
    return _firestore
        .collection('sessions')
        .where('studentId', isEqualTo: userId)
        .where('startTime', isGreaterThan: now)
        .where('status', isEqualTo: 'scheduled')
        .orderBy('startTime')
        .limit(5)
        .snapshots();
  }
} 