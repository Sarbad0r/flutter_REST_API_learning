class User {
  int? id;
  String? title;
  String? login;
  String? password;
  String? img;

  User(
      {required this.id,
      required this.title,
      required this.login,
      required this.password,
      required this.img
      });

  factory User.fromJson(Map<String, dynamic> toJson) {
    return User(
        id: toJson['id'],
        title: toJson['title'],
        login: toJson['login'],
        password: toJson['password'],
        img: toJson['img']
        );
  }
}
