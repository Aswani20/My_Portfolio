class Education {
  final String degree;
  final String institution;
  final String duration;
  final String location;
  final bool isCurrent;
  final String? certificateUrl;

  const Education({
    required this.degree,
    required this.institution,
    required this.duration,
    required this.location,
    this.isCurrent = false,
    this.certificateUrl,
  });
}