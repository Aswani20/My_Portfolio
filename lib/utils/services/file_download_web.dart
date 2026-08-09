import 'dart:html' as html;
import 'package:portfolio_app/utils/core/app_strings.dart';

void downloadFile(String url, String filename) {
  final resolvedUrl = Uri.base.resolve(url).toString();
  final anchor = html.AnchorElement(href: resolvedUrl)
    ..setAttribute(AppStrings.download, filename)
    ..style.display = AppStrings.none;
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
