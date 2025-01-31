
import 'dart:async' as _i4;

import 'package:lanchonete/models/user.dart' as _i2;
import 'package:lanchonete/services/auth_service.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;


class _FakeUser_0 extends _i1.SmartFake implements _i2.User {
  _FakeUser_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i3.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.User> login(
    String? email,
    String? password, {required String email, required String password},
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<_i2.User>.value(_FakeUser_0(
          this,
          Invocation.method(
            #login,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.User>);

  @override
  _i4.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<String?> getToken() => (super.noSuchMethod(
        Invocation.method(
          #getToken,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<_i2.User?> getCurrentUser() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i4.Future<_i2.User?>.value(),
      ) as _i4.Future<_i2.User?>);
}
