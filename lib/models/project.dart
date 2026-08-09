class Project {
  final String title;
  final String description;
  final List<String> imagePaths;
  final List<String> techStack;
  final String? liveUrl;
  final String? githubUrl;

  const Project({
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.techStack,
    this.liveUrl,
    this.githubUrl,
  });
}
