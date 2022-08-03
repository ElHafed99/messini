import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class OrderStatusModel {
  OrderStatusModel({
    required this.title,
    required this.color,
    required this.icon,
    required this.id,
  });

  final String title;
  final Color color;
  final IconData icon;
  final int id;

  static final List<OrderStatusModel> orderStatus = [
    OrderStatusModel(
        id: -1,
        title: "canceled",
        color: Colors.red,
        icon: Ionicons.close_circle),
    OrderStatusModel(
        id: 0,
        title: "pending",
        color: Colors.orange,
        icon: Ionicons.pause_circle),
    OrderStatusModel(
        id: 1, title: "working", color: Colors.blue, icon: Ionicons.stopwatch),
    OrderStatusModel(
        id: 2,
        title: "delivered",
        color: Colors.green,
        icon: Ionicons.checkmark_circle),
  ];
}
