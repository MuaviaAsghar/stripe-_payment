import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:stripes_payment/stripes_service.dart';

class Stripes extends StatefulWidget {
  const Stripes({super.key});

  @override
  State<Stripes> createState() => _StripesState();
}

class _StripesState extends State<Stripes> {
  final TextEditingController amountController = TextEditingController();
  double doubleAmount = 0.0;
  bool isProcessing = false; // New variable to track button state

  @override
  void initState() {
    super.initState();
    amountController.addListener(_updateAmount);
  }

  void _updateAmount() {
    setState(() {
      doubleAmount = double.tryParse(amountController.text) ?? 0.0;
    });
  }

  @override
  void dispose() {
    amountController.removeListener(_updateAmount);
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment Integration"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Unfocus the text field
        },
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ProductCard(
                  imageUrl:
                      "https://th.bing.com/th/id/R.dc2e4cfa6a9697058a96997a32e4003e?rik=2fBt9L1Q8V0Qnw&pid=ImgRaw&r=0",
                  categoryName: 'Software',
                  productName: 'Flutter App',
                  price: doubleAmount,
                  currency: '\$', // Default is '$'
                  onTap: () {
                    // Handle card tap event
                  },
                  onFavoritePressed: () {
                    // Handle favorite button press
                  },
                  shortDescription:
                      'Flutter App Enter the price of your choice', // Optional short description
                  rating: 7.0, // Optional rating
                  discountPercentage: 50.0, // Optional discount percentage
                  isAvailable: true, // Optional availability status
                  cardColor: Colors.white, // Optional card background color
                  textColor: Colors.black, // Optional text color
                  borderRadius: 8.0, // Optional border radius
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Some Amount";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: amountController,
                ),
              ),
              isProcessing
                  ? const CircularProgressIndicator() // Show CircularProgressIndicator when processing
                  : MaterialButton(
                      onPressed: () async {
                        setState(() {
                          isProcessing =
                              true; // Disable button and show loading
                        });

                        int intAmount = doubleAmount.toInt();

                        if (intAmount > 0) {
                          await StripesService.instance
                              .makePayment(amount: intAmount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid amount entered")),
                          );
                        }

                        setState(() {
                          isProcessing =
                              false; // Re-enable button after processing
                        });
                      },
                      color: Colors.green,
                      child: const Text("Purchase"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
