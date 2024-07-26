class UserModel {
  String? username;
  String? email;
  String? uid;
  String? image;
  String? phonenumber;
  String? password; // Added field

  UserModel({
    required this.email,
    required this.username,
    required this.uid,
    this.image,
    this.phonenumber,
    this.password, // Added field
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      username: json["username"],
      uid: json["uid"],
      phonenumber: json["phonenumber"],
      image: json["image"],
      password: json["password"], // Added field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "image": image,
      "phonenumber": phonenumber,
      "password": password, // Added field
    };
  }
}
