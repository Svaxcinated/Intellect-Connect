import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String subjectId;
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final String color;
  final List<String> gradeLevels;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubjectModel({
    required this.subjectId,
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradeLevels,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subjectId: map['subjectId'] ?? '',
      name: map['name'] ?? '',
      displayName: map['displayName'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '#2196F3',
      gradeLevels: List<String>.from(map['gradeLevels'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'name': name,
      'displayName': displayName,
      'description': description,
      'icon': icon,
      'color': color,
      'gradeLevels': gradeLevels,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SubjectModel copyWith({
    String? subjectId,
    String? name,
    String? displayName,
    String? description,
    String? icon,
    String? color,
    List<String>? gradeLevels,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      gradeLevels: gradeLevels ?? this.gradeLevels,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isAvailableForGrade(String grade) {
    return gradeLevels.contains(grade);
  }
} 