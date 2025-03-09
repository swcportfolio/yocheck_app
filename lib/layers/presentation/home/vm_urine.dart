import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urine/common/common.dart';
import 'package:urine/layers/domain/usecase/urine/app_version_usecase.dart';
import 'package:urine/layers/entity/user_name_dto.dart';
import 'package:urine/layers/model/authorization.dart';
import 'package:urine/main.dart';

import '../../domain/usecase/urine/urine_ai_analysis_usecase.dart';
import '../../domain/usecase/urine/urine_result_usecase.dart';
import '../../domain/usecase/urine/user_name_usecase.dart';
import '../../entity/urine_result_dto.dart';
import '../analysis/result/d_ai_analysis.dart';
import '../ingredient/v_ingredient_result.dart';
import '../widget/w_custom_dialog.dart';
//import 'package:url_launcher/url_launcher.dart';

class UrineViewModel extends ChangeNotifier {
  late BuildContext context;

  UrineViewModel(this.context) {
    getUserName();
    fectchAppVersion();
  }

  /// 유저 이름
  String userName = '-';

  /// 유저 이름 가져오기
  Future<void> getUserName() async {
    try {
      logger.d(Authorization().userID);

      UserNameDTO? response = await UserNameUesCase().execute();
      if (response?.status.code == Texts.successCode &&
          response?.name != null) {
        userName = response!.name;
        Authorization().name = userName;
      }
      notifyListeners();
    } catch (e) {
      logger.e('=> user name: ${e.toString()}');
    }
  }

  /// 최신 버전 정보 가져오기
  Future<void> fectchAppVersion() async {
    const iosPlatform = MethodChannel('com.wonpl.urine/appstore');
    const androidPlatform = MethodChannel('com.wonpl.urine/playstore');

    try {
      final response = await GetAppVersionUseCase().execute();
      if (Texts.appVersion != response) {
        CustomDialog.showVersionDialog(
            title: '업데이트가 필요합니다!',
            text: '월할한 서비스 이용을 위해 최신\n버전으로 업데이트 필요합니다.',
            mainContext: context,
            onPressed: () async {
              if (Platform.isAndroid) {
                await androidPlatform.invokeMethod('redirectToPlayStore');
              } else {
                await iosPlatform.invokeMethod('openAppStore');
              }
            });
      }
    } catch (error) {
      logger.e(error);
    }
  }

  /// 성분 분석: 측정된 소변데이터로
  /// 한밭대학교에서 제공해주는 API 연동
  Future<void> fetchAiAnalyze(BuildContext context) async {
    showAiAnalysisDialog(context);

    Future.delayed(2.seconds, () async {
      try {
        UrineResultDTO? urineResultDTO = await UrineResultCase().execute('');

        if (urineResultDTO?.status.code == '200') {
          List<String> statusList =
              urineResultDTO!.data!.map((value) => value.status).toList();

          Map<String, dynamic> toMap = {
            "blood": statusList[0] == '0' || statusList[0] == '5'
                ? '-'
                : '${statusList[0]}+',
            "bilirubin": statusList[1] == '0' || statusList[1] == '5'
                ? '-'
                : '${statusList[1]}+',
            "urobilinogen": statusList[2] == '0' || statusList[2] == '5'
                ? '-'
                : '${statusList[2]}+',
            "ketones": statusList[3] == '0' || statusList[3] == '5'
                ? '-'
                : '${statusList[3]}+',
            "protein": statusList[4] == '0' || statusList[4] == '6'
                ? '-'
                : '${statusList[4]}+',
            "nitrite": statusList[5] == '1' ? '1+' : '-',
            "glucose": statusList[6] == '0' || statusList[6] == '6'
                ? '-'
                : '${statusList[6]}+',
            "leukocytes": statusList[9] == '0' || statusList[9] == '5'
                ? '-'
                : '${statusList[9]}+',
          };

          String? result = await UrineAiAnalysisUseCase().execute(toMap);
          logger.d(toMap);
          if (result != null &&
              (result != 'ERROR' || result != 'unknown') &&
              context.mounted) {
            Nav.doPop(context); // 성분분석 진행 알림 다이얼로그 pop
            Nav.doPush(
                context,
                IngredientResultView(
                    resultText: result, statusList: statusList));
          } else {
            if (context.mounted) {
              aiDialog(context, '정상적으로 처리 되지 않았습니다.\n다시 시도 해주세요.');
            }
          }
        } else {
          if (context.mounted) {
            aiDialog(context, '최근에 검사한 이력이 없습니다.');
          }
        }
      } catch (e) {
        logger.i('성분분석 : $e');
        if (context.mounted) {
          aiDialog(context, '정상적으로 처리 되지 않았습니다.\n다시 시도 해주세요.');
        }
      }
    });
  }

  /// AI 성분 분석 시작시 보여주는 다이얼로그
  /// 분석 시작시 다른 이벤트 못받게 설정함
  showAiAnalysisDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AiAnalysisAlertDialog();
      },
    );
  }

  /// ai 성분분석 다이얼로그
  aiDialog(BuildContext context, String message) {
    Nav.doPop(context); // showAiAnalysisDialog pop
    CustomDialog.showMyDialog(
      title: '성분 분석',
      content: message,
      mainContext: context,
    );
  }
}
