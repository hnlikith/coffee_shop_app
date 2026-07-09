import 'package:get/get.dart';
import 'package:coffee_shop_app/data/models/coffee_model.dart';

/// GetX controller for cart / checkout state
class CartController extends GetxController {
  // Selected coffee for detail/checkout
  final Rx<CoffeeModel?> selectedCoffee = Rx<CoffeeModel?>(null);

  // Size selection: S, M, L
  final RxString selectedSize = 'M'.obs;

  // Quantity
  final RxInt quantity = 1.obs;

  // Delivery / Pickup toggle
  final RxBool isDelivery = true.obs;

  // Delivery fee
  final double deliveryFee = 1.00;

  /// Price multiplier based on selected size
  double get sizeMultiplier {
    switch (selectedSize.value) {
      case 'S':
        return 0.85;
      case 'L':
        return 1.25;
      case 'M':
      default:
        return 1.0;
    }
  }

  /// Unit price = base price × size multiplier
  double get unitPrice {
    if (selectedCoffee.value == null) return 0.0;
    return selectedCoffee.value!.price * sizeMultiplier;
  }

  /// Subtotal = unit price × quantity
  double get subtotal => unitPrice * quantity.value;

  /// Delivery cost (0 if pickup)
  double get shippingCost => isDelivery.value ? deliveryFee : 0.0;

  /// Total = subtotal + delivery fee
  double get totalPrice => subtotal + shippingCost;

  /// Select a coffee for detail/checkout
  void selectCoffee(CoffeeModel coffee) {
    selectedCoffee.value = coffee;
    selectedSize.value = 'M';
    quantity.value = 1;
  }

  /// Select size
  void selectSize(String size) {
    selectedSize.value = size;
  }

  /// Increment quantity
  void incrementQuantity() {
    if (quantity.value < 99) {
      quantity.value++;
    }
  }

  /// Decrement quantity
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  /// Toggle delivery / pickup
  void toggleDelivery(bool delivery) {
    isDelivery.value = delivery;
  }

  /// Reset cart state
  void reset() {
    selectedCoffee.value = null;
    selectedSize.value = 'M';
    quantity.value = 1;
    isDelivery.value = true;
  }
}
