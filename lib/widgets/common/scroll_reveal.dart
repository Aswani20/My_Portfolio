import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Provides [scrollController] to [ScrollReveal] widgets below a scroll view.
class ScrollRevealScope extends InheritedWidget {
  final ScrollController scrollController;

  const ScrollRevealScope({
    super.key,
    required this.scrollController,
    required super.child,
  });

  static ScrollController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScrollRevealScope>()?.scrollController;
  }

  @override
  bool updateShouldNotify(ScrollRevealScope oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}

/// Fades, slides, and optionally scales a child in when it enters the viewport.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideFrom;
  final double scaleFrom;
  final bool animateOnMount;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 620),
    this.delay = Duration.zero,
    this.slideFrom = const Offset(0, 28),
    this.scaleFrom = 1,
    this.animateOnMount = false,
  });

  static Duration stagger(int index, {int stepMs = 80, int maxMs = 480}) {
    return Duration(milliseconds: (index * stepMs).clamp(0, maxMs));
  }

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  late final Animation<double> _scale;
  bool _hasAnimated = false;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _offset = Tween<Offset>(begin: widget.slideFrom, end: Offset.zero).animate(curve);
    _scale = Tween<double>(begin: widget.scaleFrom, end: 1).animate(curve);

    SchedulerBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = ScrollRevealScope.maybeOf(context);
    if (_scrollController != controller) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller;
      _scrollController?.addListener(_checkVisibility);
    }

    if (widget.animateOnMount && !_hasAnimated) {
      _triggerAnimation();
    }
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final position = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final triggerLine = screenHeight * 0.9;
    final visible = position.dy < triggerLine && position.dy + size.height > 0;

    if (visible) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() {
    if (_hasAnimated || !mounted) return;
    _hasAnimated = true;

    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }

    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _offset.value,
            child: Transform.scale(
              scale: _scale.value,
              alignment: Alignment.center,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
