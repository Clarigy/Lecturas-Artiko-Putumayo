import 'package:artiko/features/profile/presentation/pages/widgets/exports.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

import 'exports/profile_labels.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: DefaultAppBar(
        leadingWidth: screenWidth * .4,
        leading: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 18, right: 8),
              child: Icon(
                Icons.call,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            Text(LABEL_CALL)
          ],
        ),
      ),
      body: Column(
        children: [ProfileHeader(), ProfileForm()],
      ),
    );
  }
}
