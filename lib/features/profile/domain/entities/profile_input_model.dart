class ProfileInputModel {
  final String text;
  final String label;
  final bool allowCall;

  ProfileInputModel(
      {required this.text, required this.label, this.allowCall = false});
}
