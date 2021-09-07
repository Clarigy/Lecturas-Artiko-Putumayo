abstract class ConfigRemoteApi {
  static String get baseUrl =>
      'https://g90913c469f3c4a-bdartiko.adb.us-ashburn-1.oraclecloudapps.com/ords/ws_artiko/lecturas';

  static String get tokenBaseUrl =>
      'https://g90913c469f3c4a-bdartiko.adb.us-ashburn-1.oraclecloudapps.com/ords/ws_artiko/oauth/token';
}

abstract class ConfigParamsToken {
  static String get grantTypeRefresh => 'refresh_token';

  static String get grantTypeCreate => 'client_credentials';

  static String get usernameBasic => 'clientId';
}
