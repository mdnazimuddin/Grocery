class ShopTag {
  String id;
  String name;
  String slug;
  String des;
  ShopTag({
    this.id,
    this.name,
    this.slug,
    this.des,
  });
  ShopTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    des = json['des'];
  }
}
