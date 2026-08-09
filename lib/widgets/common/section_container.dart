import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Shared max-width wrapper so every section and the navbar line up on the
/// same left/right edges.
class ContentWidth extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignment;

  const ContentWidth({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSpacing.maxContentWidth,
        ),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}

/// Wraps every section (Hero, About, Skills, etc.) so they all share the
/// same max width, horizontal centering, and vertical rhythm.
///
/// Usage:
/// SectionContainer(
///   backgroundColor: AppColors.surface,
///   child: Column(children: [...]),
/// )
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Key? sectionKey; // used for scroll-to-section navigation later
  final bool compact;

  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.sectionKey,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: backgroundColor ?? Colors.transparent,
      padding: EdgeInsets.symmetric(
        vertical: compact
            ? (isMobile
                ? AppSpacing.sectionVerticalPaddingCompactMobile
                : AppSpacing.sectionVerticalPaddingCompact)
            : (isMobile
                ? AppSpacing.sectionVerticalPaddingMobile
                : AppSpacing.sectionVerticalPadding),
        horizontal: isMobile
            ? AppSpacing.horizontalPaddingMobile
            : AppSpacing.horizontalPaddingDesktop,
      ),
      child: ContentWidth(child: child),
    );
  }
}
