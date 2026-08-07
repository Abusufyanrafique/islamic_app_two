import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';

class HolySearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onMenuTap;
  final ValueChanged<String>? onChanged;

  const HolySearchBar({
    super.key,
    this.hintText = 'Hinted search text',
    this.onMenuTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(52),
      decoration: BoxDecoration(
        color: AppColors.labbaik,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: AppColors.hinttext),
            onPressed: onMenuTap,
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.hinttext),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.hinttext),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: getWidth(16)),
            child: Icon(Icons.search, color: AppColors.hinttext),
          ),
        ],
      ),
    );
  }
}