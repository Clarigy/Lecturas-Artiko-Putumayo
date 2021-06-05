abstract class ConfigRemoteApi {
  static String get baseUrl =>
      'https://efv9xq8ctbgejj7-dbartiko.adb.sa-saopaulo-1.oraclecloudapps.com/ords/ws_artiko/lecturas';

  static String get tokenBaseUrl =>
      'https://efv9xq8ctbgejj7-dbartiko.adb.sa-saopaulo-1.oraclecloudapps.com/ords/ws_artiko/oauth/token';
}

abstract class ConfigParamsToken {
  static String get grantTypeRefresh => 'refresh_token';

  static String get grantTypeCreate => 'client_credentials';

  static String get usernameBasic => 'clientId';
}
