import 'package:flutter/material.dart';
import 'package:portfolio_app/models/project.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/widgets/common/project_card.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';


class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static const String heading = 'Projects';
  static const String subtitle = "A few things I've built recently.";

  // ---- Placeholder content — swap these for your real projects ----
  static const List<Project> projects = [
    Project(
      title: 'Flowery Driver App',
      description:
          'A modern Flutter Flowery application built with Clean Architecture. '
          'The app allows driver to browse orders, add pick it up from store, and manage deliver it to user.',
      imagePaths: [
        'assets/images/flower_driver.png',
      ],
      techStack: ['Flutter', 'Dart', 'Firebase', 'API'],
      githubUrl: 'https://github.com/Aswani20/flowery-driver',
    ),
    Project(
      title: 'Flower App',
      description:
          'A modern Flutter e-commerce application built with Clean Architecture. '
          'The app allows users to browse products, add them to cart, and manage orders efficiently.',
      imagePaths: [
        'assets/images/flower_app.png',
      ],
      techStack: ['Flutter', 'Dart', 'Firebase', 'API'],
      githubUrl: 'https://github.com/Aswani20/flower_app',
    ),
    Project(
      title: 'Todo App',
      description:
          'A simple and efficient Todo app to help users organize their tasks. '
          'he app features task creation, editing, and deletion, with options to mark tasks as complete.',
      imagePaths: [
        'assets/images/todo_app.png',
      ],
      techStack: ['Flutter', 'Dart', 'Firebase'],
      githubUrl: 'https://github.com/Aswani20/todo_application',
    ),
    Project(
      title: 'Happy Paws',
      description: 'Pet platform with all supplies and services that any pet owner will need ',
      imagePaths: [
        'assets/images/happy_paw.png',
      ],
      techStack: ['Angular', 'Typescript', 'PrimeNG', 'PWA'],
      liveUrl: 'https://karim-mamdouh.github.io/Happy-Paws/home',
      githubUrl: 'https://github.com/karim-mamdouh/Happy-Paws',
    ),
    Project(
      title: 'Yummy🍽Taste',
      description: 'Recipes web application where you can view and save your favourite recipes',
      imagePaths: [
        'assets/images/yummy_test.png',
      ],
      techStack: ['Angular', 'Typescript', 'PrimeNG', 'PWA'],
      liveUrl: 'https://karim-mamdouh.github.io/Yummy-Taste-Angular/',
      githubUrl: 'https://github.com/karim-mamdouh/Yummy-Taste-Angular',
    ),
    Project(
      title: 'Memory Game',
      description: "It's a flip cards game",
      imagePaths: [
        'assets/images/memory_game.png',
      ],
      techStack: ['HTML5', 'CSS3', 'JavaScript'],
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
          Text(
            heading,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.body.copyWith(color: colors.textSecondary),
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
                children: projects
                    .map(
                      (p) => ProjectCard(
                        project: p,
                        width: cardWidth,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
