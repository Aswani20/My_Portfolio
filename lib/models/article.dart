import 'dart:convert';

/// Public static content only; no Dashboard connection or local file paths.
class Article {
  const Article(
      {required this.id,
      required this.title,
      required this.summary,
      required this.body,
      required this.publishedOn});
  final String id, title, summary, body, publishedOn;
}

List<Article> parseArticles(String source) {
  final document = jsonDecode(source);
  if (document is! Map<String, dynamic> ||
      document['schemaVersion'] != 1 ||
      document['articles'] is! List) {
    throw const FormatException('Expected static articles schema 1.');
  }
  final ids = <String>{};
  final articles = <Article>[];
  for (final item in document['articles'] as List) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException('Invalid article.');
    }
    String field(String name) {
      final value = item[name];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Article $name is required.');
      }
      return value;
    }

    final id = field('id');
    if (!ids.add(id)) throw FormatException('Duplicate article: $id');
    final date = field('publishedOn');
    final parsed = DateTime.tryParse(date);
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
        parsed == null ||
        parsed.toIso8601String().substring(0, 10) != date) {
      throw FormatException('Invalid article date: $date');
    }
    articles.add(Article(
        id: id,
        title: field('title'),
        summary: field('summary'),
        body: field('body'),
        publishedOn: date));
  }
  return List.unmodifiable(articles);
}

/// Newest publication date first; equal dates retain the static export order.
List<Article> newestArticles(List<Article> articles) {
  final indexed = articles.indexed.toList();
  indexed.sort((a, b) {
    final date = b.$2.publishedOn.compareTo(a.$2.publishedOn);
    return date != 0 ? date : a.$1.compareTo(b.$1);
  });
  return indexed.map((entry) => entry.$2).toList(growable: false);
}
