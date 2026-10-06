import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_assets.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';
import 'package:portfolio_app/widgets/common/cta_buttons.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';
import 'package:portfolio_app/widgets/common/spider_web_background.dart';

class HeroSection extends StatelessWidget {
  final void Function(String sectionId)? onScrollToSection;

  const HeroSection({super.key, this.onScrollToSection});

  void _scrollToProjects() {
    onScrollToSection?.call(AppStrings.projects);
  }

  void _scrollToContact() {
    onScrollToSection?.call(AppStrings.contact);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final useSideBySide = AppBreakpoints.isDesktop(width);
    final colors = context.colors;

    final photo = ScrollReveal(
      animateOnMount: true,
      slideFrom: const Offset(0, 24),
      scaleFrom: 0.94,
      child: _HeroPhoto(photoPath: AppAssets.photoPath, size: isMobile ? 220 : 320),
    );

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScrollReveal(
          animateOnMount: true,
          delay: Duration(milliseconds: 120),
          child: _HeroCodeInfo(name: AppStrings.name, title: AppStrings.title),
        ),
        const SizedBox(height: 32),
        ScrollReveal(
          animateOnMount: true,
          delay: const Duration(milliseconds: 240),
          child: SizedBox(
            width: isMobile ? double.infinity : 480,
            child: Text(
              AppStrings.tagline,
              textAlign: TextAlign.left,
              style: AppTextStyles.bodyLarge.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: 36),
        ScrollReveal(
          animateOnMount: true,
          delay: const Duration(milliseconds: 360),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 16,
            runSpacing: 16,
            children: [
              PrimaryButton(
                label: AppStrings.viewWork,
                icon: Icons.arrow_forward,
                onPressed: _scrollToProjects,
              ),
              SecondaryButton(
                label: AppStrings.getInTouch,
                onPressed: _scrollToContact,
              ),
            ],
          ),
        ),
      ],
    );

    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(child: SpiderWebBackground()),
        ),
        SectionContainer(
          child: useSideBySide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: textColumn),
                    const SizedBox(width: 48),
                    photo,
                  ],
                )
              : Column(children: [photo, const SizedBox(height: 40), textColumn]),
        ),
      ],
    );
  }
}

class _HeroCodeInfo extends StatelessWidget {
  final String name;
  final String title;

  const _HeroCodeInfo({
    required this.name,
    required this.title,
  });

  static const double _indent = 24;

  static String _cleanText(String value) => value.replaceAll('\t', '').trim();

  static double _lerpByWidth(double width, double minWidth, double maxWidth, double min, double max) {
    if (width <= minWidth) return min;
    if (width >= maxWidth) return max;
    final t = (width - minWidth) / (maxWidth - minWidth);
    return min + (max - min) * t;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final colors = context.colors;
        final indent = _lerpByWidth(maxWidth, 320, 1024, 10, _indent);
        final contentIndent = indent * 3;
        final titleIndent = indent * 2;

        final tagStyle = TextStyle(
          fontFamily: AppStrings.monospaceFont,
          fontSize: _lerpByWidth(maxWidth, 320, 1024, 11, 15),
          color: colors.textSecondary.withValues(alpha: 0.55),
          height: 1.6,
        );

        final monoBody = TextStyle(
          fontFamily: AppStrings.monospaceFont,
          fontSize: _lerpByWidth(maxWidth, 320, 1024, 14, 18),
          color: colors.textPrimary,
          height: 1.4,
        );

        final nameStyle = monoBody.copyWith(
          fontSize: _lerpByWidth(maxWidth, 320, 1024, 24, 52),
          fontWeight: FontWeight.w700,
          color: colors.accent,
          height: 1.1,
        );

        final greetingStyle = TextStyle(
          fontSize: _lerpByWidth(maxWidth, 320, 1024, 22, 56),
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.2,
        );

        final displayName = _cleanText(name);
        final displayTitle = _cleanText(title);

        return SizedBox(
          width: maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CodeTag(AppStrings.columnWidget, style: tagStyle),
              _CodeTag(AppStrings.children, style: tagStyle, indent: indent),
              Padding(
                padding: EdgeInsets.only(left: contentIndent),
                child: SizedBox(
                  width: maxWidth - contentIndent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CodeTag(AppStrings.textWidget, style: tagStyle),
                      Text(
                        AppStrings.hello,
                        softWrap: true,
                        style: greetingStyle,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          displayName,
                          style: nameStyle,
                        ),
                      ),
                      _CodeTag(AppStrings.closingBrackets, style: tagStyle),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: titleIndent),
                child: SizedBox(
                  width: maxWidth - titleIndent,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _CodeTag(
                        AppStrings.textWidget,
                        style: tagStyle,
                        indent: indent,
                      ),
                      Text(displayTitle, style: monoBody, softWrap: true),
                      _CodeTag(AppStrings.closingBrackets, style: tagStyle),
                    ],
                  ),
                ),
              ),
              _CodeTag(AppStrings.closingSquareBrackets, style: tagStyle, indent: indent),
              _CodeTag(AppStrings.closingBrackets, style: tagStyle),
            ],
          ),
        );
      },
    );
  }
}

