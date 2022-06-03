
class Category {
  Category({
    required this.name,
    required this.image,
  });

  String name;
  String image;

  static Category fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        image: json["image"],
      );
}
