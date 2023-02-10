class Failure {
  String? message;
  String? errorMessage;

  Failure({this.message, this.errorMessage});

  Failure.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorMessage = json['error_message'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = this.message;
    data['error_message'] = this.errorMessage;

    return data;
  }
}
