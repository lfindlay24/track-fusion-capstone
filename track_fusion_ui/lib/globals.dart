library track_fusion_ui.globals;

import 'package:crypt/crypt.dart';

String userId = '';

String apiBasePath =
    'https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion';

String? saltAndHashPassword(String password) {
  return Crypt.sha256(password).toString();
}
