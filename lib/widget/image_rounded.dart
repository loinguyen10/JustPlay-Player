import 'package:flutter/material.dart';

class ImageRounded extends StatelessWidget {
  const ImageRounded(
    this.imageUrl, {
    super.key,
    required this.isHttpHeader,
    this.size = 48,
    this.fit = BoxFit.cover,
    this.borderColor,
    this.borderWidth,
  });

  final String imageUrl;
  final bool isHttpHeader;
  final double size;
  final BoxFit fit;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(size + 16))),
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(size),
          child: isHttpHeader ? Image.network(imageUrl, fit: fit) : Image.asset(imageUrl, fit: fit),
        ),
      ),
    );
  }
}
