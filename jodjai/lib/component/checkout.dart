import 'package:flutter/material.dart';
import 'package:jodjai/component/stripe_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stripe Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            var items = [
              {
                "productPrice": 99,
                "productName": "Membership",
                "qty": 1,
              },
            ];
            await StripeService.stripePaymentCheckout(
              items,
              500,
              context,
              mounted,
              onSuccess: () {
                print("SUCCESS");
                // Navigate to a success screen or update UI accordingly
                Navigator.pushReplacementNamed(context, '/success');
              },
              onCancel: () {
                print("Cancel");
                // Handle cancellation, e.g., navigate to a cancellation screen
                Navigator.pushReplacementNamed(context, '/cancel');
              },
              onError: (e) {
                print("Error: " + e.toString());
                // Handle error, display error message, etc.
                Navigator.pushReplacementNamed(context, '/error');
              },
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
          child: const Text("Checkout"),
        ),
      ),
    );
  }
}
