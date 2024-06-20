// ignore_for_file: avoid_print, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_checkout/stripe_checkout.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class StripeService {
  late final String baseUrl;
  final String burl;
  StripeService() : burl = dotenv.env['BASE_URL'] ?? '' {
    baseUrl = '$burl/user';
  }

  static String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  static String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String webSuccessUrl = dotenv.env['WEB_SUCCESS_URL'] ?? '';
  static String webCancelUrl = dotenv.env['WEB_CANCEL_URL'] ?? '';
  static String iosSuccessUrl = dotenv.env['IOS_SUCCESS_URL'] ?? '';
  static String iosCancelUrl = dotenv.env['IOS_CANCEL_URL'] ?? '';

  static Future<String?> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
    String successUrl,
    String cancelUrl,
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
            'success_url=$successUrl&cancel_url=$cancelUrl&mode=payment$lineItems',
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
    String? successUrl,
    String? cancelUrl,
  }) async {
    final String defaultSuccessUrl;
    final String defaultCancelUrl;

    if (kIsWeb) {
      defaultSuccessUrl = webSuccessUrl;
      defaultCancelUrl = webCancelUrl;
    } else if (Platform.isIOS) {
      defaultSuccessUrl = iosSuccessUrl;
      defaultCancelUrl = iosCancelUrl;
    } else {
      defaultSuccessUrl = webSuccessUrl;
      defaultCancelUrl = webCancelUrl;
    }

    final String? sessionId = await createCheckoutSession(
      productItems,
      subTotal,
      successUrl ?? defaultSuccessUrl,
      cancelUrl ?? defaultCancelUrl,
    );

    if (sessionId == null) {
      print('Failed to create Stripe checkout session');
      if (onError != null) {
        onError('Failed to create Stripe checkout session');
      }
      return;
    }
    print('Stripe checkout session created: $sessionId');
    print('Redirecting to checkout...');
    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: successUrl ?? defaultSuccessUrl,
      canceledUrl: cancelUrl ?? defaultCancelUrl,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionId', sessionId);

    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfully',
        success: () async {
          print('Payment Successful');
          try {
            if (onSuccess != null) {
              await onSuccess();
            }
          } catch (e) {
            print('Failed to create membership: $e');
            if (onError != null) {
              onError('Failed to create membership');
            }
          }
        },
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }

  Future<void> createMembership(String token, String stripePaymentId) async {
    print('Creating membership with token: $token and payment ID: $stripePaymentId');
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


Future<String?> getPaymentIntentId(String sessionId) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions/$sessionId");
    print(url);
    try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $secretKey',
          },
        );
        print('Received response with status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          if (responseBody["payment_intent"] != null) {
            return responseBody["payment_intent"];
          }
        } else {
          print('Error: ${response.statusCode} - ${response.body}');
          return null;
        }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
    return null;
  }
}