import 'package:flutter/foundation.dart';

class QueueNotifier with ChangeNotifier {
  ValueNotifier<int> membersCounts = ValueNotifier(0);
  setMembersCount(count) {
    print("before count: $count");
    membersCounts.value = count;
    print("after count: ${membersCounts.value}");
    notifyListeners();
  }

  getmembersCount() {
    return membersCounts.value;
    print("after count: ${membersCounts.value}");
    notifyListeners();
  }
}
