class UserModel {
  String uid;
  String email;

  UserModel({required this.uid, required this.email});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
      };
}
