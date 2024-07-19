import 'dart:io';

import 'package:arcitech/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxString userId = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString photoUrl = "".obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  loginUser({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  registerUser(
      {required String email,
      required String password,
      required String fName,
      required String lname}) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      firebaseFirestore
          .collection("users")
          .doc(user.user?.uid)
          .set({'firstName': fName, 'lastname': lname, 'photoUrl': ""});
      Get.to(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  getCurrentUser() async {
    isLoading(true);
    userId.value = auth.currentUser?.uid ?? "";
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId.value)
        .get();

    print(snapshot.data());
    firstName.value = snapshot.data()?['firstName'];
    lastName.value = snapshot.data()?['lastname'];
    photoUrl.value = snapshot.data()?['photoUrl'] ?? "";

    DocumentSnapshot doc =
        await firebaseFirestore.collection('profiles').doc(userId.value).get();

    print(doc.data());

    isLoading(false);
  }

  updateProfile(String name) async {
    await firebaseFirestore.collection('users').doc(userId.value).update({
      'firstName': name,
    });
    isEditing.value = false;
  }


  uploadProfilePicture() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      updateProfilePicture(pickedImage);
    }
  }
  updateProfilePicture(XFile pickedImage) async {
    try {
      isLoading.value = true;
      String uid = auth.currentUser!.uid;
      File file = File(pickedImage.path);
      String fileName = uid + DateTime.now().toString();
      firebase_storage.Reference ref =
          storage.ref().child('profile_images').child(fileName);
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();
      await firebaseFirestore.collection('profiles').doc(uid).update({
        'photoUrl': imageUrl,
      });
      getCurrentUser();
      // profile.update((val) {
      //   if (val != null) {
      //     val.photoUrl = imageUrl;
      //   }
      // });
      Get.snackbar('Success', 'Profile picture updated successfully');
    } catch (e) {
      print('Error updating profile picture: $e');
      Get.snackbar('Error', 'Failed to update profile picture');
    } finally {
      isLoading.value = false;
    }
  }
}
