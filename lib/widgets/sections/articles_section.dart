import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../theme/app_theme.dart';
import '../common/section_container.dart';

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({super.key, required this.articles});
  final List<Article> articles;
  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    return SectionContainer(
        child: Column(
      key: const ValueKey('articles-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Articles',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: colors.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('Thoughts, tutorials and lessons from my work.',
            style: TextStyle(color: colors.textSecondary)),
        const SizedBox(height: 28),
        _ArticleGrid(articles: newestArticles(articles).take(3).toList()),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          key: const ValueKey('see-more-articles'),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => AllArticlesPage(articles: articles))),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('See more'),
        ),
      ],
    ));
  }
}

class AllArticlesPage extends StatelessWidget {
  const AllArticlesPage({super.key, required this.articles});
  final List<Article> articles;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('All articles')),
        body: SingleChildScrollView(
          key: const ValueKey('all-articles-page'),
          child: SectionContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All articles',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 12),
              const Text('Latest articles first.'),
              const SizedBox(height: 28),
              if (articles.isEmpty)
                const Text('No articles yet.')
              else
                _ArticleGrid(articles: newestArticles(articles)),
            ],
          )),
        ),
      );
}

class _ArticleGrid extends StatelessWidget {
  const _ArticleGrid({required this.articles});
  final List<Article> articles;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth >= 960
          ? 3
          : constraints.maxWidth >= 620
              ? 2
              : 1;
      final width = (constraints.maxWidth - (columns - 1) * 20) / columns;
      return Wrap(spacing: 20, runSpacing: 20, children: [
        for (final article in articles)
          SizedBox(
              width: width,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colors.border)),
                child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.article_outlined, color: colors.accent),
                          const SizedBox(height: 16),
                          Text(article.publishedOn,
                              style: TextStyle(color: colors.textSecondary)),
                          const SizedBox(height: 12),
                          Text(article.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: colors.textPrimary)),
                          const SizedBox(height: 12),
                          Text(article.summary,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: colors.textSecondary, height: 1.6)),
                          const SizedBox(height: 20),
                          TextButton.icon(
                              key: ValueKey('read-article-${article.id}'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (_) =>
                                          ArticlePage(article: article))),
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Read article')),
                        ])),
              )),
      ]);
    });
  }
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.article});
  final Article article;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Article')),
        body: SingleChildScrollView(
            child: SectionContainer(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: SelectionArea(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(article.publishedOn,
                                style: TextStyle(
                                    color: context.colors.textSecondary)),
                            const SizedBox(height: 16),
                            Text(article.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Text(article.summary,
                                style: Theme.of(context).textTheme.titleMedium),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider()),
                            Text(article.body,
                                style:
                                    const TextStyle(fontSize: 17, height: 1.8)),
                          ])),
                    )))),
      );
}
