class Experience {
  final String role;
  final String company;
  final String duration;
  final String location;
  final List<String> highlights;
  final bool isCurrent;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.highlights,
    this.isCurrent = false,
  });
}