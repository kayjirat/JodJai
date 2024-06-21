import 'package:flutter/material.dart';
import 'package:frontend/component/e_circular_container.dart';
import 'package:frontend/component/e_curved_edges_widget.dart';

class EPrimaryHeaderContainer extends StatelessWidget {
  const EPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ECurvedEdgeWidget(
      child: SizedBox(
        width: double
            .infinity, // Set the width to span the entire width of the page
        height: 160,
        child: Container(
          color: const Color(0xFFB1EACD),
          padding: const EdgeInsets.only(bottom: 0),
          child: Stack(
            children: [
              const Positioned(
                top: -50,
                right: -120,
                child: ECircularContainer(
                  width: 283,
                  height: 283,
                ),
              ),
              const Positioned(
                top: 100,
                right: 80,
                child: ECircularContainer(
                  width: 129,
                  height: 129,
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
