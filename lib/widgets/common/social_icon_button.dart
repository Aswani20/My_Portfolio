import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';

/// Circular social-link button used in the Contact section's social row.
class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final String tooltip;

  const SocialIconButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
            border: Border.all(color: colors.border),
          ),
          child: SvgPicture.asset(
            assetPath,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
