import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../auth_provider.dart';

class Payment extends StatefulWidget {
  final dynamic tour;
  final int quantity;
  final double totalPrice;
  final dynamic booking;
  final List<String> dni;
  final List<Map<String, dynamic>> userData;

  const Payment({
    Key? key,
    required this.tour,
    required this.quantity,
    required this.totalPrice,
    required this.booking,
    required this.dni,
    required this.userData,
    required Map user,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late List<PaymentItem> _paymentItems;

  @override
  void initState() {
    super.initState();
    _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: widget.totalPrice.toString(),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  void onGooglePayResult(paymentResult) {
    Fluttertoast.showToast(msg: 'Pago realizado correctamente');
    print(paymentResult);
    sendPaymentDataToBackend(paymentResult); // Envía datos al backend
  }

  void sendPaymentDataToBackend(paymentResult) async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    Uri url = Uri.parse('http://192.168.137.217:4000/api/v1/payment/create');
    try {
      var response = await http.post(url,
          body: json.encode({
            'user': {'username': user.username, 'email': user.email},
            'tourId': widget.tour['_id'],
            'quantity': widget.quantity,
            'totalPrice': widget.totalPrice,
            'booking': widget.booking,
            'dni': widget.dni,
            'userData': widget.userData,
            'paymentResult': paymentResult,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Payment data saved: ${responseData['paymentId']}');
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al enviar datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentConfiguration = PaymentConfiguration.fromJsonString(
      jsonEncode({
        "provider": "google_pay",
        "data": {
          "environment":
              "TEST", // Asegúrate de cambiar esto a PRODUCTION cuando estés listo para lanzar
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "allowedCardNetworks": ["AMEX", "VISA", "MASTERCARD"]
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": "acceptblue",
                  "gatewayMerchantId":
                      "your_merchant_id" // Asegúrate de reemplazar "your_merchant_id" con tu ID de comerciante real
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantId":
                "BCR2DN4TYHYLHFIT", // Reemplaza con tu ID de comerciante real
            "merchantName":
                "Your Merchant Name" // Reemplaza con el nombre de tu comerciante
          },
          "transactionInfo": {
            "totalPriceStatus": "FINAL",
            "totalPriceLabel": "Total",
            "countryCode": "PE",
            "currencyCode": "PEN"
          }
        }
      }),
    );

    return Scaffold(
      body: Center(
        child: GooglePayButton(
          paymentConfiguration: paymentConfiguration,
          paymentItems: _paymentItems,
          onPaymentResult: onGooglePayResult,
          type: GooglePayButtonType.buy,
          margin: const EdgeInsets.only(top: 15.0),
          loadingIndicator: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
