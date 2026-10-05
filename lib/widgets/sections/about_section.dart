import 'package:flutter/material.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';
import 'package:portfolio_app/widgets/common/personal_info_item.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';


class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  // ---- Placeholder content — swap these for your real info ----
  static const String heading = 'About Me';
  static const String bio =
      "I'm a developer who enjoys turning ideas into fast, polished "
      'products — from pixel-perfect interfaces to the logic that runs '
      'behind them. I care about clean code, good UX, and shipping things '
      'that actually get used.';

  static const List<Map<String, dynamic>> personalInfo = [
    {'icon': Icons.person_outline, 'label': 'Name', 'value': 'Abdelrahman Youssef'},
    {'icon': Icons.email_outlined, 'label': 'Email', 'value': 'abdelrahmanyoussef511997@gmail.com'},
    {'icon': Icons.phone_outlined, 'label': 'Phone', 'value': '+20 100 190 4592'},

  ];
  // ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final colors = context.colors;

    return SectionContainer(
      sectionKey:const ValueKey(AppStrings.about),
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
          const SizedBox(height: 20),
          ScrollReveal(
            delay: const Duration(milliseconds: 80),
            child: SizedBox(
              width: isMobile ? double.infinity : 700,
              child: Text(
                bio,
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 16,
            runSpacing: 16,
            children: [
              for (var i = 0; i < personalInfo.length; i++)
                ScrollReveal(
                  delay: ScrollReveal.stagger(i, stepMs: 90),
                  scaleFrom: 0.96,
                  child: PersonalInfoItem(
                    icon: personalInfo[i]['icon'] as IconData,
                    label: personalInfo[i]['label'] as String,
                    value: personalInfo[i]['value'] as String,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
