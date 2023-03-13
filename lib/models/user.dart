class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? datereg;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.password,
      this.datereg});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['datereg'] = datereg;
    return data;
  }
}
