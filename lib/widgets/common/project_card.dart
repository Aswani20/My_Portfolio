import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio_app/models/project.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';



class ProjectCard extends StatelessWidget {
  final Project project;
  final double width;

  const ProjectCard({super.key, required this.project, this.width = 340});

  static const double _contentHeight = 270;

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: isLightMode
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _ProjectImageSlider(imagePaths: project.imagePaths),
              ),
              SizedBox(
                height: _contentHeight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 66,
                        child: Text(
                          project.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(fontSize: 14, color: colors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 56,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.techStack
                                .map((tech) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: colors.accent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tech,
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: colors.accent,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              if (project.liveUrl != null)
                                _LinkButton(
                                  icon: Icons.open_in_new,
                                  label: 'Live Demo',
                                  onTap: () => _openUrl(project.liveUrl!),
                                ),
                              if (project.githubUrl != null)
                                _LinkButton(
                                  icon: Icons.code,
                                  label: 'GitHub',
                                  onTap: () => _openUrl(project.githubUrl!),
                                ),
                            ],
                          ),
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
    );
  }
}

class _ProjectImageSlider extends StatefulWidget {
  final List<String> imagePaths;

  const _ProjectImageSlider({required this.imagePaths});

  @override
  State<_ProjectImageSlider> createState() => _ProjectImageSliderState();
}

class _ProjectImageSliderState extends State<_ProjectImageSlider> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant _ProjectImageSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePaths.length != widget.imagePaths.length) {
      _restartAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imagePaths.length <= 1) return;

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % widget.imagePaths.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoPlay() {
    _currentPage = 0;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const _ProjectImage(path: '');
    }

    if (widget.imagePaths.length == 1) {
      return _ProjectImage(path: widget.imagePaths.first);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imagePaths.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return _ProjectImage(path: widget.imagePaths[index]);
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imagePaths.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProjectImage extends StatelessWidget {
  final String path;

  const _ProjectImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (path.isEmpty) {
      return Container(
        color: colors.border.withValues(alpha: 0.4),
        child: Icon(Icons.image_outlined, size: 40, color: colors.textSecondary),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      cacheWidth: (MediaQuery.devicePixelRatioOf(context) * 480).round(),
      errorBuilder: (context, error, stack) => Container(
        color: colors.border.withValues(alpha: 0.4),
        child: Icon(Icons.image_outlined, size: 40, color: colors.textSecondary),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
