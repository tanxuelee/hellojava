class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  late String verified;
  late String datereg;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.password,
      required this.verified,
      required this.datereg});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    verified = json['verified'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['verified'] = verified;
    data['datereg'] = datereg;
    return data;
  }
}
