import 'package:get/get.dart';
import 'package:my_app/controller/profile_controller.dart';
import 'package:my_app/widgets_common/custom_textfield.dart';
import '../../consts/consts.dart';
import '../../widgets_common/bg_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets_common/our_button.dart';
import 'dart:io';

class EditProfileScreen extends StatelessWidget {

  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    // Register the ProfileController
    var controller = Get.find<ProfileController>();
    controller.nameController.text = data['name'];
    controller.passController.text = data['password'];

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.profileImgPath.isEmpty ? Image.asset(imgProfile2, width: 100,fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
                  : Image.file(File(controller.profileImgPath.value),
                width: 100,
                fit: BoxFit.cover,
              ).box.roundedFull.clip(Clip.antiAlias).make(),

              10.heightBox,
              ourButton(color: redColor, onPress: (){
                controller.changeImage(context);
              }, textColor: whiteColor, title: "Change"),
              Divider(),
              20.heightBox,
              customTextField(controller: controller.nameController, hint: nameHint, title: name, isPass: false),
              customTextField(controller: controller.passController, hint: password, title: password, isPass: true),
              20.heightBox,
              SizedBox(width: context.screenWidth - 60,
                child: ourButton(color: redColor, onPress: (), textColor: whiteColor, title: "Save"),
              ),
            ],
          ).box.white.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50, left: 12, right: 12)).rounded.make(),
      ),
        ),
    );
  }
}
