class Product {
  dynamic id;
  String? uniqueId;
  String? name;
  String? category;
  String? image;
  dynamic price;
  dynamic visibility;
  String? createdAt;
  String? updatedAt;
  int? period;
  String? description;

  Product(
      {this.id,
      this.uniqueId,
      this.name,
      this.category,
      this.image,
      this.price,
      this.visibility,
      this.createdAt,
      this.updatedAt,
      this.period,
      this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    name = json['name'];
    category = json['category'];
    image = json['image'];
    price = json['price'];
    visibility = json['visibility'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    period = int.parse(json['period']);
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unique_id'] = this.uniqueId;
    data['name'] = this.name;
    data['category'] = this.category;
    data['image'] = this.image;
    data['price'] = this.price;
    data['visibility'] = this.visibility;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['period'] = this.period;
    data['description'] = this.description;
    return data;
  }
}
