import 'package:my_app/consts/consts.dart';

class FirestoreServices {

  //getUser Data
  static getUser(uid){
    return firestore.collection(usersCollection).where('id',isEqualTo: uid).snapshots();
  }
}