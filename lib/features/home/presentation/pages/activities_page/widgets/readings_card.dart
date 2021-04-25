import 'package:artiko/features/home/presentation/pages/activities_page/exports/images_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadingsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(),
            Divider(
              thickness: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReadingInformation(),
                Expanded(child: Offstage()),
                _TypeOfConsumption(),
                _TypeOfConsumption(),
                _TypeOfConsumption()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('001258 - 0001'),
        Expanded(child: Offstage()),
        SvgPicture.asset(IMAGE_CUT)
      ],
    );
  }
}

class _ReadingInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8),
            width: 6,
            height: 30,
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(30)),
          ),
          Column(
            children: [
              Text('001258 - 0001'),
              Text('001258 - 0001'),
              Text('001258 - 0001'),
              Text('001258 - 0001'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeOfConsumption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6),
      width: 40,
      height: 40,
      child: Center(
        child: Text(
          'R',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(100)),
    );
  }
}
