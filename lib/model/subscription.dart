import 'package:foodly/model/product.dart';

class Subscription {
  dynamic id;
  String? externalId;
  String? paymentChanel;
  dynamic price;
  String? status;
  dynamic usersId;
  String? email;
  dynamic productsId;
  String? paymentLink;
  String? createdAt;
  String? updatedAt;
  String? receiver;
  String? phone;
  String? address;
  String? notes;
  String? shipping;
  String? startDate;
  String? expiredDate;
  String? paymentMethod;
  dynamic paymentId;
  Product? product;

  Subscription(
      {this.id,
      this.externalId,
      this.paymentChanel,
      this.price,
      this.status,
      this.usersId,
      this.email,
      this.productsId,
      this.paymentLink,
      this.createdAt,
      this.updatedAt,
      this.receiver,
      this.phone,
      this.address,
      this.notes,
      this.shipping,
      this.startDate,
      this.expiredDate,
      this.paymentMethod,
      this.paymentId,
      this.product});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    externalId = json['external_id'];
    paymentChanel = json['payment_chanel'];
    price = json['price'];
    status = json['status'];
    usersId = json['users_id'];
    email = json['email'];
    productsId = json['products_id'];
    paymentLink = json['payment_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    receiver = json['receiver'];
    phone = json['phone'];
    address = json['address'];
    notes = json['notes'];
    shipping = json['shipping'];
    startDate = json['start_date'];
    expiredDate = json['expired_date'];
    paymentMethod = json['payment_method'];
    paymentId = json['payment_id'];
    paymentId = json['payment_id'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['external_id'] = this.externalId;
    data['payment_chanel'] = this.paymentChanel;
    data['price'] = this.price;
    data['status'] = this.status;
    data['users_id'] = this.usersId;
    data['email'] = this.email;
    data['products_id'] = this.productsId;
    data['payment_link'] = this.paymentLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['receiver'] = this.receiver;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['notes'] = this.notes;
    data['shipping'] = this.shipping;
    data['start_date'] = this.startDate;
    data['expired_date'] = this.expiredDate;
    data['payment_method'] = this.paymentMethod;
    data['payment_id'] = this.paymentId;
    return data;
  }
}
