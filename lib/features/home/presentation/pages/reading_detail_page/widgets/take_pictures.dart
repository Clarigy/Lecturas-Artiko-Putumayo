import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../reading_detail_bloc.dart';
import '../reading_detail_page.dart';

class TakePictures extends StatefulWidget {
  final EdgeInsets? margin;
  final String readingId;

  const TakePictures({this.margin, required this.readingId});

  @override
  _TakePicturesState createState() => _TakePicturesState();
}

class _TakePicturesState extends State<TakePictures> {
  int countImages = 0;
  late ReadingDetailBloc bloc;

  @override
  void initState() {
    bloc = context.read(readingDetailBlocProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                  'Fotografía del medidor${bloc.claseAnomalia.fotografia || (bloc.requiredPhotoByMeterReading ?? false) ? '*' : ''}',
                  style: theme.textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold, color: theme.primaryColor)),
            ),
          ),
          StreamBuilder<List<ReadingImagesModel>?>(
              stream: bloc.getReadingImagesByReadingId(widget.readingId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Offstage();
                }
                bloc.readingDetailItem.readingRequest.fotos.clear();

                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildCaptureImage(snapshot),
                        if (snapshot.hasData)
                          ...snapshot.data
                                  ?.map((readingImagesModel) =>
                                      _buildImageView(readingImagesModel))
                                  .toList() ??
                              [Offstage()]
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildCaptureImage(AsyncSnapshot<List<ReadingImagesModel>?> snapshot) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = _getTheme();
    final bloc = context.read(readingDetailBlocProvider);

    countImages = 0;

    if (snapshot.hasData) {
      countImages = snapshot.data?.length ?? 0;
    }
    return countImages == 3 ||
            bloc.readingDetailItem.readingRequest.alreadySync ||
            !bloc.allowEdit()
        ? bloc.readingDetailItem.readingRequest.alreadySync && countImages == 0
            ? Text('Sin fotografías')
            : Offstage()
        : Container(
            width: screenWidth * .26,
            height:
                screenHeight < 600 ? screenHeight * .16 : screenHeight * .13,
            margin: EdgeInsets.only(right: 12, left: 4),
            child: DottedBorder(
              color: theme.primaryColor,
              strokeWidth: 1,
              dashPattern: [7],
              borderType: BorderType.RRect,
              padding: EdgeInsets.all(12),
              radius: Radius.circular(12),
              child: Center(
                child: _buildCaptureImageContainer(snapshot),
              ),
            ),
          );
  }

  Widget _buildCaptureImageContainer(
      AsyncSnapshot<List<ReadingImagesModel>?> snapshot) {
    final theme = _getTheme();

    return ClipRRect(
      child: InkWell(
        onTap: countImages == 3 ? null : _onTapCaptureImage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: theme.primaryColor,
            ),
            Text(
              'Capturar',
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: MediaQuery.of(context).size.height < 600 ? 12 : 14),
            )
          ],
        ),
      ),
    );
  }

  void _onTapCaptureImage() async {
    final bloc = context.read(readingDetailBlocProvider);

    final image = await _captureImageAndReadAsBytes();
    if (image == null) return;

    final readingImageModel =
        ReadingImagesModel(imageCount: countImages, readingId: widget.readingId)
          ..imageBase64 = Base64Encoder().convert(image);

    bloc.readingDetailItem.readingRequest.fotos
        .add(readingImageModel.getSpecialId());

    await bloc.insertReadingImage(readingImageModel);
  }

  Future<Uint8List?> _captureImageAndReadAsBytes() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return null;

      return new File(image.path).readAsBytesSync();
    } on Exception catch (e, stackTrace) {
      log('Error al capturar imagen', error: e, stackTrace: stackTrace);
    }
  }

  Widget _buildImageView(ReadingImagesModel readingImagesModel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bloc = context.read(readingDetailBlocProvider);

    final theme = _getTheme();

    bloc.readingDetailItem.readingRequest.fotos
        .add(readingImagesModel.getSpecialId());

    return Stack(
      children: [
        InkWell(
          onTap: bloc.readingDetailItem.readingRequest.alreadySync ||
                  !bloc.allowEdit()
              ? null
              : () async => await _onTapImageView(readingImagesModel, bloc),
          child: Container(
            width: screenWidth * .23,
            height: screenHeight * .13,
            margin: EdgeInsets.only(right: 12),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  Base64Decoder().convert(readingImagesModel.imageBase64),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Positioned(
          right: 5,
          top: -10,
          child: bloc.readingDetailItem.readingRequest.alreadySync ||
                  !bloc.allowEdit()
              ? Offstage()
              : IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: theme.errorColor,
                  ),
                  onPressed: () async {
                    await bloc.deleteReadingImage(readingImagesModel);
                    bloc.readingDetailItem.readingRequest.fotos
                        .remove(readingImagesModel.getSpecialId());
                  }),
        ),
      ],
    );
  }

  ThemeData _getTheme() => Theme.of(context);

  Future<void> _onTapImageView(
      ReadingImagesModel readingImagesModel, ReadingDetailBloc bloc) async {
    final image = await _captureImageAndReadAsBytes();

    if (image == null) return;

    readingImagesModel
      ..imageCount = countImages
      ..imageBase64 = Base64Encoder().convert(image);

    bloc.readingDetailItem.readingRequest.fotos
        .add(readingImagesModel.getSpecialId());

    await bloc.updateReadingImage(readingImagesModel);
  }
}
