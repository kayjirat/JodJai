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
  ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;

    productItems.forEach((val) {
      var productPrice = (val["productPrice"] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems +=
          "&line_items[$index][price_data][unit_amount]=${productPrice}";
      lineItems += "&line_items[$index][price_data][currency]=THB";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";

      index++;
    });

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

  static Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
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
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );
      return text;
    }
  }
}
