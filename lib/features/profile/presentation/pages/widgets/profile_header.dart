import 'dart:convert';

import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../dependency_injector.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final bloc = Provider.of<ProfileBloc>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(
          left: screenWidth * .1,
          right: screenWidth * .1,
          top: screenHeight * .05),
      width: screenWidth,
      child: Center(
        child: Column(
          children: [
            Text(
              bloc.currentUser?.nombre.toUpperCase() ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline6!.copyWith(fontSize: 18),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              bloc.currentUser?.idUsuario.toString() ?? '',
              style: theme.textTheme.bodyText2
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: screenWidth * .8,
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            FutureBuilder(
                future: sl<CacheStorageInterface>().fetch(CacheKeys.USER_PHOTO),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) return Offstage();
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.symmetric(vertical: screenHeight * .02),
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        image: MemoryImage(
                            Base64Decoder().convert(snapshot.data.toString())),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                      border: new Border.all(
                        color: theme.primaryColor,
                        width: 4.0,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
