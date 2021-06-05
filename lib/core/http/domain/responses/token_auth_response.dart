class TokenAuthResponse {
  String accessToken;
  String tokenType;
  int expiresIn;
  String created;

  TokenAuthResponse(
      {required this.accessToken,
      required this.tokenType,
      required this.expiresIn,
      required this.created});

  factory TokenAuthResponse.fromJson(Map<String, dynamic> json) =>
      TokenAuthResponse(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        created: json['created'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['created'] = created;
    return data;
  }
}
