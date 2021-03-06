import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/readings/domain/use_case/update_new_meter_use_case.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id_future.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';
import '../../all_anomalies.dart';

class CloseTerminalUseCase
    extends UseCase<List<ReadingDetailItem>, Future<void>> {
  final ReadingRepositoryContract _repository;
  final GetReadingImagesByReadingIdUseCaseFuture
      _getReadingImagesByReadingIdUseCaseFuture;
  final UpdateNewMeterUseCase _updateNewMeterUseCase;

  CloseTerminalUseCase(
      this._repository,
      this._getReadingImagesByReadingIdUseCaseFuture,
      this._updateNewMeterUseCase);

  @override
  Future<void> call(List<ReadingDetailItem> readings) async {
    try {
      final List<ReadingRequest> tempList = [];
      final List<ReadingDetailItem> otherReadings = [];

      final anomaliaCierre =
          AllAnomalies().anomalias!.firstWhere((element) => element.cierre);

      for (final reading in readings) {
        ReadingRequest readingWithFotos = reading.readingRequest.fotos.isEmpty
            ? reading.readingRequest
            : reading.readingRequest
          ..fotos = (await _getReadingImagesByReadingIdUseCaseFuture(
                  reading.id.toString()))!
              .map((e) => e.imageBase64)
              .toList();

        if (reading.anomSec == null) {
          readingWithFotos = readingWithFotos.copyWith(
              anomaliaSec: anomaliaCierre.anomaliaSec,
              claseAnomalia: anomaliaCierre.clase,
              alreadySync: true);
        }

        if (reading.indRangoCritica == null ||
            reading.indRangoCritica!.isEmpty) {
          readingWithFotos = readingWithFotos.copyWith(indCritica: 'SNL');
        } else {
          readingWithFotos =
              readingWithFotos.copyWith(indCritica: reading.indRangoCritica);
        }

        otherReadings.add(reading..readingRequest = readingWithFotos);
        tempList.add(readingWithFotos);
      }

      if (otherReadings
          .any((element) => element.detalleLecturaRutaSec == null)) {
        await _updateNewMeterUseCase(otherReadings);
      }

      return await _repository.closeTerminal(tempList
          .where((element) => element.detalleLecturaRutaSec != null)
          .toList());
    } on ServerException catch (e) {
      throw Failure(e.message ?? 'Error inesperado');
    } catch (_) {
      throw Failure('No se pudo cerrar la terminal');
    }
  }
}
