import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: 'reading_images')
class ReadingImagesModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String readingId;

  Uint8List image;

  ReadingImagesModel({required this.readingId, required this.image, this.id});
}
