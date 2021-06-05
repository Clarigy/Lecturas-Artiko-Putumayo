import '../responses/token_auth_response.dart';

abstract class AuthenticationInterface {
  Future<TokenAuthResponse> tokenAuthCreate();

  Future<TokenAuthResponse?> get tokenStorage;

  Future<void> setTokenStorage(TokenAuthResponse token);

  bool tokenExpired(TokenAuthResponse token);

  Future<String> get idUser;

  Future<String> get ip;
}
