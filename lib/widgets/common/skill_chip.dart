import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';

/// One skill chip: brand-colored icon badge + skill name.
/// Used in the Skills section, grouped under category headings.
class SkillChip extends StatelessWidget {
  final String assetPath;
  final Color iconColor;
  final String label;
  final bool themeAdaptiveIcon;

  const SkillChip({
    super.key,
    required this.assetPath,
    required this.iconColor,
    required this.label,
    this.themeAdaptiveIcon = false,
  });

  Color _resolveIconColor(BuildContext context) {
    if (!themeAdaptiveIcon) return iconColor;
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedIconColor = _resolveIconColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: SvgPicture.asset(
              assetPath,
              colorFilter: ColorFilter.mode(resolvedIconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
