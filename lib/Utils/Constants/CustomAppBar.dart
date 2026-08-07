import 'package:flutter/material.dart';


import 'AllColors.dart';




class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool centerTitle;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  /// 🔹 Optional actions
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.centerTitle = true,
    this.leadingIcon,
    this.onLeadingTap,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.actions, // 👈 added
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,

      // 🔙 Back / Leading
      leading:
      // InkWell(
      //     onTap: ()=> Navigator.pop(context),
      //     child: Text(""),
      //     // child: Icon(Icons.arrow_back_ios)
      // ),


      showBack
          ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios))
          : leadingIcon != null
          ? IconButton(
        icon: Icon(leadingIcon, color: iconColor),
        onPressed: onLeadingTap,
      )
          : null,

      // 🏷 Title
      title: title != null
          ? Text(
          title!,
          style:AppColors().customTextStyleBold16()
      )
          : null,

      // 👉 Optional Actions
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class IconAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final bool centerTitle;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  /// Optional actions
  final List<Widget>? actions;

  /// 🔹 Add bottom parameter
  final PreferredSizeWidget? bottom;

  const IconAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.centerTitle = true,
    this.leadingIcon,
    this.onLeadingTap,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.actions,
    this.bottom, // 👈 added
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,

      // Back / Leading
      leading: showBack
          ? IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: iconColor),
      )
          : leadingIcon != null
          ? IconButton(
        icon: Icon(leadingIcon, color: iconColor),
        onPressed: onLeadingTap,
      )
          : null,

      // Title
      title: title != null
          ? Text(
        title!,
        style: AppColors()
            .customTextStyleBold16()
            .copyWith(color: textColor),
      )
          : null,

      // Actions
      actions: actions,

      // 🔹 bottom added
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}


//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final bool showBack;
//   final bool centerTitle;
//   final IconData? leadingIcon;
//   final VoidCallback? onLeadingTap;
//   final Color backgroundColor;
//   final Color iconColor;
//   final Color textColor;
//
//   const CustomAppBar({
//     super.key,
//     this.title,
//     this.showBack = true,
//     this.centerTitle = true,
//     this.leadingIcon,
//     this.onLeadingTap,
//     this.backgroundColor = Colors.white,
//     this.iconColor = Colors.black,
//     this.textColor = Colors.black,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//
//       backgroundColor: backgroundColor,
//       elevation: 0,
//       centerTitle: centerTitle,
//
//       // 🔙 Back button
//       leading: showBack
//           ? IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: SvgPicture.asset(
//           AllImages.backicon,
//           width: 20,
//           height: 20,
//           color: Colors.black,
//         ),
//       )
//
//           : leadingIcon != null
//           ? IconButton(
//         icon: Icon(leadingIcon, color: iconColor),
//         onPressed: onLeadingTap,
//       )
//           : null,
//
//
//
//
//       title: title != null
//           ? Text(
//         title!,
//         style: TextStyle(
//           color: textColor,
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//         ),
//       )
//           : null,
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }