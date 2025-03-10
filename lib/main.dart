import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'common/common.dart';
import 'common/data/preference/app_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'common/data/preference/prefs.dart';
import 'common/di/di.dart';
import 'layers/domain/usecase/auth_usecase.dart';
import 'layers/entity/login_dto.dart';
import 'layers/model/authorization.dart';


/// 1차 기능 구현(1월 5일 ~ 1월 31일)
/// 1. 앱 자동업데이트 공지 기능(버전관리) - 완료
/// 2. 인체용, 동물용 플랫폼 분리 검토(userType[H, P]) 로그인, 회원가입
/// 2-1. 각 api들 마다 userType이 들어갈수 있도록 수정해야됨 - 완료
/// 3. 옵토스타용 footer 만들기 - 완료
/// 4. 홈버튼이나 기능버튼으로 바로 이동하느 기능 - 완료(결과화면, 관련질환 화면)
/// 5. 앱에서 검사지 또는 검사기 구매 하는 기능 - 완료
/// 6. 검사 내역 삭제 기능

var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 1,      // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120,     // width of the output
        colors: true,        // Colorful log messages
        printEmojis: false,  // Print an emoji for each log message
        printTime: false     // Should each log print contain a timestamp
    )
);

Future<void> main() async {
  // 플랫폼 채널의 위젯 바인딩을 보장해야한다.
  final bindings = WidgetsFlutterBinding.ensureInitialized();

  // Flutter 초기화가 완료될 때까지 스플래시 화면을 표시합니다.
  FlutterNativeSplash.preserve(widgetsBinding: bindings);

  // EasyLocalization 패키지를 초기화하여 로컬라이제이션을 지원합니다.
  await EasyLocalization.ensureInitialized();

  // SharedPreferences 초기화
  await AppPreferences.init();

  // Locator 초기화
  initLocator();

  // 사용자 정보 초기화
  await initAuthorization();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}

/// 사용자 정보 초기화
Future<void> initAuthorization() async {
  logger.i('afterFirstLayout');

  final userID = Prefs.userID.get();
  final password = Prefs.password.get();
  final token = Prefs.token.get();
  final toggleGatt = Prefs.toggelGatt.get();

  Authorization().setValues(
      userID: userID,
      password: password,
      token: token,
  );
  Authorization().toggleGatt = toggleGatt;

  if(Authorization().userID.isNotEmpty){
    await login();
  }
}


/// 로그인 진행
Future<void> login() async {
  Map<String, dynamic> toMap(){
    return {
      'userID'   : Authorization().userID,
      'password' :  Authorization().password,
    };
  }

  try {
   LoginDTO? response = await LoginUseCase().execute(toMap());
        if (response?.status.code == '200' && response != null){
          Authorization().token = response.data!;
          Prefs.token.set(response.data!);
          logger.d('로그인 성공: ${Authorization().userID}');
        } else {
          Authorization().userID = '-';
        }
  } on DioException catch (e) {
    logger.e(e);
    Authorization().userID = '-';
  } catch (e) {
    logger.e(e);
    Authorization().userID = '-';
  }
}


