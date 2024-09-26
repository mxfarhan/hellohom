class Member {
  int? id;
  String? staffsId;
  String? ownersId;
  Staff? staff;

  Member({this.id, this.staffsId, this.ownersId, this.staff});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffsId = json['staffs_id'];
    ownersId = json['owners_id'];
    staff = json['staff'] != null ? new Staff.fromJson(json['staff']) : null;
  }
}

class Staff {
  int? id;
  String? image;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? roles;
  String? phone;
  String? gender;
  String? dob;
  String? address;
  String? long;
  String? lat;
  String? cardId;
  String? accumulatedExpired;
  String? city;
  String? zipCode;
  String? ownershipId;
  Owner? owner;

  Staff(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.roles,
      this.phone,
      this.gender,
      this.dob,
      this.address,
      this.long,
      this.lat,
      this.cardId,
      this.accumulatedExpired,
      this.city,
      this.zipCode,
      this.ownershipId,
      this.owner});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    long = json['long'];
    lat = json['lat'];
    cardId = json['card_id'];
    accumulatedExpired = json['accumulated_expired'];
    city = json['city'];
    zipCode = json['zip_code'];
    ownershipId = json['ownership_id'];

    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['roles'] = this.roles;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['card_id'] = this.cardId;
    data['accumulated_expired'] = this.accumulatedExpired;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['ownership_id'] = this.ownershipId;

    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    return data;
  }
}

class Owner {
  int? id;
  String? image;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? roles;
  String? phone;
  String? address;
  String? city;
  String? zipCode;
  dynamic ownershipId;

  Owner(
      {this.id,
      this.image,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.roles,
      this.phone,
      this.address,
      this.city,
      this.zipCode,
      this.ownershipId});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roles = json['roles'];
    phone = json['phone'];
    address = json['address'];
    city = json['city'];
    zipCode = json['zip_code'];
    ownershipId = json['ownership_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['roles'] = this.roles;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['ownership_id'] = this.ownershipId;
    return data;
  }
}
