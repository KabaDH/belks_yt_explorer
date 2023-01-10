import 'package:belks_tube/data/providers/app_config.dart';
import 'package:belks_tube/data/repo/local/base_local_repository.dart';
import 'package:belks_tube/data/repo/local/prefs_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_repo.g.dart';

@riverpod
LocalRepo localRepo(LocalRepoRef ref) => LocalRepo(ref);

class LocalRepo implements BaseLocalRepo {
  LocalRepo(this.ref);

  final Ref ref;

  SharedPreferences get prefs => ref.read(prefsProvider);

  @override
  String getDefChannelId() {
    if (prefs.containsKey('defChannelId')) {
      return prefs.getString('defChannelId') ?? '';
    } else {
      return AppConfig.defChannel;
    }
  }

  @override
  List<String> getFavoriteChannelsIds() {
    if (prefs.containsKey('favoriteChannelsID')) {
      return prefs.getStringList('favoriteChannelsID') ?? [];
    } else {
      return [AppConfig.defChannel];
    }
  }
}
