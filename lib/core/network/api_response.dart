class ApiResponse<T> {
  final T? data;
  final bool status;
  final List<String>? errors;
  final String? message;

  ApiResponse({this.data, required this.status, this.errors, this.message});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      status: json['status'] ?? false,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'data': data != null ? toJsonT(data as T) : null,
      'status': status,
      'errors': errors,
      'message': message,
    };
  }
}
