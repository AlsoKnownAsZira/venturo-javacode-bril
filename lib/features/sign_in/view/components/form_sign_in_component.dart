import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:venturo_core/configs/themes/main_color.dart';
import 'package:venturo_core/features/sign_in/controllers/sign_in_controller.dart';
import 'package:venturo_core/shared/customs/text_form_field_custom.dart';

class FormSignInCompoent extends StatelessWidget {
  const FormSignInCompoent({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: SignInController.to.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormFieldCustoms(
            controller: SignInController.to.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            initialValue: SignInController.to.emailValue.value,
            label: "Email Address",
            hint: "Input Email Address",
            isRequired: true,
            requiredText: "Email address cannot be empty",
          ),
          SizedBox(
            height: 40.h,
          ),
          Obx(
            () => TextFormFieldCustoms(
              controller: SignInController.to.passwordCtrl,
              keyboardType: TextInputType.visiblePassword,
              initialValue: SignInController.to.passwordValue.value,
              label: "Password",
              hint: "Input Password",
              isRequired: true,
              isPassword: SignInController.to.isPassword.value,
              requiredText: "Password cannot be empty",
              suffixIcon: GestureDetector(
                onTap: () => SignInController.to.showPassword(),
                child: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    SignInController.to.isPassword.value == true
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 16,
                    color: MainColor.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

