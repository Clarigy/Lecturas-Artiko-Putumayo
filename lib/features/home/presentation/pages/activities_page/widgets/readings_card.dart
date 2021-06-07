import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/exports/images_path.dart';
import 'package:artiko/shared/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadingsCard extends StatelessWidget {
  final ReadingDetailItem item;

  const ReadingsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(item: item),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadingInformation(
                      item: item,
                    ),
                    Expanded(child: Offstage()),
                    _TypeOfConsumption(
                      tipoConsumo: item.tipoConsumo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final ReadingDetailItem item;

  const _CardHeader({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          color: item.tipoMedidor == 'EM-ELECTROMECANICO'
              ? AppColors.primary
              : AppColors.secondary,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Container(
                  width: width * .8,
                  child: Text(
                    'No. medidor ${item.numeroMedidor}',
                    style: theme.textTheme.subtitle1!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Text('001258 - 0001'),
              Expanded(child: Offstage()),
              if (item.indicadorSuspension) SvgPicture.asset(IMAGE_CUT)
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadingInformation extends StatelessWidget {
  final ReadingDetailItem item;

  const _ReadingInformation({required this.item});

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
              Text(item.nombre),
              Text(item.direccion),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeOfConsumption extends StatelessWidget {
  final String tipoConsumo;

  const _TypeOfConsumption({required this.tipoConsumo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6),
      width: 40,
      height: 40,
      child: Center(
        child: Text(
          tipoConsumo == 'ENA' ? 'A' : 'R',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(100)),
    );
  }
}
