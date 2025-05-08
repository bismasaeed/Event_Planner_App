class VendorModel {
  final String category;
  final String name;
  final String contact;
  final String price;
  final String quantity;
  final String imageUrl;
  final String email;

  VendorModel({
    required this.category,
    required this.name,
    required this.contact,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'name': name,
      'contact': contact,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'email': email,
      'createdAt': DateTime.now(),
    };
  }
}
