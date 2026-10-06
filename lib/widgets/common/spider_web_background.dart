import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_app/theme/app_theme.dart';

class SpiderWebBackground extends StatefulWidget {
  const SpiderWebBackground({super.key});

  @override
  State<SpiderWebBackground> createState() => _SpiderWebBackgroundState();
}

class _SpiderWebBackgroundState extends State<SpiderWebBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Size _size = Size.zero;
  List<_WebNode> _nodes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ensureNodes(Size size, bool isMobile) {
    if (_size == size && _nodes.isNotEmpty) return;
    _size = size;
    final random = math.Random(7);
    final count = isMobile ? 28 : 48;
    _nodes = List.generate(count, (_) {
      return _WebNode(
        position: Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 28,
          (random.nextDouble() - 0.5) * 28,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppBreakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final glow = isDark
        ? const Color(0xFF7CFFB2)
        : const Color(0xFF12C48B);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _ensureNodes(size, isMobile);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            _step(size);
            return CustomPaint(
              size: size,
              painter: _SpiderWebPainter(
                nodes: _nodes,
                glow: glow,
                maxDistance: isMobile ? 110 : 150,
              ),
            );
          },
        );
      },
    );
  }

  void _step(Size size) {
    const dt = 1 / 60;
    for (final node in _nodes) {
      var next = node.position + node.velocity * dt;
      if (next.dx <= 0 || next.dx >= size.width) {
        node.velocity = Offset(-node.velocity.dx, node.velocity.dy);
        next = Offset(next.dx.clamp(0, size.width), next.dy);
      }
      if (next.dy <= 0 || next.dy >= size.height) {
        node.velocity = Offset(node.velocity.dx, -node.velocity.dy);
        next = Offset(next.dx, next.dy.clamp(0, size.height));
      }
      node.position = next;
    }
  }
}

class _WebNode {
  Offset position;
  Offset velocity;

  _WebNode({required this.position, required this.velocity});
}

class _SpiderWebPainter extends CustomPainter {
  final List<_WebNode> nodes;
  final Color glow;
  final double maxDistance;

  const _SpiderWebPainter({
    required this.nodes,
    required this.glow,
    required this.maxDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxDistanceSquared = maxDistance * maxDistance;

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final a = nodes[i].position;
        final b = nodes[j].position;
        final dx = a.dx - b.dx;
        final dy = a.dy - b.dy;
        final distSquared = dx * dx + dy * dy;
        if (distSquared > maxDistanceSquared) continue;

        final t = 1 - (math.sqrt(distSquared) / maxDistance);
        final linePaint = Paint()
          ..color = glow.withValues(alpha: 0.08 + t * 0.42)
          ..strokeWidth = 1.1 + t * 0.9
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6);

        canvas.drawLine(a, b, linePaint);

        final corePaint = Paint()
          ..color = glow.withValues(alpha: 0.18 + t * 0.55)
          ..strokeWidth = 0.6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(a, b, corePaint);
      }
    }

    for (final node in nodes) {
      final halo = Paint()
        ..color = glow.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(node.position, 5.5, halo);

      final dot = Paint()..color = glow.withValues(alpha: 0.9);
      canvas.drawCircle(node.position, 1.8, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _SpiderWebPainter oldDelegate) => true;
}
