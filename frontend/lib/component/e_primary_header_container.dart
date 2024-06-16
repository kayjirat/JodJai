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
        height: 150,
        child: Container(
          color: Color(0xFFB1EACD),
          padding: EdgeInsets.only(bottom: 0),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -120,
                child: ECircularContainer(
                  width: 283,
                  height: 283,
                ),
              ),
              Positioned(
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