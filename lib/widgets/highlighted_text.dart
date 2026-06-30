import 'package:flutter/material.dart';

/// Renders [text] with every case-insensitive occurrence of [query] highlighted.
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final theme = Theme.of(context);
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final matchStyle = highlightStyle ??
        baseStyle.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
          backgroundColor:
              theme.colorScheme.primary.withValues(alpha: 0.18),
        );

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: baseStyle));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmedQuery.length),
          style: matchStyle,
        ),
      );
      start = index + trimmedQuery.length;
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
