import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 77, adapterName: 'UserAdapter')
class User extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  Profile? profile;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? created_at;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profile,
    this.description,
    this.created_at
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile: json['profile'] != null
    ? Profile.fromJson(Map<String, dynamic>.from(json['profile']))
        : null,
      description: json['description'],
      created_at: json['created_at'],
    );
  }
}

@HiveType(typeId: 78, adapterName: 'ProfileAdapter')
class Profile extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? public_path;

  Profile({
    required this.id,
    required this.public_path,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      public_path: json['public_path'],
    );
  }
}