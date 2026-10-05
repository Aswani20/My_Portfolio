import 'package:flutter/material.dart';
import 'package:portfolio_app/models/experience.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/timeline_item.dart';


class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const String heading = 'Experience';
  static const String subtitle = 'Where I\'ve worked and what I did there.';

  // ---- Placeholder content — swap these for your real work history ----
  static const List<Experience> experiences = [
    Experience(
      role: 'Software Developer',
      company: 'Bibliotheca Alexandrina',
      duration: 'Jan 2024 — Present',
      location: 'Alexandria, Egypt',
      isCurrent: true,
      highlights: [
        'Created immersive 3D and VR environments with Virtual Immersive Scientific and Technological Applications (VISTA) team',
        'Aimed at aiding researchers in visualizing data, employing both Unreal Engine and Unity. ',
        'Collaborated with researchers to grasp their requirements and transform them into practical, user-centric virtual environments. ',
      ],
    ),
    Experience(
      role: 'Senior Flutter Mentor',
      company: 'Route Academy',
      duration: 'May 2024 – Present',
      location: 'Alexandria, Egypt',
      isCurrent: true,
      highlights: [
        'My responsibility is to guide students in route by teaching flutter.',
        'mark and review their code and send them feedback to enhance their code and teach them extra and advanced topics.',
      ],
    ),
    Experience(
      role: 'Teaching Assistant',
      company: 'Egypt-Japan University of Science and Technology',
      duration: 'Oct 2022 – Jan 2024',
      location: 'Borg el_arab, Alexandria, Egypt',
      highlights: [
        'My responsibility is to guide students in the Computer Science field.',
        ' teaching Software Engineering, Fundamental of programming, Advanced programming and OOP Concept, Operating Systems, \nhow to use Linux and interact with command line, Embedded Systems, Network and Computer Graphics.',
      ],
    ),
  ];
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final colors = context.colors;

    return SectionContainer(
      sectionKey: const ValueKey('experience'),
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
          for (int i = 0; i < experiences.length; i++)
            ScrollReveal(
              delay: ScrollReveal.stagger(i, stepMs: 100),
              slideFrom: const Offset(-18, 18),
              child: TimelineItem(
                experience: experiences[i],
                isLast: i == experiences.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}
