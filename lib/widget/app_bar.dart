import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/helper/navigator_helper.dart';

class AppBarPlayer extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPlayer({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    // this.leadingShowing = true,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  // final bool leadingShowing;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: title,
      centerTitle: false,
      titleSpacing: 0,
      actions: actions,
      leading: leading ?? AppBar().leading,
      // (Navigator.canPop(context)
      //     ? InkWell(
      //         onTap: () => NavigatorHelper().popBack(),
      //         child: const Icon(Icons.arrow_back),
      //       )
      //     : null),
      // leadingWidth: leadingShowing ? 56 : 0,
    );
  }
}
