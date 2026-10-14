import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/models/article.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/widgets/common/app_navbar.dart';
import 'package:portfolio_app/widgets/sections/articles_section.dart';

const article = Article(
    id: 'article-1',
    title: 'Building with Flutter',
    summary: 'Lessons from a project',
    body: 'First paragraph.\n\nSecond paragraph with <plain text>.',
    publishedOn: '2026-10-13');
Widget host(List<Article> articles) => MaterialApp(
    theme: buildLightTheme(),
    home: Scaffold(
      appBar: AppNavBar(
          isDarkMode: false,
          onToggleTheme: () {},
          onLogoTap: () {},
          onNavItemTap: (_) {},
          hasArticles: articles.isNotEmpty),
      body: SingleChildScrollView(child: ArticlesSection(articles: articles)),
    ));
void main() {
  test(
      'static format supports empty data and rejects invalid dates/duplicate IDs',
      () {
    expect(parseArticles('{"schemaVersion":1,"articles":[]}'), isEmpty);
    final data = {
      'schemaVersion': 1,
      'articles': [
        {
          'id': '1',
          'title': 'Title',
          'summary': 'Summary',
          'body': 'Text',
          'publishedOn': '2026-02-30'
        }
      ]
    };
    expect(() => parseArticles(jsonEncode(data)), throwsFormatException);
    final rows = data['articles'] as List<Map<String, String>>;
    rows.first['publishedOn'] = '2026-02-28';
    expect(parseArticles(jsonEncode(data)).single.title, 'Title');
    rows.add({...rows.first});
    expect(() => parseArticles(jsonEncode(data)), throwsFormatException);
  });
  test('latest sorting is stable and does not change exported order', () {
    final rows = [
      const Article(
          id: 'old',
          title: 'Old',
          summary: 'S',
          body: 'B',
          publishedOn: '2025-12-31'),
      article,
      const Article(
          id: 'tie',
          title: 'Tie',
          summary: 'S',
          body: 'B',
          publishedOn: '2026-10-13'),
    ];
    expect(newestArticles(rows).map((a) => a.id), ['article-1', 'tie', 'old']);
    expect(rows.first.id, 'old');
  });
  for (final width in [390.0, 1440.0]) {
    testWidgets('latest three, see more, reading and back navigation at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final rows = [
        for (final day in [1, 4, 2, 5, 3])
          Article(
              id: 'day-$day',
              title: 'Article $day',
              summary: 'Summary',
              body: 'Body $day',
              publishedOn: '2026-10-0$day')
      ];
      await tester.pumpWidget(host(rows));
      await tester.pumpAndSettle();
      final buttons = find.byWidgetPredicate((widget) =>
          widget.key is ValueKey<String> &&
          (widget.key as ValueKey<String>).value.startsWith('read-article-'));
      expect(buttons, findsNWidgets(3));
      expect(find.text('Article 1'), findsNothing);
      expect(find.text('Article 2'), findsNothing);
      expect(
          tester.getTopLeft(find.text('Article 5')).dy <=
              tester.getTopLeft(find.text('Article 4')).dy,
          isTrue);
      final more = find.byKey(const ValueKey('see-more-articles'));
      await tester.ensureVisible(more);
      await tester.pumpAndSettle();
      await tester.tap(more);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('all-articles-page')), findsOneWidget);
      expect(buttons, findsNWidgets(5));
      final oldest = find.byKey(const ValueKey('read-article-day-1'));
      await tester.ensureVisible(oldest);
      await tester.pumpAndSettle();
      await tester.tap(oldest);
      await tester.pumpAndSettle();
      expect(find.text('Body 1'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('all-articles-page')), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(buttons, findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }
  for (final width in [390.0, 1100.0, 1440.0]) {
    testWidgets('Articles hidden when empty, readable when present at $width',
        (tester) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(host([]));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('articles-section')), findsNothing);
      expect(find.byKey(const ValueKey('see-more-articles')), findsNothing);
      if (find.byIcon(Icons.menu).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        expect(find.text('Articles'), findsNothing);
        await tester.tapAt(const Offset(10, 500));
        await tester.pumpAndSettle();
      } else {
        expect(find.text('Articles'), findsNothing);
      }
      await tester.pumpWidget(host([article]));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('articles-section')), findsOneWidget);
      if (find.byIcon(Icons.menu).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        expect(find.text('Articles'), findsNWidgets(2));
        await tester.tap(find.text('Articles').last);
        await tester.pumpAndSettle();
      } else {
        expect(find.text('Articles'), findsNWidgets(2));
      }
      await tester.tap(find.byKey(const ValueKey('read-article-article-1')));
      await tester.pumpAndSettle();
      expect(find.text(article.body), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('articles-section')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
