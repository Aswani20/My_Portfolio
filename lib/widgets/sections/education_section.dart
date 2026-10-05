import 'package:flutter/material.dart';
import 'package:portfolio_app/models/education.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/widgets/common/education_timeline_item.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  static const String heading = 'Education';
  static const String subtitle = 'My academic background and qualifications.';

  // ---- Placeholder content — swap these for your real education ----
  static const List<Education> educationList = [
    Education(
      degree: 'Backend Diploma (PHP & Laravel)',
      institution: 'Route Academy',
      duration: 'Fab 2026 - Present',
      location: 'Online',
      isCurrent: true,
    ),
    Education(
      degree: 'Flutter Advanced bootcamp',
      institution: 'Elevate Tech',
      duration: 'July 2025 - Nov 2025',
      location: 'Online',
    ),
    Education(
      degree: 'Flutter diploma',
      institution: 'Route Academy',
      duration: 'July 2023 - Nov 2023',
      location: 'Alexandria Branch',
    ),
    Education(
      degree: 'Front End & Cross-platform ITP Track',
      institution: 'Information technology Institute (ITI)',
      duration: 'April 2022 - Aug 2022',
      location: 'Alexandria, Egypt',
    ),
    Education(
      degree: 'Bachelor Of Science in Physics and Computer Science',
      institution: 'Helwan University',
      duration: '2015 — 2019',
      location: 'Cairo, Egypt',
    ),
  ];
  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final colors = context.colors;

    return SectionContainer(
      sectionKey: const ValueKey('education'),
      compact: true,
      backgroundColor: colors.surface.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
          for (var i = 0; i < educationList.length; i++)
            ScrollReveal(
              delay: ScrollReveal.stagger(i, stepMs: 100),
              slideFrom: const Offset(-18, 18),
              child: EducationTimelineItem(
                education: educationList[i],
                isLast: i == educationList.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}
