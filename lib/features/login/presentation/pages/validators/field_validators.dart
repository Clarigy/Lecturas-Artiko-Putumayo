String? validateEmail(String? email) {
  var emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  if (email == null || email.isEmpty) return 'Campo requerido';

  if (email.length > 60) return 'Max 60 caracteres';

  if (!emailValid.hasMatch(email)) return 'Correo electrónico no valido';

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) return 'Campo requerido';
  if (password.length > 15) return 'Max 15 caracteres';

  return null;
}
