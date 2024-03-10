import 'dart:io';

import 'package:daprot_v1/config/routes/routes_manager.dart';
import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:daprot_v1/features/screens/auth_screen/custom_text_field.dart';
import 'package:daprot_v1/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetProfileScreen extends StatefulWidget {
  const SetProfileScreen({super.key});

  @override
  SetProfileScreenState createState() => SetProfileScreenState();
}

class SetProfileScreenState extends State<SetProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  XFile? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final inputTextSize = screenWidth * 0.04;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 0.15 * screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Stack(
                  children: [
                    ProfilePhoto(profileImage: _profileImage),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 24,
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomTextFormField(
                controller: _nameController,
                inputTextSize: inputTextSize,
                label: 'Name',
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomTextFormField(
                  controller: _emailController,
                  inputTextSize: inputTextSize,
                  label: 'Email'),
              SizedBox(height: screenHeight * 0.03),
              CustomTextFormField(
                  controller: _emailController,
                  inputTextSize: inputTextSize,
                  label: 'Phone Number'),
              SizedBox(height: screenHeight * 0.03),
              DelevatedButton(
                text: 'Create Account',
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.homeRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required XFile? profileImage,
  }) : _profileImage = profileImage;

  final XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: _profileImage == null
          ? Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[600],
            )
          : ClipOval(
              child: Image.file(
                File(_profileImage!.path),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
