import 'package:flutter/material.dart';

class AnimatedPercentageBar extends StatefulWidget {
  final double percentage;
  final Color color;
  final double minWidth; // Minimum width for 0% values

  const AnimatedPercentageBar({
    super.key,
    required this.percentage,
    required this.color,
    this.minWidth = 0.001, // Default minimal width (0.1%)
  });

  @override
  State<AnimatedPercentageBar> createState() => _AnimatedPercentageBarState();
}

class _AnimatedPercentageBarState extends State<AnimatedPercentageBar> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get _effectivePercentage => 
      widget.percentage <= 0 ? widget.minWidth : widget.percentage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _initializeAnimation();
    _controller.forward();
  }

  void _initializeAnimation() {
    _animation = Tween<double>(
      begin: 0,
      end: _effectivePercentage,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );
  }

  @override
  void didUpdateWidget(AnimatedPercentageBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage || 
        oldWidget.minWidth != widget.minWidth) {
      _controller.reset();
      _initializeAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}