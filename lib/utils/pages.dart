import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';

enum Pages {
  splash,

  intro,
  signIn,
  signUp,
  verify,
  forgotPassword,
  completeAccount,
  tutorials,

  home,
  chat,
  explore,
  more,
  settings,
  profile,
}

extension PagesExtension on Pages {
  String toPath({bool isSubRoute = false, String? pathParam, String? pathPrefix}) {
    var path = ReCase(name.toLowerCase()).camelCase;
    if (pathPrefix != null && pathPrefix.isNotEmpty) {
      final prefix = pathPrefix.startsWith('/') ? pathPrefix : '/$pathPrefix';
      path = '$prefix/$path';
    } else {
      path = '/$path';
    }
    if (pathParam != null && pathParam.isNotEmpty) {
      final param = pathParam.startsWith(':') ? pathParam : ':$pathParam';
      path = '$path/$param';
    }
    if (isSubRoute) {
      path = path.replaceFirst('/', '');
    }
    return path;
  }

  String toPathName() {
    return ReCase(name.toLowerCase()).constantCase;
  }

  void go(BuildContext context, {Map<String, String> params = const <String, String>{}, Map<String, dynamic> queryParams = const <String, dynamic>{}, Object? extra}) {
    GoRouter.of(context).goNamed(toPathName(), pathParameters: params, queryParameters: queryParams, extra: extra);
  }

  Future<T?> push<T extends Object?>(
    BuildContext context, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    return GoRouter.of(context).pushNamed<T>(toPathName(), pathParameters: params, queryParameters: queryParams, extra: extra);
  }
}
