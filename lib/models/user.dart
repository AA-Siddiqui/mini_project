class User {
  int? id;
  String username;
  String password;
  String? avatarPath;

  User({
    this.id,
    required this.username,
    required this.password,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'avatarPath': avatarPath,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        avatarPath: map['avatarPath'],
      );
}
