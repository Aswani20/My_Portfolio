import 'package:flutter/material.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_assets.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const String heading = 'Skills';
  static const String subtitle = 'Technologies and tools I work with regularly.';

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'Mobile Development',
      'skills': [
        {'asset': AppAssets.iconFlutter, 'color': Color(0xFF4479A1), 'label': 'Flutter'},
        {'asset': AppAssets.iconDart, 'color': Color(0xFF4479A1), 'label': 'Dart'},
        {'asset': AppAssets.iconFirebase, 'color': Color(0xFFFFCA28), 'label': 'Firebase'},
      ],
    },
    {
      'title': 'Backend & Database',
      'skills': [
        {'asset': AppAssets.iconPhp, 'color': Color(0xFF777BB4), 'label': 'PHP'},
        {'asset': AppAssets.iconLaravel, 'color': Color(0xFFFF2D20), 'label': 'Laravel'},
        {'asset': AppAssets.iconMysql, 'color': Color(0xFF4479A1), 'label': 'MySQL'},
      ],
    },
    {
      'title': 'Game Development',
      'skills': [
        {'asset': AppAssets.iconUnity, 'color': Color(0xFF3A3A3A), 'label': 'Unity', 'themeAdaptive': true},
        {'asset': AppAssets.iconUnrealEngine, 'color': Color(0xFF0E1128), 'label': 'Unreal Engine', 'themeAdaptive': true},
        {'asset': AppAssets.iconCplusplus, 'color': Color(0xFF777BB4), 'label': 'C++'},
        {'asset': AppAssets.iconCsharp, 'color': Color(0xFF5400B1), 'label': 'C#'},
        {'asset': AppAssets.iconBlueprint, 'color': Color(0xFFFFCA28), 'label': 'Blueprint'},
      ],
    },
    {
      'title': 'Tools',
      'skills': [
        {'asset': AppAssets.iconGit, 'color': Color(0xFFF05032), 'label': 'Git'},
        {'asset': AppAssets.iconGithub, 'color': Color(0xFF181717), 'label': 'GitHub', 'themeAdaptive': true},
        {'asset': AppAssets.iconFigma, 'color': Color(0xFFF24E1E), 'label': 'Figma'},
        {'asset': AppAssets.iconPostman, 'color': Color(0xFFFF6C37), 'label': 'Postman'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final colors = context.colors;

    return SectionContainer(
      sectionKey: const ValueKey('skills'),
      compact: true,
      backgroundColor: colors.surface.withOpacity(0.4),
      child: Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: Text(
              heading,
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          ScrollReveal(
            delay: const Duration(milliseconds: 80),
            child: Text(
              subtitle,
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
          ),
          const SizedBox(height: 40),
          for (var c = 0; c < categories.length; c++) ...[
            ScrollReveal(
              delay: ScrollReveal.stagger(c, stepMs: 70),
              child: Text(
                categories[c]['title'] as String,
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.accent),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < (categories[c]['skills'] as List).length; i++)
                  ScrollReveal(
                    delay: ScrollReveal.stagger(c * 3 + i, stepMs: 60),
                    scaleFrom: 0.92,
                    child: SkillChip(
                      assetPath: (categories[c]['skills'] as List<Map<String, dynamic>>)[i]['asset'] as String,
                      iconColor: (categories[c]['skills'] as List<Map<String, dynamic>>)[i]['color'] as Color,
                      label: (categories[c]['skills'] as List<Map<String, dynamic>>)[i]['label'] as String,
                      themeAdaptiveIcon: (categories[c]['skills'] as List<Map<String, dynamic>>)[i]['themeAdaptive'] as bool? ?? false,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}
