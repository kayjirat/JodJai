import 'package:flutter/material.dart';
import 'package:jodjai/component/stripe_service.dart';

void main(){
  runApp(const MaterialApp(
    home: CheckoutPage()
  ));
}

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
              },
              onCancel: () {
                print("Cancel");
              },
              onError: (e) {
                print("Error: " + e.toString());
              },
            );
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1)),
              )),
          child: const Text("Checkout"),
        ),
      ),
    );
  }
}
