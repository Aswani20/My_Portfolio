import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_app/utils/core/app_assets.dart';

class ImagePrecache {
  ImagePrecache._();

  static bool _started = false;

  /// Decode raster images and SVGs into Flutter's in-memory caches
  /// so first paint of later sections does not wait on disk/network.
  static Future<void> warmUp(BuildContext context) async {
    if (_started) return;
    _started = true;

    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSize = 200;
    imageCache.maximumSizeBytes = 120 << 20; // 120 MB

    await Future.wait([
      ...AppAssets.rasterImages.map((path) => _precacheRaster(context, path)),
      ...AppAssets.svgIcons.map(_precacheSvg),
    ]);
  }

  static Future<void> _precacheRaster(BuildContext context, String path) async {
    try {
      await precacheImage(AssetImage(path), context);
    } catch (_) {
      // Missing assets should not block the rest of the cache.
    }
  }

  static Future<void> _precacheSvg(String path) async {
    try {
      final loader = SvgAssetLoader(path);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    } catch (_) {
      // Missing assets should not block the rest of the cache.
    }
  }
}
