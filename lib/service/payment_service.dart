import 'dart:convert';

import 'package:book_now/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  Future<void> makePayment(BuildContext context, Map<String, dynamic>? paymentIntent, int amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount.toString(), 'USD');
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Boris'))
          .then((value) {});

      displayPaymentSheet(context, paymentIntent);
    } catch (e) {
      rethrow;
    }
  }

  displayPaymentSheet(BuildContext context, Map<String, dynamic>? paymentIntent) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        Navigator.pushNamedAndRemoveUntil(context, '/reservation-details/', (route) => false);
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text("Successful booking"),
                    ],
                  ),
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        // ignore: avoid_print
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      // ignore: avoid_print
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}