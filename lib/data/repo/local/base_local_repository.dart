
import 'package:belks_tube/domain/channel/channel_model.dart';

abstract class BaseLocalRepo {
  String getDefChannelId();

  List<String> getFavoriteChannelsIds();

  void setMainChannel(Channel channel);

  void setFavoriteChannelsIds(List<String> favChannelsIds);
}
