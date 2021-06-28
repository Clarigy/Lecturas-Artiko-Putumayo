import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/readings/domain/entities/new_meter_request.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class UpdateNewMeterUseCase
    extends UseCase<List<ReadingDetailItem>, Future<void>> {
  final ReadingRepositoryContract _repository;
  final CacheStorageInterface _cacheStorageInterface;

  UpdateNewMeterUseCase(this._repository, this._cacheStorageInterface);

  @override
  Future<void> call(List<ReadingDetailItem> readings) async {
    try {
      final String? ordenAnterior =
          await _cacheStorageInterface.fetch(CacheKeys.PREVIOUS_ORDER);

      final List<NewMeterRequestItem> readingsRequest = readings
          .where((element) => element.detalleLecturaRutaSec == null)
          .map((e) => NewMeterRequestItem.fromReadingDetail(
                e,
                ordenAnterior:
                    ordenAnterior != null ? int.tryParse(ordenAnterior) : null,
                orden: e.orden,
              ))
          .toList();

      await _cacheStorageInterface.save(
          key: CacheKeys.PREVIOUS_ORDER,
          value: readingsRequest.last.orden.toString());

      return await _repository.updateNewMeter(readingsRequest);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
