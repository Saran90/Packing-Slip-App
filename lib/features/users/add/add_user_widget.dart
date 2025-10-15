import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/icon_text_field.dart';
import '../../../utils/colors.dart';
import '../models/user.dart';
import 'add_user_controller.dart';

class AddUserWidget extends StatelessWidget {
  AddUserWidget({super.key, this.user}){
    controller.setUser(user);
  }

  final User? user;
  final controller = AddUserController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [appColorGradient1, appColorGradient2],
          begin: Alignment.topLeft,
          stops: [0.5, 1],
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      height: 400,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  user == null ? 'Add User' : 'Update User',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              IconTextField(
                controller: controller.userNameController,
                hint: 'Enter username',
                textInputType: TextInputType.text,
                whiteBackground: false,
                label: 'Username',
              ),
              const SizedBox(height: 10),
              IconTextField(
                controller: controller.passwordController,
                hint: 'Enter password',
                textInputType: TextInputType.text,
                whiteBackground: false,
                label: 'Password',
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: AppButton(
                label: 'Save',
                onSubmit: controller.onSaveClicked,
                startColor: appColorGradient1,
                endColor: appColorGradient2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
