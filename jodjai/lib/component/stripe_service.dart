import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secretKey =
      "sk_test_51PRtSeLd274l8yopgPGPrdtzTjAz2ja83WQJgtV13abWqeh28eKpWaL6g23kZTyhhwmr8USdXRP6S3uKUB3q9uMi00OCwvWjAi";
  static String publishableKey =
      "pk_test_51PRtSeLd274l8yopdSnadyEX4ZtuBlyvebYdUh8ZltsSec3dx50d1EAhhXZrYMWtqEBffONOCWdYRmduJ7wdugw2008IemPt6T";

  static Future<String?> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
    String successUrl,
    String cancelUrl,
  ) async {
    final url =
        Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;

    productItems.forEach((val) {
      var productPrice =
          (val["productPrice"] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems +=
          "&line_items[$index][price_data][unit_amount]=${productPrice}";
      lineItems += "&line_items[$index][price_data][currency]=THB";
      lineItems +=
          "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    });

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

  static Future<dynamic> stripePaymentCheckout(
    List<dynamic> productItems,
    totalAmount,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
    String successUrl = "http://localhost:56856/#/success",
    String cancelUrl = "http://localhost:56856/#/cancel",
  }) async {
    final String? sessionId = await createCheckoutSession(
      productItems,
      totalAmount,
      successUrl,
      cancelUrl,
    );

    if (sessionId == null) {
      print('Failed to create Stripe checkout session');
      if (onError != null) {
        onError('Failed to create Stripe checkout session');
      }
      return;
    }

    try {
      final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: successUrl,
        canceledUrl: cancelUrl,
      );

      if (mounted) {
        result.when(
          redirected: () {
            print('Redirected Successfully');
          },
          success: () {
            print('Payment Successful');
            onSuccess(); // Call your success callback
          },
          canceled: () {
            print('Payment Canceled');
            onCancel(); // Call your cancel callback
          },
          error: (e) {
            print('Payment Error: $e');
            onError(e); // Call your error callback
          },
        );
      }
    } catch (e) {
      print('Exception during payment: $e');
      onError(e.toString()); // Handle any exceptions
    }
  }
}
