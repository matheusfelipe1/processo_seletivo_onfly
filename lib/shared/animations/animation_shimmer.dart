import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimationShimmer extends StatefulWidget {
  final Widget child;
  bool isAnimating;
  AnimationShimmer({super.key, required this.child, required this.isAnimating});

  @override
  State<AnimationShimmer> createState() => _AnimationShimmerState();
}

class _AnimationShimmerState extends State<AnimationShimmer> {
  @override
  Widget build(BuildContext context) {
    return !widget.isAnimating ? widget.child : Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 77, 77, 77),
      highlightColor: Colors.white,
      child: widget.child,
    );
  }
}