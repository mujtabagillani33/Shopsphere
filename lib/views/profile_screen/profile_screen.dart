import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_app/consts/lists.dart';
import 'package:my_app/views/auth_screen/login_screen.dart';
import 'package:my_app/views/profile_screen/components/detail_card.dart';
import 'package:my_app/views/profile_screen/edit_profile_screen.dart';
import 'package:my_app/widgets_common/bg_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../services/firestore_services.dart';
import '../../consts/consts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (!snapshot.data!.exists) {
              return Center(
                child: "No user data found".text.white.make(),
              );
            } else {
              var data = snapshot.data!.docs[0];

              // Safely access fields using the Map method
              String name =
                  data['name'] ?? 'No name'; // Default if 'name' doesn't exist
              String email = data['email'] ??
                  'No email'; // Default if 'email' doesn't exist
              int cartCount = data['cart_count'] ??
                  0; // Default if 'cart_count' doesn't exist
              int wishlistCount = data['wishlist_count'] ??
                  0; // Default if 'wishlist_count' doesn't exist
              int orderCount = data['order_count'] ??
                  0; // Default if 'order_count' doesn't exist

              // Convert the integer count to string
              String cartCountStr = cartCount.toString();
              String wishlistCountStr = wishlistCount.toString();
              String orderCountStr = orderCount.toString();

              return SafeArea(
                child: Column(
                  children: [
                    // EDIT PROFILE BUTTON
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit, color: whiteColor),
                      ).onTap(() {
                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),

                    // User details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Image.asset(imgProfile2, width: 80, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make(),
                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                "${data['email']}".text.white.make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: whiteColor),
                            ),
                            onPressed: () async {
                              await controller.signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make(),
                          )
                        ],
                      ),
                    ),

                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        detailsCard(
                          count: data['cart_count'], // Pass as String
                          title: "in your cart",
                          width: context.screenWidth / 3.4,
                        ),
                        detailsCard(
                          count: data['wishlist_count'], // Pass as String
                          title: "in your wishlist",
                          width: context.screenWidth / 3.4,
                        ),
                        detailsCard(
                          count: data['order_count'], // Pass as String
                          title: "your orders",
                          width: context.screenWidth / 3.4,
                        ),
                      ],
                    ),

                    // Buttons section
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(color: lightGrey);
                      },
                      itemCount: profileButtonsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading:
                              Image.asset(profileButtonsIcon[index], width: 22),
                          title: profileButtonsList[index].text.make(),
                        );
                      },
                    )
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
