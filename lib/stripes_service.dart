import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripes_payment/consts.dart';

class StripesService {
  StripesService._();
  static final StripesService instance = StripesService._();

  Future<void> makePayment({required int amount}) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, "usd");
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Muavia Asghar",
        ),
      );

      await _processPayment();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          headers: {"Authorization": "Bearer $stripeSecretKey"},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.data != null && response.data is Map) {
        print(response.data);
        return response.data['client_secret'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
