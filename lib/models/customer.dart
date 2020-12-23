class CustomerModel {
  String token;
  String firstName;
  String lastName;
  String email;
  String phone;
  String img;
  String password;
  CustomerModel(
      {this.token,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.img,
      this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'token': token,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'img': img,
      'password': password,
      'username': email
    });
    return map;
  }
}
