import 'medicine.dart';

class CartItem {
  final Medicine medicine;
  int quantity;

  CartItem({required this.medicine, this.quantity = 1});

  double get subtotal => medicine.price * quantity;

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {'medicine': medicine.toJson(), 'quantity': quantity};
  }

  // Factory constructor for creating CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      medicine: Medicine.fromJson(json['medicine']),
      quantity: json['quantity'] as int,
    );
  }
}
