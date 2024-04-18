import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';

class Payment extends StatefulWidget {
  final dynamic tour;
  final int quantity;
  final double totalPrice;
  final dynamic booking;
  final dynamic user;
  final List<String> dni;
  final List<Map<String, dynamic>> userData;

  const Payment({
    Key? key,
    required this.tour,
    required this.quantity,
    required this.totalPrice,
    required this.booking,
    required this.user,
    required this.dni,
    required this.userData,
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
    // Aquí puedes enviar el token de pago a tu servidor
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
