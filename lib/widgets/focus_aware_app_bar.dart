import 'package:flauncher/widgets/settings/settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_service.dart';
import 'greeting_clock.dart';
import 'network_widget.dart';

const double _barHeight = 96;

class _Pill extends StatelessWidget {
  final Widget icon;
  final String? label;
  final VoidCallback onTap;

  const _Pill({required this.icon, required this.onTap, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Material(
        color: const Color(0xFF1C1C1E),
        shape: const StadiumBorder(side: BorderSide(color: Colors.white12)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          focusColor: Colors.white24,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                if (label != null) ...[
                  const SizedBox(width: 10),
                  Text(label!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: _barHeight,
        centerTitle: false,
        titleSpacing: 32,
        title: const GreetingClock(),
        actions: [
          _Pill(
            icon: const NetworkWidget(),
            onTap: () {},
          ),
          _Pill(
            icon: const Icon(Icons.settings, size: 20, color: Colors.white),
            label: 'Config.',
            onTap: () => showDialog(
                context: context, builder: (_) => const SettingsPanel()),
          ),
          const SizedBox(width: 32),
        ],
      )
    );
  }
}
