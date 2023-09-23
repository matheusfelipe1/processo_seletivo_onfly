import 'package:processo_seletivo_onfly/core/provider/auth/iauth_controller.dart';

class AuthController extends IAuthController {
  static final AuthController _instance = AuthController._();
  AuthController._() {
    doAuthenticate();
  }
  factory AuthController() => _instance;
  
  @override
  void doAuthenticate() async {
    await auth.doAuthenticate();
  }


}