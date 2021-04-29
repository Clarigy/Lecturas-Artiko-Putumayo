import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';
import 'package:artiko/features/profile/presentation/pages/widgets/exports.dart';
import 'package:artiko/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'exports/profile_labels.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage._();

  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => sl<ProfileBloc>(),
      builder: (_, __) => ProfilePage._(),
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterLayout());

    super.initState();
  }

  void afterLayout() async {
    await context.read<ProfileBloc>().getCurrentUserFromDb();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final bloc = Provider.of<ProfileBloc>(context);

    print('El usuario es: ${bloc.currentUser?.nombre ?? 'NoHay'}');

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
      body: bloc.profileState == ProfileState.loading
          ? CircularProgressIndicator()
          : Column(
              children: [ProfileHeader(), ProfileForm()],
            ),
    );
  }

  @override
  void dispose() {
    Provider.of<ProfileBloc>(context, listen: false).dispose();
    super.dispose();
  }
}
