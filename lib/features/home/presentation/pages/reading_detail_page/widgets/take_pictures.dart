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
  @override
  Widget build(BuildContext context) {
    final bloc = context.read(readingDetailBlocProvider);

    final theme = Theme.of(context);

    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text('Fotografía del medidor',
                style: theme.textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ),
          StreamBuilder<List<ReadingImagesModel>?>(
              stream: bloc.getReadingImagesByReadingId(widget.readingId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Offstage();
                }

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

    return Container(
      width: screenWidth * .2,
      height: screenHeight * .1,
      margin: EdgeInsets.only(right: 12, left: 4),
      child: DottedBorder(
        color: theme.primaryColor,
        strokeWidth: 1,
        dashPattern: [7],
        borderType: BorderType.RRect,
        padding: EdgeInsets.all(12),
        radius: Radius.circular(12),
        child: Container(
          child: _buildCaptureImageContainer(snapshot),
        ),
      ),
    );
  }

  Widget _buildCaptureImageContainer(
      AsyncSnapshot<List<ReadingImagesModel>?> snapshot) {
    final theme = _getTheme();
    int countImages = 0;

    if (snapshot.hasData) {
      countImages = snapshot.data?.length ?? 0;
    }

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
              style: TextStyle(color: theme.primaryColor),
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
        ReadingImagesModel(image: image, readingId: widget.readingId);

    await bloc.insertReadingImage(readingImageModel);
  }

  Future<Uint8List?> _captureImageAndReadAsBytes() async {
    final image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 10);

    if (image == null) return null;

    return await image.readAsBytes();
  }

  Widget _buildImageView(ReadingImagesModel readingImagesModel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bloc = context.read(readingDetailBlocProvider);

    final theme = _getTheme();

    return Stack(
      children: [
        InkWell(
          onTap: () async => await _onTapImageView(readingImagesModel, bloc),
          child: Container(
            width: screenWidth * .2,
            height: screenHeight * .1,
            margin: EdgeInsets.only(right: 12),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  readingImagesModel.image,
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Positioned(
          right: 5,
          top: -10,
          child: IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: theme.errorColor,
              ),
              onPressed: () async {
                await bloc.deleteReadingImage(readingImagesModel);
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

    readingImagesModel.image = image;
    await bloc.updateReadingImage(readingImagesModel);
  }
}
