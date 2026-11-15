// FLauncher - Copyright (C) 2021 Étienne Fesser - GPL-3.0

import 'package:flauncher/providers/apps_service.dart';
import 'package:flauncher/widgets/app_card.dart';
import 'package:flauncher/widgets/category_container_common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app.dart';
import '../models/category.dart';
import '../providers/settings_service.dart';

class CategoryRow extends StatelessWidget
{
  final Category category;
  final List<App> applications;

  CategoryRow({
    Key? key,
    required this.category,
    required this.applications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget categoryContent;
    if (applications.isEmpty) {
      categoryContent = categoryContainerEmptyState(context);
    }
    else {
      categoryContent = Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151517),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: SizedBox(
          height: category.rowHeight.toDouble(),
          child: ListView.custom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            childrenDelegate: SliverChildBuilderDelegate(
              childCount: applications.length,
              findChildIndexCallback: _findChildIndex,
              (context, index) => Padding(
                  key: Key(applications[index].packageName),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppCard(
                    category: category,
                    application: applications[index],
                    autofocus: index == 0,
                    onMove: (direction) => _onMove(context, direction, index),
                    onMoveEnd: () => _onMoveEnd(context)
                  )
              )
            )
          )
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<SettingsService, bool>(
          selector: (context, service) => service.showCategoryTitles,
          builder: (context, showCategoriesTitle, _) {
            if (showCategoriesTitle) {
              return Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 8),
                child: Text(category.name.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(letterSpacing: 2, color: Colors.white60)
                ),
              );
            }

            return SizedBox.shrink();
          }
        ),
        categoryContent
      ],
    );
  }

  int _findChildIndex(Key key) =>
      applications.indexWhere((app) => app.packageName == (key as ValueKey<String>).value);

  void _onMove(BuildContext context, AxisDirection direction, int index) {
    int newIndex = 0;

    if (direction == AxisDirection.right && index < applications.length - 1) {
      newIndex = index + 1;
    } else if (direction == AxisDirection.left && index > 0) {
      newIndex = index - 1;
    } else {
      return;
    }

    final appsService = context.read<AppsService>();
    appsService.reorderApplication(category, index, newIndex);
  }

  void _onMoveEnd(BuildContext context) {
    final appsService = context.read<AppsService>();
    appsService.saveApplicationOrderInCategory(category);
  }
}
