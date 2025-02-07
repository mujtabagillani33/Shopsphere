import 'package:velocity_x/velocity_x.dart';
import 'package:my_app/consts/consts.dart';

class CheckoutScreen extends StatelessWidget {
  final double totalAmount; // Receive the totalAmount

  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Checkout".text.fontFamily(semibold).make(),
        backgroundColor: redColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display total amount
            "Total Amount".text.fontFamily(semibold).make(),
            SizedBox(height: 8),
            totalAmount.toStringAsFixed(2).text.size(32).fontFamily(semibold).make(),
            SizedBox(height: 20),

            // Add shipping address section
            "Shipping Address".text.fontFamily(semibold).make(),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Shipping Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Add payment section
            "Payment Method".text.fontFamily(semibold).make(),
            SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text("Select Payment Method"),
              items: ['Credit Card', 'Debit Card', 'Paypal']
                  .map((method) => DropdownMenuItem<String>(
                value: method,
                child: Text(method),
              ))
                  .toList(),
              onChanged: (String? newValue) {},
            ),
            SizedBox(height: 20),

            // Checkout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Add logic for final checkout (e.g., payment processing, order confirmation)
                // You can show a confirmation dialog or proceed with backend logic here.
                print("Proceeding to payment...");
              },
              child: "Proceed to Payment".text.fontFamily(semibold).white.make(),
            ),
          ],
        ),
      ),
    );
  }
}
