class HomeResponse {
  List<Users>? users;

  HomeResponse({this.users});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? userName;
  String? role;
  String? apartmentNo;
  String? officeStatus;

  Users({this.userName, this.role, this.apartmentNo, this.officeStatus});

  Users.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    role = json['role'];
    apartmentNo = json['apartment_no'];
    officeStatus = json['office_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['role'] = this.role;
    data['apartment_no'] = this.apartmentNo;
    data['office_status'] = this.officeStatus;
    return data;
  }
}