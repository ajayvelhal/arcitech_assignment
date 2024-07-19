import 'dart:io';

import 'package:arcitech/controller/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User? _user;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
      await firebaseController.getCurrentUser();
    });
    _firstNameController.text = firebaseController.firstName.value;
    _lastNameController.text = firebaseController.lastName.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                firebaseController.isEditing.value = !firebaseController.isEditing.value;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Obx(()=> Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            firebaseController.isEditing.value ? GestureDetector(
              onTap: ()=> firebaseController.uploadProfilePicture(),
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2.0),
                ),child: const Icon(Icons.person,size: 50.0,),),

            ):
            CircleAvatar(
              radius: 50,
              backgroundImage: firebaseController.photoUrl.value != ""
                  ? NetworkImage(firebaseController.photoUrl.value)
                  : null,
              child: firebaseController.photoUrl.value == ""
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20.0),
            firebaseController.isEditing.value
                ? TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            )
                : Text(
              _firstNameController.text,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            firebaseController.isEditing.value
                ? ElevatedButton(
              onPressed: ()=>firebaseController.updateProfile(_firstNameController.text),
              child: const Text('Save'),
            )
                : const SizedBox(),
          ],
        ),)
      )
    );
  }
}
