import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/services/firestore_services.dart';
import 'package:my_app/views/category_screen/item_details.dart';
import 'package:my_app/widgets_common/bg_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryDetails extends StatelessWidget {
  final String title;

  const CategoryDetails({super.key, required this.title});

  // Loading indicator widget
  Widget loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: redColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: title.text.fontFamily(bold).white.make(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices.getProducts(title),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Handle connection states
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator();
            }

            // Handle errors
            if (snapshot.hasError) {
              return Center(
                child: "An error occurred: ${snapshot.error}"
                    .text
                    .color(redColor)
                    .make(),
              );
            }

            // Handle empty data
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No products found for this category"
                    .text
                    .color(darkFontGrey)
                    .make(),
              );
            }

            // Data loaded successfully, build the UI
            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  var product = snapshot.data!.docs[index];
                  var productData = product.data() as Map<String, dynamic>?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        productData?['image_url'] ?? imgP5, // Default image if null
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      10.heightBox,
                      (productData?['name'] ?? "No Name")
                          .toString()
                          .text
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      "RS ${productData?['price'] ?? '0'}"
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(16)
                          .make(),
                    ],
                  )
                      .box
                      .white
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .roundedSM
                      .outerShadowSm
                      .padding(const EdgeInsets.all(12))
                      .make()
                      .onTap(() {
                    Get.to(
                          () => ItemDetails(title: productData?['name'] ?? "No Name"),
                      arguments: productData,
                    );
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
