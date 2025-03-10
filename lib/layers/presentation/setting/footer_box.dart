
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../widget/style_text.dart';

class FooterBox extends StatelessWidget {
  const FooterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(AppDim.medium),
      color: Colors.grey.shade200,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyleText(
            text: '(주)옵토스타',
            size: AppDim.fontSizeSmall,
            fontWeight: AppDim.weightBold,
          ),
          StyleText(
            text: '주소 : 대전광역시 유성구 가정로 168 본관2층\nTel : 033-258-6114\n사업자 등록번호 안내 : 314-81-49070\nCopyright  2025 ㈜옵토스타. All rights reserved.\n고객센터 번호: 1877-8082',
            softWrap: true,
            height: 2,
            size: AppDim.fontSizeXSmall,
            maxLinesCount: 10,
            fontWeight: AppDim.weight500,
          )
        ],
      ),
    );
  }
}
