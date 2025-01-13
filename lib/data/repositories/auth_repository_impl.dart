import '../datasource/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class EagleRidesAuthRepositoryImpl extends EagleRidesAuthRepository {
  final EagleRidesAuthDataSource eagleRidesAuthDataSource;
  // final AuthenticationLocalDataSource authenticationLocalDataSource;

  EagleRidesAuthRepositoryImpl({
    required this.eagleRidesAuthDataSource,
  }
      // this.authenticationLocalDataSource,
      );

  @override
  Future<String> loginUser(String email, String password) async {
    return await eagleRidesAuthDataSource.loginUser(email, password);
  }

  @override
  Future<String> register(Map<String, dynamic> requestBody) async {
    return await eagleRidesAuthDataSource.register(requestBody);
  }

  // @override
  // Future<Either<AppError, bool>> loginUser(Map<String, dynamic> body) async {
  //   try {
  //     // body.putIfAbsent('request_token', () => token1);
  //     final validateWithLoginToken =
  //         await eagleRidesAuthDataSource.validateWithLogin(body);
  //     // final sessionId =
  //     //     await eagleRidesAuthDataSource.createSession(validateWithLoginToken);
  //     if (validateWithLoginToken != null) {
  //       await authenticationLocalDataSource
  //           .saveSessionId(validateWithLoginToken.message);
  //       return const Right(true);
  //     }
  //     return const Left(AppError(AppErrorType.sessionDenied));
  //   } on SocketException {
  //     return const Left(AppError(AppErrorType.network));
  //   } on UnauthorisedException {
  //     return const Left(AppError(AppErrorType.unauthorised));
  //   } on Exception {
  //     return const Left(AppError(AppErrorType.api));
  //   }
  //   // return await eagleRidesAuthDataSource.eagleridesAuthIsSignIn();
  // }

  @override
  Future<bool> eagleRidesAuthIsSignIn() async {
    return await eagleRidesAuthDataSource.eagleridesAuthIsSignIn();
  }

  @override
  Future<void> eagleRidesAuthPhoneVerification(String phoneNumber) async {
    return await eagleRidesAuthDataSource
        .eagleridesAuthPhoneVerification(phoneNumber);
  }

  @override
  Future<String> eagleRidesAuthOtpVerification(String email, String otp) async {
    return await eagleRidesAuthDataSource.eagleridesAuthOtpVerification(
        email, otp);
  }

  @override
  Future<String> eagleRidesAuthGetUserUid() async {
    return await eagleRidesAuthDataSource.eagleridesAuthGetUserUid();
  }
  @override
  Future<Map<String, dynamic>> getUser() async {
    return await eagleRidesAuthDataSource.getUser();
  }

  @override
  Future<bool> eagleRidesAuthCheckUserStatus(String userId) async {
    return await eagleRidesAuthDataSource.eagleridesAuthCheckUserStatus(userId);
  }

  @override
  Future<void> eagleRidesAuthSignOut() async {
    return await eagleRidesAuthDataSource.eagleridesAuthSignOut();
  }

  @override
  Future<String> eagleRidesAddProfileImg(String riderId) async {
    return await eagleRidesAuthDataSource.eagleridesAddProfileImg(riderId);
  }
}
