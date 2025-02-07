import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/controller/auth_controller.dart';
import 'package:my_app/services/firestore_services.dart';
import 'package:my_app/widgets_common/bg_widget.dart';
import 'package:my_app/views/cart_screen/checkout_screen.dart'; // Make sure this is imported
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Obx(() {
      var currentUser = controller.currentUser;

      // If user is not logged in
      if (currentUser == null) {
        return Center(
          child: "User is not logged in."
              .text
              .fontFamily(semibold)
              .make(),
        );
      }

      return bgWidget(
        child: Scaffold(
          appBar: AppBar(
            title: "Your Cart".text.fontFamily(semibold).make(),
            backgroundColor: redColor,
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirestoreServices.getUser(currentUser.uid),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              // Show loading indicator
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              }

              // Handle case when user data is not available
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: "No user data found"
                      .text
                      .white
                      .make(),
                );
              }

              var data = snapshot.data!.data() as Map<String, dynamic>;
              List<dynamic> cartItems = data['cart'] ?? [];
              double total = 0;

              // Calculate the total price
              if (cartItems.isNotEmpty) {
                total = cartItems.fold(0, (sum, item) {
                  return sum + (item['price'] * item['quantity']);
                });
              }

              // Show empty cart message
              if (cartItems.isEmpty) {
                return Center(
                  child: "Your Cart is Empty"
                      .text
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              }

              // Display cart items and total
              return ListView(
                children: [
                  // Cart Items List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Product Image
                              Image.network(
                                item['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.image, size: 80, color: darkFontGrey),
                              ),
                              10.widthBox,

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    item['name']
                                        .text
                                        .fontFamily(semibold)
                                        .make(),
                                    "Price: \$${item['price']}".text.make(),
                                    "Quantity: ${item['quantity']}".text.make(),
                                  ],
                                ),
                              ),

                              // Delete Button
                              IconButton(
                                icon: Icon(Icons.delete, color: redColor),
                                onPressed: () {
                                  FirestoreServices.removeItemFromCart(
                                      currentUser.uid, item['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Total Price Display
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total".text.fontFamily(semibold).make(),
                        "\$${total.toStringAsFixed(2)}"
                            .text
                            .fontFamily(semibold)
                            .make(),
                      ],
                    ),
                  ),

                  // Proceed to Checkout Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to CheckoutScreen with the total amount
                        Get.to(() => CheckoutScreen(totalAmount: total));
                      },
                      child: "Proceed to Checkout"
                          .text
                          .fontFamily(semibold)
                          .white
                          .make(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
