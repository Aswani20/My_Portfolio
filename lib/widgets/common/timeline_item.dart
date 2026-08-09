import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/experience.dart';

/// One entry in the experience timeline: a marker (dot + connecting line)
/// on the left, role/company/duration/highlights on the right.
/// [isLast] hides the connecting line below the final entry.
class TimelineItem extends StatelessWidget {
  final Experience experience;
  final bool isLast;

  const TimelineItem({super.key, required this.experience, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Marker column: dot + vertical connecting line.
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: experience.isCurrent ? colors.accent : colors.surface,
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
          // Content card.
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
                          experience.role,
                          style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.textPrimary),
                        ),
                        if (experience.isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.accent.withOpacity(0.12),
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
                      experience.company,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${experience.duration} · ${experience.location}',
                      style: AppTextStyles.body.copyWith(fontSize: 13, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    ...experience.highlights.map(
                          (point) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                point,
                                style: AppTextStyles.body.copyWith(fontSize: 14, color: colors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
