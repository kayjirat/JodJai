import 'package:flutter/material.dart';
import 'package:frontend/services/stripe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({Key? key}) : super(key: key);

  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  late SharedPreferences prefs;
  late String _token = '';
  late StripeService stripeService;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }

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

        StripeService stripeService = StripeService();
        await stripeService.stripePaymentCheckout(
          items,
          99,
          context,
          true,
          onSuccess: () {
            print("SUCCESS");
            Navigator.pushReplacementNamed(context, '/profile');//, arguments: widget.onSuccessCallback);
          },
          onCancel: () {
            print("Cancel");
            Navigator.pushReplacementNamed(context, '/cancel');
          },
          onError: (e) {
            print("Error: " + e.toString());
            Navigator.pushReplacementNamed(context, '/error');
          },
         token: _token,
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
