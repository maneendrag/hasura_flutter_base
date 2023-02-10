// import 'package:efc_nc/_services/util_service.dart';
// import 'package:hasura_connect/hasura_connect.dart' hide Response;
// import 'package:dio/dio.dart';
//
// import '../_app/app.locator.dart';
// import 'connectivity_service.dart';
//
// class HttpService {
//
//   ConnectivityService _connection = locator<ConnectivityService>();
//   UtilsService _utils = locator<UtilsService>();
//   HasuraConnect _hasuraConnect = HasuraConnect("https://efc-nc.hasura.app/v1/graphql",
//       headers: {
//     'x-hasura-admin-secret':"JaI0zOWISmhLSSD7ya6gL1CJhpCK1Ceav1qZgugTFBFlABV93jyIE5w4Km8b0Jc7"
//   });
//
//   Future query(document, {variables, showLoading = true}) async {
//     if (!await _connection.checkConnection()) return null;
//     var response;
//     if (showLoading) _utils.showLoadingDialog();
//     bool sts = await _connection.checkConnection();
//     if (!sts) return null;
//     try {
//       response = (await _hasuraConnect.query(document,
//           variables: variables ?? {}))['data'];
//     } catch (e, s) {
//       print("$e , $s");
//       print("hasura error $e");
//       showHasuraError(e);
//     }
//     if (showLoading) _utils.closeLoadingDialog();
//     return response;
//   }
//
//
//
//   // Future mutation(document, variables, {showLoading = true}) async {
//   //   var response;
//   //   if (showLoading) _utils.showLoadingDialog();
//   //   bool sts = await _connection.checkConnection();
//   //   if (!sts) return null;
//   //   try {
//   //     response =
//   //     await _hasuraConnect.mutation(document, variables: variables ?? {});
//   //     response = response['data'];
//   //   } catch (e, s) {
//   //     print("$e , $s");
//   //     showHasuraError(e);
//   //   }
//   //   if (showLoading) _utils.closeLoadingDialog();
//   //   return response;
//   // }
//
//   showHasuraError(e) {
//     if (e.message.toString().contains("http")) {
//       _utils.showErrorSnackBar(
//           msg:
//           "We regret the inconvience, something is wrong at our end. please try again after sometime.",
//           title: "Server Error");
//     } else if (e.message.toString().contains("SocketException")) {
//       _utils.showErrorSnackBar(
//           msg:
//           'Seems to be slow internet connection, Please connect to a different source for better experience',
//           title: "Slow Internet");
//     } else
//       _utils.showToast(e.message ?? "Server error");
//   }
//
//   // Future<Snapshot<dynamic>> subscription(document,
//   //     {variables, showLoading = true}) async {
//   //   if (!await _connection.checkConnection()) return null;
//   //   try {
//   //     return await _hasuraConnect.subscription(document,
//   //         variables: variables ?? {});
//   //   } catch (e, s) {
//   //     print("$e , $s");
//   //   }
//   //   return null;
//   // }
//
//
//   dispose() {
//     _hasuraConnect.disconnect();
//   }
// }


import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:efc_nc/_app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

import '../_services/connectivity_service.dart';


class HasuraFailure {
  String message;
  Object? error;
  HasuraFailure({required this.message, this.error});
}

class HttpService {
  HasuraConnect get _hasuraConnect => _createHasuraClient();
  final ConnectivityService _connection = locator<ConnectivityService>();
  HasuraConnect _createHasuraClient() {
    return HasuraConnect(
      'https://efc-nc.hasura.app/v1/graphql',
      interceptors: [HasuraJwtTokenInterceptor()],
    );
  }

  dispose() {
    _hasuraConnect.dispose();
  }

  Future query(document, {variables, showLoading = true}) async {
    if (!await _connection.checkConnection()) {
      print("no internet connection");

      return null;
    }
    var response;

    // if (showLoading) _utils.showLoadingDialog();
    bool sts = await _connection.checkConnection();
    if (!sts) return null;
    try {
      response = (await _hasuraConnect.query(document,
          variables: variables ?? {}))['data'];
    } on SocketException {
      if (showLoading) CircularProgressIndicator(color: Colors.red);

      print("Socket exception error");
    } catch (e, s) {
      print("Error ======> $e , $s");
      // print("Iternet Error ======> ${e.}");

      // if (showLoading) _utils.closeLoadingDialog();
      // showHasuraError(e);
    }
    // if (showLoading) _utils.closeLoadingDialog();
    return response;
  }


// Future<HasuraConnect> hC() async {
  //   return HasuraConnect(
  //     'https://hasurav2.pickandbuy.store/v1/graphql',
  //     interceptors: [HasuraJwtTokenInterceptor()],
  //   );
  // }
  //
  // Future<Either<dynamic, HasuraFailure>> query(
  //     document, {
  //       Map<String, dynamic> variables = const {},
  //     }) async {
  //   try {
  //     if (await _connection.status == ConnectivityResult.none) {
  //       return Right(HasuraFailure(message: "No internet"));
  //     }
  //     final dynamic queryResponseData =
  //     await _hasuraConnect.query(document!, variables: variables);
  //     return Left(queryResponseData['data']);
  //   } on HasuraRequestError catch (error) {
  //     print('ERROR => Invalid Query => ${error.message}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   } on ConnectionError catch (error) {
  //     print('ERROR => Connection Failed => ${error.message}}');
  //     return Right(HasuraFailure(message: error.message, error: error));
  //   } on InvalidRequestError catch (error) {
  //     print('ERROR => Invalid Request => $error}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   } on InterceptorError catch (error) {
  //     print('ERROR => Interceptor Error => $error}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   } on DatasourceError catch (error) {
  //     print('ERROR => DataSource Error => $error}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   } catch (error) {
  //     print('ERROR => Unknown Error => $error}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   }
  // }

