class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
