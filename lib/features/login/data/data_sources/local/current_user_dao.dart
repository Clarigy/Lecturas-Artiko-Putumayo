import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class CurrentUserDao {
  @Query('SELECT * FROM current_user LIMIT 1')
  Future<LoginResponse?> getLoginResponse();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(LoginResponse loginResponse);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(LoginResponse loginResponse);
}
