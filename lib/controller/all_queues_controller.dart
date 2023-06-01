import 'package:get/get.dart';

///AllQueues Controller
class AllQueuesController extends GetxController {
  final RxString _selected = '-1'.obs;

  ///get selected value
  String get selected => _selected.value;

  ///set value
  void setSelected(String value) {
    _selected.value = value;
    update();
  }
}
