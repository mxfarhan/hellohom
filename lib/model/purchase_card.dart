import 'package:foodly/model/user.dart';

class PurchaseCard {
  dynamic id;
  String? nickName;
  String? recipient;
  String? surname;
  String? address;
  String? city;
  String? zipCode;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? productsId;
  String? paymentId;
  String? paymentMethod;
  String? startDate;
  String? expiredDate;
  String? status;
  dynamic price;
  dynamic usersId;
  String? cardCode;
  User? user;

  PurchaseCard(
      {this.id,
      this.nickName,
      this.recipient,
      this.surname,
      this.address,
      this.city,
      this.zipCode,
      this.phone,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.productsId,
      this.paymentId,
      this.paymentMethod,
      this.startDate,
      this.expiredDate,
      this.status,
      this.price,
      this.usersId,
      this.cardCode,
      this.user});

  PurchaseCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nick_name'];
    recipient = json['recipient'];
    surname = json['surname'];
    address = json['address'];
    city = json['city'];
    zipCode = json['zip_code'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productsId = json['products_id'];
    paymentId = json['payment_id'];
    paymentMethod = json['payment_method'];
    startDate = json['start_date'];
    expiredDate = json['expired_date'];
    status = json['status'];
    price = json['price'];
    usersId = json['users_id'];
    cardCode = json['card_code'];
    user = User(
      id: json['user']['id'],
      name: json['user']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick_name'] = this.nickName;
    // data['name'] = this.name;
    data['surname'] = this.surname;
    data['address'] = this.address;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['products_id'] = this.productsId;
    data['payment_id'] = this.paymentId;
    data['payment_method'] = this.paymentMethod;
    data['start_date'] = this.startDate;
    data['expired_date'] = this.expiredDate;
    data['status'] = this.status;
    data['price'] = this.price;
    data['users_id'] = this.usersId;
    data['card_code'] = this.cardCode;
    return data;
  }
}
