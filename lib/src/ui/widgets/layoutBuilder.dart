import 'package:flutter/widgets.dart';

class LayoutBuilderGenerator extends StatelessWidget {
  final Widget child;
  LayoutBuilderGenerator({@required this.child});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: constraints.copyWith(
              minHeight: constraints.maxHeight, maxHeight: double.infinity),
          child: IntrinsicHeight(
            child: child,
          ),
        ),
      );
    });
  }
}
