import 'package:flutter/material.dart';
import 'package:portfolio_app/utils/core/app_strings.dart';
import 'theme/app_theme.dart';
import 'widgets/common/app_navbar.dart';
import 'widgets/common/scroll_reveal.dart';
import 'widgets/sections/hero_section.dart';
import 'widgets/sections/about_section.dart';
import 'widgets/sections/skills_section.dart';
import 'widgets/sections/projects_section.dart';
import 'widgets/sections/education_section.dart';
import 'widgets/sections/experience_section.dart';
import 'widgets/sections/contact_section.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.myPortfolio,
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: _themeMode,
      home: PortfolioHomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const PortfolioHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    AppStrings.hero: GlobalKey(),
    AppStrings.about: GlobalKey(),
    AppStrings.skills: GlobalKey(),
    AppStrings.projects: GlobalKey(),
    AppStrings.education: GlobalKey(),
    AppStrings.experience: GlobalKey(),
    AppStrings.contact: GlobalKey(),
  };

  void _scrollToSection(String id) {
    final ctx = _sectionKeys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppNavBar(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        onLogoTap: _scrollToTop,
        onNavItemTap: _scrollToSection,
      ),
      body: ScrollRevealScope(
        scrollController: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ScrollReveal(
                animateOnMount: true,
                child: KeyedSubtree(
                  key: _sectionKeys[AppStrings.hero],
                  child: HeroSection(onScrollToSection: _scrollToSection),
                ),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.about], child: const AboutSection()),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.skills], child: const SkillsSection()),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.projects], child: const ProjectsSection()),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.education], child: const EducationSection()),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.experience], child: const ExperienceSection()),
              ),
              ScrollReveal(
                child: KeyedSubtree(key: _sectionKeys[AppStrings.contact], child: const ContactSection()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
