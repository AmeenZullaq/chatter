import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String? username;
  @HiveField(3)
  final String email;

  UserModel({
    required this.id,
    this.username,
    required this.email,
  });

  factory UserModel.fromAuthUser(User user) => UserModel(
        id: user.uid,
        email: user.email ?? '',
      );

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
      );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  toJson() => {'id': id, 'userName': username, 'email': email};
}
