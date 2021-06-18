import 'package:floor/floor.dart';

@Entity(tableName: 'reading_images')
class ReadingImagesModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String readingId;

  int imageCount;

  @ignore
  late String imageBase64;

  String getSpecialId() => '$readingId-$imageCount';

  ReadingImagesModel(
      {required this.readingId, required this.imageCount, this.id});
}
