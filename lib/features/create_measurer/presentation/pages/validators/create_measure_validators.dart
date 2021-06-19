String? validateNumber(String? value) {
  final x = validateRequiredValue(value);
  if (x != null) return x;

  if (int.tryParse(value!) == null) return 'Número inválido';

  if (value.length > 20) return 'Máximo 20 caracteres';
}

String? validateRequiredValue(String? value) {
  if (value == null || value.isEmpty) return 'Campo requerido';
}
