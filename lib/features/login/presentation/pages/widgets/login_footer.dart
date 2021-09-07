import 'package:artiko/features/login/presentation/pages/exports/images_path.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * .18,
      width: size.width,
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(
                  top: size.width * .15, bottom: size.width * .02),
              child: Center(child: Image.asset(IMAGE_ARTIKO))),
          Positioned(
            right: -size.width * .109,
            top: size.height * .071,
            child: InkWell(
              onTap: () async => await _launchURL(),
              child: Container(
                width: size.width * .25,
                height: size.height * .142,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(
                        right: size.width * .06, bottom: size.height * .01),
                    child: Icon(
                      Icons.call,
                      color: theme.secondaryHeaderColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchURL() async => await canLaunch('tel: 3212433232')
      ? await launch('tel: 3212433232')
      : throw 'Could not launch phone';
}
