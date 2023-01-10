import 'package:belks_tube/screens/home/home_screen_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenControllerNotifier extends StateNotifier<HomeScreenModel> {
  HomeScreenControllerNotifier(this.ref) : super(HomeScreenModel.defModel);
  Ref ref;

  static final provider =
      StateNotifierProvider<HomeScreenControllerNotifier, HomeScreenModel>(
          (ref) {
    return HomeScreenControllerNotifier(ref);
  });
}
