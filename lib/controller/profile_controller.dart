import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;

  var profileImageLink = '';
  var isloading = false.obs;

  //textfield
  var nameController = TextEditingController();
  var passController = TextEditingController();

  changeImage(context) async{
    try {
      final img = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;

    } on PlatformException catch (e) {
      VxToast.show(context, msg:e.toString());
    }
  }

  uploadProfileImage() async{
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name,password,imgUrl}) async{
    var store = firestore.collection(usersCollection).doc(currentUser!.uid);
    await store.set({
      'name' : name,
      'password': password,
      'imageUrl': imgUrl
    }, SetOptions(merge: true));
    isloading(false);
  }

}
