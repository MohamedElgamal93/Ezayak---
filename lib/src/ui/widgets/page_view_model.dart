import 'package:flutter/material.dart';

class PageViewModel {
  /// Title of page
  final String title;

  /// Title of page
  final Widget titleWidget;

  /// Text of page (description)
  final Widget bg;

  /// Widget content of page (description)
  final Widget bodyWidget;

  /// Image of page
  /// Tips: Wrap your image with an alignment widget like Align or Center
  final Widget image;

  /// Footer widget, you can add a button for example
  final Widget footer;

  /// Page decoration
  /// Contain all page customizations, like page color, text styles

  PageViewModel({
    this.title,
    this.titleWidget,
    this.bg,
    this.bodyWidget,
    this.image,
    this.footer,
  })  : assert(
        bg != null || bodyWidget != null,
        "You must provide either body (String) or bodyWidget (Widget).",
        );
}
