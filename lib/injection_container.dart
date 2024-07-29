import 'package:eaglerides/data/datasource/ride_map_data_source.dart';
import 'package:eaglerides/data/datasource/ride_map_data_source_impl.dart';
import 'package:eaglerides/data/repositories/ride_map_repository_impl.dart';
import 'package:eaglerides/domain/repositories/ride_map_repository.dart';
import 'package:eaglerides/domain/usecases/cancel_trip_usecase.dart';
import 'package:eaglerides/domain/usecases/direction_usecase.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_check_user_usecase.dart';
import 'package:eaglerides/domain/usecases/generate_rental_charges_usecase.dart';
import 'package:eaglerides/domain/usecases/generate_trip_usecase.dart';
import 'package:eaglerides/domain/usecases/get_address_use_case.dart';
import 'package:eaglerides/domain/usecases/login_user.dart';
import 'package:eaglerides/domain/usecases/ride_map_prediction_usecase.dart';
import 'package:eaglerides/domain/usecases/trip_payment_usecase.dart';
import 'package:eaglerides/domain/usecases/vwhicle_detail_usecase.dart';
import 'package:eaglerides/presentation/controller/home/home_controller.dart';
import 'package:eaglerides/presentation/controller/ride/live_tracking_controller.dart';
import 'package:eaglerides/presentation/controller/ride/ride_controller.dart';
import 'package:http/http.dart';
import 'package:eaglerides/core/network_checker/network_checker_controller.dart';
import 'package:eaglerides/data/datasource/auth_remote_data_source.dart';
import 'package:eaglerides/data/datasource/auth_remote_data_source_impl.dart';
import 'package:eaglerides/data/repositories/auth_repository_impl.dart';
import 'package:eaglerides/domain/repositories/auth_repository.dart';
import 'package:eaglerides/domain/usecases/eagle_rides_auth_is_signed_in_usecase.dart';
import 'package:get_it/get_it.dart';

import 'data/core/api_client.dart';
import 'data/datasource/user_current_location_data_source.dart';
import 'data/datasource/user_current_location_data_source_impl.dart';
import 'data/repositories/user_current_location_repository_impl.dart';
import 'domain/repositories/user_current_location_repository.dart';
import 'domain/usecases/get_user_current_location_usecase.dart';
import 'package:http/http.dart' as http;
import 'presentation/controller/auth/auth_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Client>(() => Client());

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  //network getx
  sl.registerFactory<NetWorkStatusChecker>(
    () => NetWorkStatusChecker(),
  );

  // feature:- current location
  //getx
  sl.registerFactory<HomeController>(() => HomeController(
      getUserCurrentLocationUsecase: sl.call(),
      getUserCurrentAddressUsecase: sl.call()));

  //current location Usecase

  sl.registerLazySingleton<GetUserCurrentLocationUsecase>(
    () => GetUserCurrentLocationUsecase(
      userCurrentLocationRepository: sl.call(),
    ),
  );

  sl.registerLazySingleton<GetUserCurrentAddressUsecase>(
    () => GetUserCurrentAddressUsecase(
      userCurrentLocationRepository: sl.call(),
    ),
  );

  // current location repository
  sl.registerLazySingleton<UserCurrentLocationRepository>(() =>
      UserCurrentLocationRepositoryImpl(
          userCurrentLocationDataSource: sl.call()));

  // current location datasource

  sl.registerLazySingleton<UserCurrentLocationDataSource>(
      () => UserCurrentLocationDataSourceImpl());

// auth feature

// getx

  sl.registerFactory<AuthController>(
    () => AuthController(
      eagleRidesAuthIsSignInUseCase: sl.call(),
      eagleRidesLoginUserUseCase: sl.call(),
      eagleRidesAuthCheckUserUseCase: sl.call(),
      // eagleRidesAuthGetUserUidUseCase: sl.call(),
      // uberAuthOtpVerificationUseCase: sl.call(),
      // uberAuthCheckUserStatusUseCase: sl.call(),
      // uberAuthGetUserUidUseCase: sl.call(),
      // uberProfileUpdateRiderUsecase: sl.call(),
      // uberAddProfileImgUseCase: sl.call(),
    ),
  );

  // usecase
  sl.registerLazySingleton<EagleRidesAuthIsSignInUseCase>(
    () => EagleRidesAuthIsSignInUseCase(
      eagleRidesAuthRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<EagleRidesLoginUserUseCase>(
    () => EagleRidesLoginUserUseCase(
      eagleRidesAuthRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<EagleRidesAuthCheckUserUseCase>(
    () => EagleRidesAuthCheckUserUseCase(
      eagleRidesAuthRepository: sl.call(),
    ),
  );

  //repository
  sl.registerLazySingleton<EagleRidesAuthRepository>(
      () => EagleRidesAuthRepositoryImpl(eagleRidesAuthDataSource: sl.call()));

  //datasource
  sl.registerLazySingleton<EagleRidesAuthDataSource>(
    () => EagleRidesAuthDataSourceImpl(
      sl(),
    ),
  );

  // map feature
  // getx
  // sl.registerFactory(() => RideMapCon)
  sl.registerFactory<RideController>(
    () => RideController(
      mapPredictionUsecase: sl.call(),
      rideMapDirectionUsecase: sl.call(),
      // uberMapGetDriversUsecase: sl.call(),
      getRentalChargesUseCase: sl.call(),
      generateTripUseCase: sl.call(),
      getVehicleDetailsUseCase: sl.call(),
      cancelTripUseCase: sl.call(),
      // uberAuthGetUserUidUseCase: sl.call()
    ),
  );
  sl.registerFactory<LiveTrackingController>(() => LiveTrackingController(
      rideMapDirectionUsecase: sl.call(), tripPaymentUseCase: sl.call()));

  // usecase
  sl.registerLazySingleton<MapPredictionUsecase>(
    () => MapPredictionUsecase(
      rideMapRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<RideMapDirectionUsecase>(
    () => RideMapDirectionUsecase(
      rideMapRepository: sl.call(),
    ),
  );
  // sl.registerLazySingleton<GetDriverUseCase>(
  //   () => GetDriverUseCase(
  //     rideMapRepository: sl.call(),
  //   ),
  // );
  sl.registerLazySingleton<GetRentalChargesUseCase>(
    () => GetRentalChargesUseCase(
      rideMapRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<GenerateTripUseCase>(
    () => GenerateTripUseCase(
      rideMapRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<GetVehicleDetailsUseCase>(
    () => GetVehicleDetailsUseCase(
      rideMapRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<CancelTripUseCase>(
    () => CancelTripUseCase(
      rideMapRepository: sl.call(),
    ),
  );
  sl.registerLazySingleton<TripPaymentUseCase>(
    () => TripPaymentUseCase(
      rideMapRepository: sl.call(),
    ),
  );
  // repository
  sl.registerLazySingleton<RideMapRepository>(
    () => RideMapRepositoryImpl(
      rideMapDataSource: sl.call(),
    ),
  );

  //datasource
  sl.registerLazySingleton<RideMapDataSource>(
    () => RideMapDataSourceImpl(
      client: sl.call(),
    ),
  );
  // sl.registerLazySingleton(() => http.Client());
}
