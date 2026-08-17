import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'AllColors.dart';
import 'SizeConfig.dart';



// ─── Toast Helper ──────────────────────────────────────────────────
OverlayEntry? _currentToastEntry;

void _showAppToast(
  BuildContext context,
   String message, _ToastType type) {
  _currentToastEntry?.remove();

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: _AppToast(
          message: message,
           type: type,
           ),
      ),
    ),
  );

  _currentToastEntry = entry;
  Overlay.of(context).insert(entry);

  Future.delayed(const Duration(milliseconds: 3800), () {
    entry.remove();
    _currentToastEntry = null;
  });
}

enum _ToastType { success, error, info }

class _AppToast extends StatefulWidget {
  final String message;
  final _ToastType type;
  const _AppToast({required this.message, required this.type});

  @override
  State<_AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<_AppToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _ctrl.reverse();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _toastConfig(widget.type);
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          margin:  EdgeInsets.symmetric(
            horizontal: getWidth(20), 
            vertical: getHeight(12),
            ),
          padding:  EdgeInsets.symmetric(
            horizontal: getWidth(16),
             vertical: getHeight(14),
             ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: cfg.accentColor.withOpacity(0.35),
                 width: 1.2),
            boxShadow: [
              BoxShadow(
                color: cfg.accentColor.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                height: getHeight(42),
                width: getWidth(42),
                decoration: BoxDecoration(
                  color: cfg.accentColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  cfg.icon, 
                  color: cfg.accentColor,
                   size: 20,
                   ),
              ),
               SizedBox(width: getWidth(12)),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cfg.label,
                      style:AppColors().customTextStyleBold16().copyWith(
                         fontSize: getFont(16),
                        fontWeight: FontWeight.w700,
                        color: cfg.accentColor,
                        letterSpacing: 0.2,
                      )
                    ),
                     SizedBox(height: getHeight(3)),
                    Text(
                      widget.message,
                      style:AppColors().customTextStyle14().copyWith(
                         fontSize: getFont(14),
                        color: Color(0xff4A4A4A),
                        height: 1.4,
                      )
                    ),
                  ],
                ),
              ),
              // Right bar
              Container(
                height: getHeight(36),
                width: getWidth(4),
                decoration: BoxDecoration(
                  color: cfg.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ToastConfig _toastConfig(_ToastType type) {
    switch (type) {
      case _ToastType.success:
        return _ToastConfig(
          icon: Icons.check_circle_rounded,
          accentColor: const Color(0xff5BC0BE),
          label: 'Success',
        );
      case _ToastType.error:
        return _ToastConfig(
          icon: Icons.cancel_rounded,
          accentColor: const Color(0xffE57373),
          label: 'Error',
        );
      case _ToastType.info:
        return _ToastConfig(
          icon: Icons.info_rounded,
          accentColor: const Color(0xff4FC3F7),
          label: 'Info',
        );
    }
  }
}

class _ToastConfig {
  final IconData icon;
  final Color accentColor;
  final String label;
  _ToastConfig(
      {required this.icon, required this.accentColor, required this.label});
}

// ─── Public Functions (same naam, sirf context add hua) ────────────
void showErrorToast(BuildContext context, String message) =>
    _showAppToast(context, message, _ToastType.error);

void showSuccessToast(BuildContext context, String message) =>
    _showAppToast(context, message, _ToastType.success);

void showInfoToast(BuildContext context, String message) =>
    _showAppToast(context, message, _ToastType.info);


// ─── Baaki sab bilkul same ────────────────────────────────────────

OverlayEntry buildLoadingOverlay() {
  return OverlayEntry(
    builder: (context) => Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          width: getWidth(80),
          height: getHeight(80),
          decoration: BoxDecoration(
            color: AppColors.lightBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget loadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: AppColors.primaryColor,
      ),
  );
}

Widget bottomButton(
  VoidCallback ontap,
  String icon,
  String title,
) {
  return GestureDetector(
    onTap: ontap,
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon, 
          height: getHeight(22),
           width: getWidth(22),
           ),
         SizedBox(width: getWidth(8)),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
               fontSize: 16, 
               color: Colors.black),
        )
      ],
    ),
  );
}

Widget tabbutton(String title) {
  return Container(
    height: getHeight(36),
    width: getWidth(123),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white,
           width: 1)),
    alignment: Alignment.center,
    child: Text(
      title,
      style: AppColors().customTextStyleBold16(),
    ),
  );
}

final spinkit = SpinKitSpinningLines(
  color: AppColors.primaryColor,
  size: 50.0,
);