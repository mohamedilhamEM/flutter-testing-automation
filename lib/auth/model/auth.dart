import 'package:testingapp/utils/utils.dart';

class RegisterRequestModel {
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceType,
    this.devicePushToken,
  });
  String email;
  String password;
  String deviceId;
  String deviceType;
  String? devicePushToken;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'device_id': deviceId,
      'device_type': deviceType,
      'device_push_token': devicePushToken,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toJson()..removeWhere((key, value) => value == null));
  }

  @override
  String toString() {
    return 'RegisterRequestModel(email: $email, password: $password, deviceId: $deviceId, deviceType: $deviceType)';
  }
}

class LogInRequestModel {
  LogInRequestModel({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceType,
    this.devicePushToken,
  });
  String email;
  String password;
  String deviceId;
  String deviceType;
  String? devicePushToken;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'device_id': deviceId,
      'device_type': deviceType,
      'device_push_token': devicePushToken,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toJson()..removeWhere((key, value) => value == null));
  }

  @override
  String toString() {
    return 'LogInRequestModel(email: $email, password: $password, deviceId: $deviceId, deviceType: $deviceType)';
  }
}
