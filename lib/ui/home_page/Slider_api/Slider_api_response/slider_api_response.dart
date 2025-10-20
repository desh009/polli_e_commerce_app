class SliderItem {
  final int id;
  final String title;
  final String bigTitle;
  final String btnTitle;
  final String mobileImg;  // আমরা শুধু mobile_img ব্যবহার করব
  final String desktopImg;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SliderItem({
    required this.id,
    required this.title,
    required this.bigTitle,
    required this.btnTitle,
    required this.mobileImg,
    required this.desktopImg,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id'],
      title: json['title'],
      bigTitle: json['big_title'],
      btnTitle: json['btn_title'],
      mobileImg: json['mobile_img'], // শুধু mobile_img দেখাবে
      desktopImg: json['desktop_img'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
