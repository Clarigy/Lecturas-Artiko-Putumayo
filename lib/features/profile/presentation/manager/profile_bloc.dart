import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/domain/entities/profile_input_model.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ProfileState { withData, loading }

class ProfileBloc extends ChangeNotifier {
  ProfileBloc(this._getCurrentUserUseCase);

  ProfileState profileState = ProfileState.loading;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  LoginResponse? _currentUser;

  LoginResponse? get currentUser => _currentUser;

  Future<LoginResponse?> getCurrentUserFromDb() async {
    profileState = ProfileState.loading;
    notifyListeners();

    try {
      _currentUser = await _getCurrentUserUseCase(null);
    } catch (error) {
      rethrow;
    } finally {
      profileState = ProfileState.withData;
      notifyListeners();
    }
  }

  List<ProfileInputModel> getProfileInputModels() {
    if (_currentUser == null) return [];

    final List<ProfileInputModel> profileInputModels = [
      ProfileInputModel(text: _currentUser!.cargo, label: 'cargo'),
      ProfileInputModel(text: 'Contrato', label: 'contrato'),
      ProfileInputModel(text: _currentUser!.correoLector, label: 'correo'),
      ProfileInputModel(
          text: _currentUser!.telefonoLector ?? '', label: 'numero'),
      ProfileInputModel(text: _currentUser!.supervisor, label: 'supervisor'),
      ProfileInputModel(
          text: _currentUser!.telefonoSupervisor,
          label: 'numero',
          allowCall: true),
      ProfileInputModel(text: _currentUser!.empresa, label: 'empresa'),
    ];

    return profileInputModels;
  }

  Future<void> launchURL() async =>
      await canLaunch('tel: ${currentUser?.telefonoSupervisor ?? '0'}')
          ? await launch('tel: ${currentUser?.telefonoSupervisor ?? '0'}')
          : throw 'Could not launch phone';
}
