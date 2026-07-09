import 'package:coffee_shop_app/data/models/coffee_model.dart';

/// Cart item model — wraps a coffee product with quantity and size
class CartItemModel {
  final String id;
  final CoffeeModel coffee;
  int quantity;
  String size;

  CartItemModel({
    required this.id,
    required this.coffee,
    this.quantity = 1,
    this.size = 'M',
  });

  /// Price multiplier based on selected size
  double get sizeMultiplier {
    switch (size) {
      case 'S':
        return 0.85;
      case 'L':
        return 1.25;
      case 'M':
      default:
        return 1.0;
    }
  }

  /// Computed unit price based on size
  double get unitPrice => coffee.price * sizeMultiplier;

  /// Computed total price (unit price × quantity)
  double get totalPrice => unitPrice * quantity;

  /// Create from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json, CoffeeModel coffee) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      coffee: coffee,
      quantity: json['quantity'] as int? ?? 1,
      size: json['size']?.toString() ?? 'M',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': coffee.id,
      'quantity': quantity,
      'size': size,
    };
  }

  /// Create a copy with optional overrides
  CartItemModel copyWith({
    String? id,
    CoffeeModel? coffee,
    int? quantity,
    String? size,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      coffee: coffee ?? this.coffee,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}
