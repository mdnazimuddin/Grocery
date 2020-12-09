class CustomerModel {
  String token;
  String name;
  String email;
  String phone;
  String img;
  String password;
  CustomerModel(
      {this.token, this.name, this.email, this.phone, this.img, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'token': token,
      'name': name,
      'email': email,
      'phone': phone,
      'img': img,
      'password': password,
      'username': email
    });
    return map;
  }
}
