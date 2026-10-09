import 'package:flutter/material.dart';
import 'package:portfolio_app/models/project.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/utils/core/app_assets.dart';
import 'package:portfolio_app/widgets/common/project_card.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';


class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const String heading = 'Projects';
  static const String subtitle = "A few things I've built recently.";

  // ---- Placeholder content — swap these for your real projects ----
  static const List<Project> projects = [
    Project(
        title: 'BA_FindWay',
        description:
        "Offline Egyptian movie, TV series and theater guessing game for Android and iOS. "
            "The desktop Python app remains separate; this is a native Flutter reimplementation with a shared Dart game engine and responsive touch interface.",
        imagePaths: [
          AppAssets.findway1,
          AppAssets.findway2,
          AppAssets.findway3,
          AppAssets.findway4,
          AppAssets.findway5,
          AppAssets.findway6,
          AppAssets.findway7,
          AppAssets.findway8,
          AppAssets.findway9,
          AppAssets.findway10,
          AppAssets.findway11,
          AppAssets.findway12,
        ],
        techStack: ['Unity', 'C#', 'Windows App', 'Game Development', 'VISTA'],
    ),
    Project(
      title: 'Aflam Night',
      description:
      "Offline Egyptian movie, TV series and theater guessing game for Android and iOS. "
          "The desktop Python app remains separate; this is a native Flutter reimplementation with a shared Dart game engine and responsive touch interface.",
      imagePaths: [
        AppAssets.aflamNight1,
        AppAssets.aflamNight2,
        AppAssets.aflamNight3,
      ],
      techStack: ['Flutter', 'Dart', 'Mobile Development', 'Cross Platform'],
      githubUrl: 'https://github.com/Aswani20/aflam_night_mobile',
      liveUrl: 'https://github.com/Aswani20/aflam_night_mobile/releases/tag/v1.0.0'
    ),
    Project(
      title: 'Flowery Driver App',
      description:
          'A modern Flutter Flowery application built with Clean Architecture. '
          'The app allows driver to browse orders, add pick it up from store, and manage deliver it to user.',
      imagePaths: [
        AppAssets.flowerDriver,
      ],
      techStack: ['Flutter', 'Dart', 'Firebase', 'API', 'Mobile Development', 'Cross Platform'],
      githubUrl: 'https://github.com/Aswani20/flowery-driver',
    ),
    Project(
      title: 'Flower App',
      description:
          'A modern Flutter e-commerce application built with Clean Architecture. '
          'The app allows users to browse products, add them to cart, and manage orders efficiently.',
      imagePaths: [
        AppAssets.flowerApp,
      ],
      techStack: ['Flutter', 'Dart', 'Firebase', 'API', 'Mobile Development', 'Cross Platform'],
      githubUrl: 'https://github.com/Aswani20/flower_app',
    ),
    Project(
      title: 'Todo App',
      description:
          'A simple and efficient Todo app to help users organize their tasks. '
          'he app features task creation, editing, and deletion, with options to mark tasks as complete.',
      imagePaths: [
        AppAssets.todoApp,
      ],
      techStack: ['Flutter', 'Dart', 'Firebase', 'Mobile Development', 'Cross Platform'],
      githubUrl: 'https://github.com/Aswani20/todo_application',
    ),
    Project(
      title: 'Happy Paws',
      description: 'Pet platform with all supplies and services that any pet owner will need ',
      imagePaths: [
        AppAssets.happyPaw,
      ],
      techStack: ['Angular', 'Typescript', 'PrimeNG', 'PWA', 'Web Development'],
      liveUrl: 'https://karim-mamdouh.github.io/Happy-Paws/home',
      githubUrl: 'https://github.com/karim-mamdouh/Happy-Paws',
    ),
    Project(
      title: 'Yummy🍽Taste',
      description: 'Recipes web application where you can view and save your favourite recipes',
      imagePaths: [
        AppAssets.yummyTest,
      ],
      techStack: ['Angular', 'Typescript', 'PrimeNG', 'PWA', 'Web Development'],
      liveUrl: 'https://karim-mamdouh.github.io/Yummy-Taste-Angular/',
      githubUrl: 'https://github.com/karim-mamdouh/Yummy-Taste-Angular',
    ),
    Project(
      title: 'Memory Game',
      description: "It's a flip cards game",
      imagePaths: [
        AppAssets.memoryGame,
      ],
      techStack: ['HTML5', 'CSS3', 'JavaScript', 'Web Development'],
      liveUrl: 'https://aswani20.github.io/Memory-Game/',
      githubUrl: 'https://github.com/Aswani20/Memory-Game',
    ),
  ];
  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = AppBreakpoints.isMobile(width);
    final colors = context.colors;

    return SectionContainer(
      sectionKey: const ValueKey('projects'),
      compact: true,
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
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              const spacing = 24.0;
              final columns = maxWidth >= 1100
                  ? 3
                  : maxWidth >= 680
                      ? 2
                      : 1;
              final cardWidth =
                  (maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < projects.length; i++)
                    ScrollReveal(

                      delay: ScrollReveal.stagger(i, stepMs: 90),
                      scaleFrom: 0.96,
                      slideFrom: const Offset(0, 32),
                      child: ProjectCard(
                        project: projects[i],
                        width: cardWidth,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
