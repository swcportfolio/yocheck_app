import '../../../../common/di/di.dart';
import '../../repository/urine_repository.dart';
import '../base_usecase.dart';

/// 유린기 결과 리스트 조회 유스케이스
class GetAppVersionUseCase implements NoParamUseCase<void, void> {
  final UrineRepository _urineRepository;

  GetAppVersionUseCase([UrineRepository? urineRepository])
      : _urineRepository = urineRepository ?? locator();

  @override
  Future<String?> execute() {
    return _urineRepository.getAppVersion();
  }
}