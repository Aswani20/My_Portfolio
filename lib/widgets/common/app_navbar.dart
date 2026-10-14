import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';
import 'package:portfolio_app/utils/services/file_download.dart';
import 'section_container.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final bool hasArticles;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogoTap;
  final void Function(String sectionId) onNavItemTap;

  const AppNavBar({
    super.key,
    required this.isDarkMode,
    this.hasArticles = false,
    required this.onToggleTheme,
    required this.onLogoTap,
    required this.onNavItemTap,
  });

  static const Map<String, String> navItems = {
    AppStrings.hero: AppStrings.home,
    AppStrings.about: AppStrings.aboutUpper,
    AppStrings.skills: AppStrings.skillsUpper,
    AppStrings.projects: AppStrings.projectsUpper,
    AppStrings.education: AppStrings.educationUpper,
    AppStrings.experience: AppStrings.experienceUpper,
    AppStrings.contact: AppStrings.contactUpper
  };
  static const String cvUrl = AppStrings.cv;
  static const String cvDownloadFilename = '${AppStrings.name}_CV.pdf';

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.navBarHeight);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final visibleItems = <String, String>{
      for (final entry in navItems.entries) ...{
        entry.key: entry.value,
        if (entry.key == AppStrings.projects && hasArticles)
          'articles': 'Articles'
      }
    };
    double textWidth(String text, TextStyle style) {
      final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context))
        ..layout();
      return painter.width;
    }

    final available = (width - 2 * AppSpacing.horizontalPaddingDesktop)
        .clamp(0, AppSpacing.maxContentWidth);
    final linksWidth = visibleItems.values.fold<double>(
        0, (sum, label) => sum + textWidth(label, AppTextStyles.navLink) + 28);
    final logoWidth = textWidth('${AppStrings.portfolio}${AppStrings.dev}',
            AppTextStyles.h3.copyWith(fontSize: 18)) +
        40;
    final actionsWidth =
        textWidth(AppStrings.downloadCv, const TextStyle(fontSize: 14)) + 140;
    final sideWidth = logoWidth > actionsWidth ? logoWidth : actionsWidth;
    final isDesktop = AppBreakpoints.isDesktop(width) &&
        available >= linksWidth + 2 * sideWidth + 32;
    final colors = context.colors;
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: isDarkMode ? AppStrings.lightMode : AppStrings.darkMode,
          onPressed: onToggleTheme,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          icon: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        _DownloadCvButton(isDesktop: isDesktop),
        if (!isDesktop) ...[
          const SizedBox(width: 4),
          _MobileNavMenu(onNavItemTap: onNavItemTap, items: visibleItems),
        ],
      ],
    );

    return Container(
      height: AppSpacing.navBarHeight,
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(bottom: BorderSide(color: colors.border, width: 1)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? AppSpacing.horizontalPaddingDesktop
            : AppSpacing.horizontalPaddingMobile,
      ),
      child: ContentWidth(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _LogoButton(onTap: onLogoTap),
                ),
              ),
            ),
            if (isDesktop) const SizedBox(width: 16),
            if (isDesktop)
              Row(
                children: visibleItems.entries
                    .map((e) => _NavLinkButton(
                          label: e.value,
                          onTap: () => onNavItemTap(e.key),
                        ))
                    .toList(),
              ),
            if (isDesktop) const SizedBox(width: 16),
            if (isDesktop)
              Expanded(
                  child:
                      Align(alignment: Alignment.centerRight, child: actions))
            else
              actions,
          ],
        ),
      ),
    );
  }
}

class _LogoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/branding/website_logo.svg',
                width: 20, height: 20, semanticsLabel: 'Website logo'),
            const SizedBox(width: 8),
            Text(
              AppStrings.portfolio,
              style: AppTextStyles.h3
                  .copyWith(fontSize: 18, color: colors.textPrimary),
            ),
            Text(
              AppStrings.dev,
              style:
                  AppTextStyles.h3.copyWith(fontSize: 18, color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLinkButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: colors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label,
          style: AppTextStyles.navLink.copyWith(color: colors.textPrimary)),
    );
  }
}

class _MobileNavMenu extends StatelessWidget {
  final void Function(String sectionId) onNavItemTap;
  final Map<String, String> items;
  const _MobileNavMenu({required this.onNavItemTap, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, color: colors.textPrimary),
      onSelected: onNavItemTap,
      itemBuilder: (context) => items.entries
          .map((e) => PopupMenuItem<String>(
                value: e.key,
                child: Text(e.value),
              ))
          .toList(),
    );
  }
}

class _DownloadCvButton extends StatelessWidget {
  final bool isDesktop;
  const _DownloadCvButton({required this.isDesktop});

  void _handleDownload() {
    downloadFile(AppNavBar.cvUrl, AppNavBar.cvDownloadFilename);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (!isDesktop) {
      return IconButton(
        tooltip: AppStrings.downloadCv,
        onPressed: _handleDownload,
        icon: Icon(Icons.download_outlined, color: colors.accent),
      );
    }
    return ElevatedButton.icon(
      onPressed: _handleDownload,
      icon: const Icon(Icons.download_outlined, size: 18, color: Colors.white),
      label: const Text(AppStrings.downloadCv,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }
}