  // Future<Either<Snapshot, dynamic>> subscription(
  //     document, {
  //       Map<String, dynamic> variables = const {},
  //     }) async {
  //   try {
  //     if (await _connection.status == ConnectivityResult.none) {
  //       return Right(HasuraFailure(message: "No internet"));
  //     }
  //     return Left(
  //         await _hasuraConnect.subscription(document!, variables: variables));
  //   } on HasuraRequestError catch (error) {
  //     print('ERROR => Invalid Query => ${error.message}');
  //     return const Right(null);
  //   } on ConnectionError catch (error) {
  //     print('ERROR => Connection Failed => $error}');
  //     return const Right(null);
  //   } on InvalidRequestError catch (error) {
  //     print('ERROR => Invalid Request => $error}');
  //     return const Right(null);
  //   } on InterceptorError catch (error) {
  //     print('ERROR => Interceptor Error => $error}');
  //     return const Right(null);
  //   } on DatasourceError catch (error) {
  //     print('ERROR => DataSource Error => $error}');
  //     return const Right(null);
  //   } on HasuraError catch (error) {
  //     print('ERROR => Unknown Error => $error}');
  //     return const Right(null);
  //   } catch (error) {
  //     print('ERROR => Unknown Error => $error}');
  //     return const Right(null);
  //   }
  // }
  //
  // Future<Either<dynamic, HasuraFailure>> mutation(String document,
  //     {Map<String, dynamic> variables = const {},
  //       bool showLoading = false}) async {
  //   try {
  //     if (await _connection.status == ConnectivityResult.none) {
  //       return Right(HasuraFailure(message: "No interner"));
  //     }
  //     _hasuraConnect.isConnected;
  //     final dynamic mutationResponseData =
  //     await _hasuraConnect.mutation(document, variables: variables);
  //     return Left(mutationResponseData['data']);
  //   } on HasuraRequestError catch (error) {
  //     print('ERROR => Invalid Query => ${error.message}');
  //     return Right(HasuraFailure(message: "Invalid Query"));
  //   } on ConnectionError catch (error) {
  //     print('ERROR => Connection Failed => ${error.message}}');
  //     return Right(HasuraFailure(message: error.message, error: error));
  //   } on InvalidRequestError catch (error) {
  //     print('ERROR => Invalid Request => $error}');
  //     return Right(HasuraFailure(message: "Invalid Request"));
  //   } on InterceptorError catch (error) {
  //     print('ERROR => Interceptor Error => $error}');
  //     return Right(HasuraFailure(message: "Intercepter Error"));
  //   } on DatasourceError catch (error) {
  //     print('ERROR => DataSource Error => $error}');
  //     return Right(HasuraFailure(message: "Data error"));
  //   } catch (error) {
  //     print('ERROR => Unknown Error => $error}');
  //     return Right(HasuraFailure(message: "Somethings wrong"));
  //   }
  // }
}

class HasuraJwtTokenInterceptor extends Interceptor {
  @override
  // ignore: missing_return
  Future<void> onConnected(HasuraConnect connect) async {}

  @override
  // ignore: missing_return
  Future<void> onDisconnected() async {}

  @override
  // ignore: avoid_renaming_method_parameters
  Future<HasuraError> onError(HasuraError error, HasuraConnect hasuraConnect) async {
    return error;
  }

  @override
  Future<Request> onRequest(Request request, HasuraConnect hasuraConnect) async {
    final String userAccessHasuraJwtToken = "JaI0zOWISmhLSSD7ya6gL1CJhpCK1Ceav1qZgugTFBFlABV93jyIE5w4Km8b0Jc7";

    request.headers['content-type'] = 'application/json';
    request.headers['x-hasura-admin-secret'] = 'JaI0zOWISmhLSSD7ya6gL1CJhpCK1Ceav1qZgugTFBFlABV93jyIE5w4Km8b0Jc7';
   request.headers['Authorization'] = '$userAccessHasuraJwtToken';
    // final String userAccessHasuraJwtToken = _appLevelModel.accessToken;
    // if (userAccessHasuraJwtToken != null) {
    //   request.headers['Authorization'] = 'Bearer $userAccessHasuraJwtToken';
    // } else {
    //   request.headers['x-hasura-admin-secret'] = 'Ast@2020';
    // }
    return request;
  }

  @override
  Future<Response> onResponse(Response data, HasuraConnect hasuraConnect) async {
    return data;
  }

  @override
  Future<void> onSubscription(
      Request request, Snapshot<dynamic> snapshot) async {}

  @override
  Future<void> onTryAgain(HasuraConnect connect) async {}
}
