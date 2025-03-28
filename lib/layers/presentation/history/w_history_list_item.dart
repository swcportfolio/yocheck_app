import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:urine/common/common.dart';
import 'package:urine/common/util/snackbar_utils.dart';
import 'package:urine/common/util/text_format.dart';
import 'package:urine/layers/presentation/history/vm_urine_history.dart';

import '../../entity/history_dto.dart';
import '../analysis/result/v_urine_result.dart';
import '../widget/style_text.dart';
import '../widget/w_custom_dialog.dart';

class HistoryListItem extends StatelessWidget {

  final HistoryDataDTO history;

  const HistoryListItem({Key? key,
    required this.history,
  }) : super(key: key);

  String get negativeText => '음성';
  String get positiveText => '양성';

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<HistoryViewModel>(context, listen: false);

    return InkWell(
      /// 아이템 클릭 시 이벤트 처리
      onTap: () => viewModel.getUrineResultDio(history.datetime)
          .then((urineStatus)=>{
            if(urineStatus.isNotEmpty && urineStatus.length == 11){
              Nav.doPush(context, UrineResultView(urineList: urineStatus, testDate: history.datetime)),
            } else {
              SnackBarUtils.showPrimarySnackBar(context, '데이터 손상이 있습니다. 다시 시도해주세요.')
            }
          }),
      child: SizedBox(
          height: 85,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    StyleText(
                        text: TextFormat.convertTimestamp(history.datetime),
                        color: AppColors.blackTextColor,
                        size: AppDim.fontSizeSmall,
                        fontWeight: AppDim.weight500,
                        maxLinesCount: 1,
                    ),
                    const Gap(AppDim.small),

                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: AppDim.xSmall, horizontal: AppDim.medium),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(AppConstants.radius),
                                border: Border.all(color: AppColors.primaryColor),
                              ),
                              child: StyleText(
                                  text: negativeText,
                                  color: AppColors.primaryColor,
                              ),
                            ),
                            StyleText(
                                text: ' - ${history.negativeCnt}',
                                size: AppDim.fontSizeLarge,
                                fontWeight: AppDim.weight500,
                                color: AppColors.primaryColor,
                            ),
                          ],
                        ),

                        const Gap(AppDim.medium),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: AppDim.xSmall, horizontal: AppDim.medium),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(AppConstants.radius),
                                border: Border.all(color: AppColors.orange),
                              ),
                              child: StyleText(
                                text: positiveText,
                                color: AppColors.orange
                              ),
                            ),
                            StyleText(
                              text: ' - ${history.positiveCnt}',
                              size: AppDim.fontSizeLarge,
                              fontWeight: AppDim.weight500,
                              color: AppColors.orange,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),

                InkWell(
                  onTap: () {
                    CustomDialog.showDeleteDialog(
                      title: '검사내역 삭제',
                      text: '${TextFormat.convertTimestamp(history.datetime)}\n검사한 내역을 삭제하시겠습니까?',
                      mainContext: context,
                      onPressed: () => {
                     context.read<HistoryViewModel>().deleteHistory(history.datetime),
                     Nav.doPop(context)
                  },
                );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: AppColors.grey,
                      size: AppDim.iconSmall,
                    ),
                  ),
                ),
          ]
          )
      ),
    );
  }

}