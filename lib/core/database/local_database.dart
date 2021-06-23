import 'dart:async';

import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_request_dao.dart';
import 'package:artiko/core/readings/data/data_sources/routes_dao.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'local_database.g.dart';

@Database(version: 1, entities: [
  LoginResponse,
  ReadingImagesModel,
  ReadingDetailItem,
  RoutesItem,
  AnomalyItem,
  ReadingRequest,
  ObservacionItem
])
abstract class AppDatabase extends FloorDatabase {
  CurrentUserDao get currentUserDao;

  ReadingImagesDao get readingImagesDao;

  ReadingsDao get readingDao;

  RoutesDao get routesDao;

  AnomaliesDao get anomaliesDao;

  ReadingsRequestDao get readingsRequestDao;

  ObservacionesDao get observacionesDao;
}
