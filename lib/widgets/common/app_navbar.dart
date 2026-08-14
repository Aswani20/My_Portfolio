import 'package:flutter/material.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';
import 'package:portfolio_app/utils/services/file_download.dart';
import 'section_container.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogoTap;
  final void Function(String sectionId) onNavItemTap;

  const AppNavBar({
    super.key,
    required this.isDarkMode,
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
    final isDesktop = AppBreakpoints.isDesktop(width);
    final colors = context.colors;

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
            _LogoButton(onTap: onLogoTap),
            const Spacer(),

            if (isDesktop)
              Row(
                children: navItems.entries
                    .map((e) => _NavLinkButton(
                          label: e.value,
                          onTap: () => onNavItemTap(e.key),
                        ))
                    .toList(),
              ),
            const Spacer(),

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
              _MobileNavMenu(onNavItemTap: onNavItemTap),
            ],
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
            Icon(Icons.arrow_upward_rounded, size: 20, color: colors.accent),
            const SizedBox(width: 8),
            Text(
              AppStrings.portfolio,
              style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.textPrimary),
            ),
            Text(
              AppStrings.dev,
              style: AppTextStyles.h3.copyWith(fontSize: 18, color: colors.accent),
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
      child: Text(label, style: AppTextStyles.navLink.copyWith(color: colors.textPrimary)),
    );
  }
}

class _MobileNavMenu extends StatelessWidget {
  final void Function(String sectionId) onNavItemTap;
  const _MobileNavMenu({required this.onNavItemTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, color: colors.textPrimary),
      onSelected: onNavItemTap,
      itemBuilder: (context) => AppNavBar.navItems.entries
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
      label: const Text(AppStrings.downloadCv, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
