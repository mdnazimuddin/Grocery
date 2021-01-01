import 'dart:convert';

class PickupModel {
  String groceryId;
  bool selfPickup;
  bool onlineOrder;
  PickupModel({
    this.groceryId,
    this.selfPickup,
    this.onlineOrder,
  });
  PickupModel.fromJson(Map<String, dynamic> json) {
    this.groceryId = json['grocery_id'].toString();
    this.selfPickup = json['self_pickup'];
    this.onlineOrder = json['online_order'];
  }
}
