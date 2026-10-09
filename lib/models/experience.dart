class ExperienceMilestone {
  final String title;
  final String duration;
  final String type;
  final List<String> highlights;

  const ExperienceMilestone({
    required this.title,
    required this.duration,
    this.type = 'Promotion',
    this.highlights = const [],
  });
}

class Experience {
  final String role;
  final String company;
  final String duration;
  final String location;
  final List<String> highlights;
  final List<ExperienceMilestone> milestones;
  final bool isCurrent;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.highlights,
    this.milestones = const [],
    this.isCurrent = false,
  });
}
