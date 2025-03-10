import '../../../../common/di/di.dart';
import '../../repository/urine_repository.dart';
import '../base_usecase.dart';

/// 유린기 히스토리 유스케이스
class DeleteHistoryCase implements BaseUseCase<void, String> {
  final UrineRepository _urineRepository;

  DeleteHistoryCase([UrineRepository? urineRepository]) :
        _urineRepository = urineRepository ?? locator();

  @override
  Future<String> execute(String dateTime) {
    return _urineRepository.deleteHistory(dateTime);
  }
}