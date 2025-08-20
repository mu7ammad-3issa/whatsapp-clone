import 'package:flutter/material.dart';

class ChatHeroTransition extends StatefulWidget {
  final Widget child;
  final String heroTag;
  final VoidCallback? onTap;

  const ChatHeroTransition({
    super.key,
    required this.child,
    required this.heroTag,
    this.onTap,
  });

  @override
  State<ChatHeroTransition> createState() => _ChatHeroTransitionState();
}

class _ChatHeroTransitionState extends State<ChatHeroTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Hero(
                tag: widget.heroTag,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;

  SlideUpPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.fastOutSlowIn;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class ChatPageTransition extends PageRouteBuilder {
  final Widget child;
  final Offset beginOffset;

  ChatPageTransition({
    required this.child,
    this.beginOffset = const Offset(1.0, 0.0),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.fastOutSlowIn;
    const reverseCurve = Curves.easeInOut;

    // Slide animation
    var slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve,
    ));

    // Scale animation for the incoming page
    var scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: curve,
    ));

    // Fade animation
    var fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      ),
    );
  }
}

class FloatingActionButtonHero extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String heroTag;
  final Color backgroundColor;

  const FloatingActionButtonHero({
    super.key,
    required this.onPressed,
    required this.child,
    required this.heroTag,
    required this.backgroundColor,
  });

  @override
  State<FloatingActionButtonHero> createState() =>
      _FloatingActionButtonHeroState();
}

class _FloatingActionButtonHeroState extends State<FloatingActionButtonHero>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _scaleController.forward().then((_) {
                  _scaleController.reverse();
                });
                _rotationController.forward().then((_) {
                  _rotationController.reverse();
                });
                widget.onPressed();
              },
              heroTag: widget.heroTag,
              backgroundColor: widget.backgroundColor,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
