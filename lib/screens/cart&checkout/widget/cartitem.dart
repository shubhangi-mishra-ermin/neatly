class CartItem {
  final String imageUrl;
  final String id;
  final String title;
  final String weight;
  final String pieces;
  final String deliveryTime;
  final double count;
  final double price;

  CartItem({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.weight,
    required this.pieces,
    required this.deliveryTime,
    required this.price,
    required this.count,
    
  });

  @override
  String toString() {
    return 'CartItem(id $id,title: $title, weight: $weight, deliveryTime: $deliveryTime, price: $price)';
  }
}
