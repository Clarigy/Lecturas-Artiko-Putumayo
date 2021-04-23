abstract class UseCase<T> {
  Future<void> call(T params);
}
