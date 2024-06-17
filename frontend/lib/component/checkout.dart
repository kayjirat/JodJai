import 'package:flutter/material.dart';
import 'package:frontend/services/stripe_service.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var items = [
          {
            "productPrice": 99,
            "productName": "Membership",
            "qty": 1,
          },
        ];
        await StripeService.stripePaymentCheckout(
          items,
          99,
          context,
          true,
          onSuccess: () {
            print("SUCCESS");
            Navigator.pushReplacementNamed(context, '/success');
          },
          onCancel: () {
            print("Cancel");
            Navigator.pushReplacementNamed(context, '/cancel');
          },
          onError: (e) {
            print("Error: " + e.toString());
            Navigator.pushReplacementNamed(context, '/error');
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF666159),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Upgrade to Premium',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
