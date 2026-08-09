import 'package:flutter/material.dart';
import 'package:portfolio_app/models/education.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationTimelineItem extends StatelessWidget {
  final Education education;
  final bool isLast;

  const EducationTimelineItem({
    super.key,
    required this.education,
    this.isLast = false,
  });

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: education.isCurrent ? colors.accent : colors.surface,
                  border: Border.all(color: colors.accent, width: 2.5),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: colors.border),
                ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 36),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          education.degree,
                          style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.textPrimary),
                        ),
                        if (education.isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Current',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colors.accent,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.institution,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${education.duration} · ${education.location}',
                      style: AppTextStyles.body.copyWith(fontSize: 13, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    if (education.certificateUrl != null) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => _openUrl(education.certificateUrl!),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_outlined, size: 16, color: colors.textPrimary),
                              const SizedBox(width: 6),
                              Text(
                                'View Certificate',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