class _CodeTag extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double indent;

  const _CodeTag(
    this.text, {
    required this.style,
    this.indent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          textAlign: TextAlign.left,
          softWrap: true,
          style: style,
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatefulWidget {
  final String photoPath;
  final double size;

  const _HeroPhoto({required this.photoPath, required this.size});

  @override
  State<_HeroPhoto> createState() => _HeroPhotoState();
}

class _HeroPhotoState extends State<_HeroPhoto> with SingleTickerProviderStateMixin {
  late final AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconCount = AppAssets.heroOrbitIcons.length;
    final iconSize = widget.size * 0.13;
    final orbitRadius = widget.size / 2 + iconSize * 0.75;
    final canvasSize = orbitRadius * 2 + iconSize;
    final gapRadians =
        (iconSize / orbitRadius + 0.14).clamp(0.32, 0.48);

    return SizedBox(
      width: canvasSize,
      height: canvasSize,
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (context, _) {
          final rotation = _orbitController.value * 2 * math.pi;
          const startAngle = -math.pi / 2;
          final sectorAngle = 2 * math.pi / iconCount;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  size: Size(canvasSize, canvasSize),
                  painter: _OrbitRingPainter(
                    radius: orbitRadius,
                    iconCount: iconCount,
                    gapRadians: gapRadians,
                    color: colors.textPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ),
              for (var i = 0; i < iconCount; i++)
                Transform.translate(
                  offset: Offset(
                    math.cos(startAngle + i * sectorAngle + rotation) *
                        orbitRadius,
                    math.sin(startAngle + i * sectorAngle + rotation) *
                        orbitRadius,
                  ),
                  child: _OrbitIcon(
                    assetPath: AppAssets.heroOrbitIcons[i],
                    size: iconSize,
                    backgroundColor: colors.background,
                    borderColor: colors.textPrimary.withValues(alpha: 0.25),
                  ),
                ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.accent.withValues(alpha: 0.15),
                  border: Border.all(color: colors.border, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  widget.photoPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.medium,
                  cacheWidth: (MediaQuery.devicePixelRatioOf(context) * widget.size).round(),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person_outline,
                      size: widget.size * 0.45,
                      color: colors.textSecondary,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color backgroundColor;
  final Color borderColor;

  const _OrbitIcon({
    required this.assetPath,
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.18),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SvgPicture.asset(assetPath, fit: BoxFit.contain,),
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  final double radius;
  final int iconCount;
  final double gapRadians;
  final Color color;

  const _OrbitRingPainter({
    required this.radius,
    required this.iconCount,
    required this.gapRadians,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const startAngle = -math.pi / 2;
    final sectorAngle = 2 * math.pi / iconCount;
    final segmentRadians = sectorAngle - gapRadians;

    for (var i = 0; i < iconCount; i++) {
      final arcStart = startAngle + i * sectorAngle + gapRadians / 2;
      final rect = Rect.fromCircle(center: center, radius: radius);

      canvas.drawArc(rect, arcStart, segmentRadians, false, ringPaint);

      final startPoint = Offset(
        center.dx + radius * math.cos(arcStart),
        center.dy + radius * math.sin(arcStart),
      );
      final endPoint = Offset(
        center.dx + radius * math.cos(arcStart + segmentRadians),
        center.dy + radius * math.sin(arcStart + segmentRadians),
      );
      canvas.drawCircle(startPoint, 2.2, dotPaint);
      canvas.drawCircle(endPoint, 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.iconCount != iconCount ||
        oldDelegate.gapRadians != gapRadians ||
        oldDelegate.color != color;
  }
}
