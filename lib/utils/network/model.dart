abstract class ApiResponse {
  ApiResponse._fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = json['message'] as String;
    } else {
      message = 'Unknown error';
    }
  }

  String message = '';
  dynamic data;
  Paginator? paginator;
  bool get isSuccess => this is ApiSuccessResponse;
  bool get isFailure => this is ApiFailureResponse;
  bool get isPaginated => paginator != null;

  static ApiResponse fromJson(Map<String, dynamic> json) {
    if (json['result'] == null) {
      return ApiFailureResponse._fromJson({
        'result': false,
        'message': 'Unknown error',
      });
    }
    if (json['result'] == true) {
      return ApiSuccessResponse._fromJson(json);
    } else {
      return ApiFailureResponse._fromJson(json);
    }
  }

  static ApiResponse fromException(Exception e) {
    return ApiFailureResponse._fromJson({
      'result': false,
      'message': e.toString(),
    });
  }

  static ApiResponse fromError(String message) {
    return ApiFailureResponse._fromJson({
      'result': false,
      'message': message,
    });
  }
}

class ApiSuccessResponse extends ApiResponse {
  ApiSuccessResponse._fromJson(Map<String, dynamic> json) : super._fromJson(json) {
    if (json['payload'] != null) {
      data = json['payload'];
    }
    if (json['paginator'] != null) {
      paginator = Paginator.fromJson(json['paginator'] as Map<String, dynamic>);
    }
  }
}

class ApiFailureResponse extends ApiResponse {
  ApiFailureResponse._fromJson(super.json) : super._fromJson();
}

bool tryParseBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 1;
  }
  if (value is String) {
    return value == '1';
  }
  return defaultValue;
}

String tryParseString(dynamic value, {String defaultValue = ''}) {
  if (value is String) {
    return value;
  }
  if (value is int) {
    return value.toString();
  }
  if (value is bool) {
    return value.toString();
  }
  return defaultValue;
}

int tryParseInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }
  if (value is bool) {
    return value ? 1 : 0;
  }
  return defaultValue;
}

double tryParseDouble(dynamic value, {double defaultValue = 0}) {
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }
  if (value is bool) {
    return value ? 1 : 0;
  }
  return defaultValue;
}

class Paginator {
  Paginator({
    required this.currentPage,
    required this.perPage,
    required this.from,
    required this.to,
    required this.total,
    required this.lastPage,
    this.nextPageUrl,
  });

  factory Paginator.fromJson(Map<String, dynamic> json) {
    return Paginator(
      currentPage: tryParseInt(json['current_page']),
      perPage: tryParseInt(json['per_page']),
      from: tryParseInt(json['from']),
      to: tryParseInt(json['to']),
      total: tryParseInt(json['total']),
      lastPage: tryParseInt(json['last_page']),
      nextPageUrl: json['next_page_url'] as String?,
    );
  }

  int currentPage;
  int perPage;
  int from;
  int to;
  int total;
  int lastPage;
  String? nextPageUrl;

  bool get hasNextPage => nextPageUrl != null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['per_page'] = perPage;
    map['from'] = from;
    map['to'] = to;
    map['total'] = total;
    map['last_page'] = lastPage;
    map['next_page_url'] = nextPageUrl;
    return map;
  }

  @override
  String toString() {
    return 'Paginator(currentPage: $currentPage, perPage: $perPage, from: $from, to: $to, total: $total, lastPage: $lastPage, nextPageUrl: $nextPageUrl)';
  }
}
