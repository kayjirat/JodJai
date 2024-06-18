// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  late final String baseUrl;
  final String burl;
  StripeService() : burl = dotenv.env['BASE_URL'] ?? '' {
    baseUrl = '$burl/user';
  }

  static String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  static String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  static Future<String?> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;

    for (var val in productItems) {
      var productPrice = (val["productPrice"] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems +=
          "&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=THB";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    }

    try {
      final response = await http.post(
        url,
        body:
            'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody["id"];
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    mounted, {
    required String token,
    onSuccess,
    onCancel,
    onError,
    String successUrl = "https://localhost:8080/#/profile",
    String cancelUrl = "https://localhost:8080/#/cancel",
  }) async {
    final String? sessionId = await createCheckoutSession(
      productItems,
      subTotal,
    );

    if (sessionId == null) {
      print('Failed to create Stripe checkout session');
      if (onError != null) {
        onError('Failed to create Stripe checkout session');
      }
      return;
    }

    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/cancel",
    );

    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfully',
        success: () async {
            print('Payment Successful');
          await createMembership(token, sessionId);
            if (onSuccess != null) {
              await onSuccess();
            }
          },
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }

  Future<void> createMembership(String token, String stripePaymentId) async {
    print(baseUrl);
    final response = await http.post(
      Uri.parse('$baseUrl/membership'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'stripe_payment_id': stripePaymentId,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create membership');
    } else {
      print('Membership created');
    }
  }
}