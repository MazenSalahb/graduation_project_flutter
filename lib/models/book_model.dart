class BookModel {
  num? id;
  String? title;
  String? author;
  String? description;
  num? categoryId;
  String? status;
  String? availability;
  num? price;
  String? image;
  num? userId;
  String? createdAt;
  String? updatedAt;
  num? reviewsAvgRating;
  Category? category;
  User? user;

  BookModel(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.categoryId,
      this.status,
      this.availability,
      this.price,
      this.image,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.reviewsAvgRating,
      this.category,
      this.user});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    description = json['description'];
    categoryId = json['category_id'];
    status = json['status'];
    availability = json['availability'];
    price = json['price'];
    image = json['image'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewsAvgRating = json['reviews_avg_rating'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class Category {
  int? id;
  String? name;
  String? color;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.color, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class User {
  num? id;
  String? name;
  String? email;
  String? location;
  String? profilePicture;
  String? role;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.name,
      this.email,
      this.location,
      this.profilePicture,
      this.role,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    location = json['location'];
    profilePicture = json['profile_picture'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
