import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_service.dart';
import 'greeting_clock.dart';
import 'network_widget.dart';

const double _barHeight = 96;

class FocusAwareAppBar extends StatefulWidget implements PreferredSizeWidget
{
  @override
  State<StatefulWidget> createState() {
    return _FocusAwareAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(_barHeight);
}

class _FocusAwareAppBarState extends State<FocusAwareAppBar>
{
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsService, bool>(
      selector: (_, settings) => settings.autoHideAppBarEnabled,
      builder: (context, autoHide, widget) {
        if (autoHide) {
          return Focus(
            canRequestFocus: false,
            child: AnimatedContainer(
              curve: Curves.decelerate,
              duration: Duration(milliseconds: 250),
              height: focused ? _barHeight : 0,
              child: widget!
            ),
            onFocusChange: (hasFocus) {
              this.setState(() {
                focused = hasFocus;
              });
            }
          );
        }

        return widget!;
      },
      child: AppBar(
        toolbarHeight: _barHeight,
        centerTitle: false,
        titleSpacing: 32,
        title: const GreetingClock(),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(),
            splashRadius: 20,
            icon: const Icon(Icons.settings_outlined,
              shadows: [
                Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2))
              ],
            ),
            onPressed: () => showDialog(context: context, builder: (_) => const SettingsPanel()),
            focusColor: Theme.of(context).primaryColorLight,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 32),
            child: NetworkWidget(),
          ),
        ],
      )
    );
  }
}
