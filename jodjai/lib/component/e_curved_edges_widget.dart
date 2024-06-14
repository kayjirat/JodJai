import 'package:flutter/material.dart';
import 'package:jodjai/component/e_curved_edges.dart';

class ECurvedEdgeWidget extends StatelessWidget {
  const ECurvedEdgeWidget({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ECurvedEdges(),
      child: child,
    );
  }
}
