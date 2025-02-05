import 'package:flutter/material.dart';
import 'package:on_my_way/features/cart/ui/widgets/orders_body_widget.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const Scaffold(body: OrdersBodyWidget());
  }
}
