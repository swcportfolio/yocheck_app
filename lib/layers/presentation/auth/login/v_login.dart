import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:urine/common/common.dart';
import 'package:urine/common/util/snackbar_utils.dart';
import 'package:urine/layers/model/authorization.dart';
import 'package:urine/layers/presentation/auth/login/vm_login.dart';
import 'package:urine/layers/presentation/auth/login/w_login_button.dart';
import 'package:urine/layers/presentation/auth/login/w_login_textfield.dart';

import '../../../../common/util/app_keyboard_util.dart';
import '../../widget/style_text.dart';
import 'w_signup_guide_button.dart';

enum LoginInputType { id, password }

/// 로그인 화면
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String get licenseText => '©2025 OPTOSTA, Inc. All rights reserved.';

  @override
  void initState() {
    super.initState();
    Future.delayed(2.seconds, () => _authLoginErrorMsg(context));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        child: Consumer<LoginViewModel>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () =>  FocusScope.of(context).unfocus(),
              child: SafeArea(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              /// 메인 BI 이미지
                              buildBiImage(),
                              const Gap(AppDim.xLarge),

                              /// 아이디 입력란
                              LoginTextField(
                                type: LoginInputType.id,
                                controller: provider.idController,
                              ),
                              const Gap(AppDim.medium),

                              /// 비밀번호 입력란
                              LoginTextField(
                                type: LoginInputType.password,
                                controller: provider.passController,
                              ),
                              const Gap(AppDim.medium),

                              /// 로그인 버튼
                              LoginButton(
                                onPressed: () => {
                                FocusScope.of(context).unfocus(),
                                  provider.login(context),
                                },
                              ),
                              const Gap(AppDim.xLarge),

                              /// 회원가입 안내 버튼
                              const SignUpGuideButton()
                            ],
                          ),
                        ),

                        /// 라이센스 마크
                        licenseMark()
                      ],
                    ),
                  )
            );
          },
        )
      ),
    );
  }

  /// 메인 BI 이미지
  buildBiImage() => Image.asset(
    '${Texts.imagePath}/login/logo.png',
    height: 50,
    width: 210,
  );


  /// 라이센스 마크
  Widget licenseMark() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: AppDim.medium),
      child: StyleText(
        text: licenseText,
        color: AppColors.greyTextColor,
        size: AppDim.fontSizeSmall,
        fontWeight: AppDim.weightBold,
      ),
    ),
  );


  _authLoginErrorMsg(context) {
    if(Authorization().userID == '-'){
      SnackBarUtils.showPrimarySnackBar(
        context,
        '자동로그인이 수행되지 못했습니다.',
      );
    }
  }
}
