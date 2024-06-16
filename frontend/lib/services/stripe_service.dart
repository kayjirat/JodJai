// import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class StripeService {
//   static const String apiBase = 'http://localhost:2992'; // Your backend URL
//   static const String paymentApiUrl = '$apiBase/create-payment-intent';
//   static const String publishableKey = 'pk_test_51PQlLg07vrIHRSHHKNmvB8MnNd6EpmIsySmQZI1fSpFPQ6LTmhsmBbInlXD2r80VUOUho0ex7xbcc3uNG1baPalh00atfUQZxr';

//   static void init() {
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey: publishableKey,
//         androidPayMode: 'test',
//         merchantId: 'test',
//       ),
//     );
//   }

//   static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
//   try {
//     final response = await http.post(
//       Uri.parse(paymentApiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'amount': amount,
//         'currency': currency,
//       }),
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load payment intent');
//     }
//   } catch (err) {
//     print('Error occurred while creating payment intent: ${err.toString()}');
//     throw err;
//   }
// }


//   static Future<void> makePayment({required String amount, required String currency}) async {
//     final paymentIntent = await createPaymentIntent(amount, currency);

//     final PaymentMethod paymentMethod = await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     );

//     final PaymentIntentResult paymentIntentResult = await StripePayment.confirmPaymentIntent(
//       PaymentIntent(
//         clientSecret: paymentIntent['clientSecret'],
//         paymentMethodId: paymentMethod.id,
//       ),
//     );

//     if (paymentIntentResult.status == 'succeeded') {
//       print('Payment successful');
//     } else {
//       print('Payment failed');
//     }
//   }
// }
