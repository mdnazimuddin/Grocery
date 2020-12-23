import 'dart:convert';

class PickupModel {
  int groceryId;
  bool selfPickup;
  bool onlineOrder;
  PickupModel({
    this.groceryId,
    this.selfPickup,
    this.onlineOrder,
  });
  PickupModel.fromJson(Map<String, dynamic> json) {
    this.groceryId = json['grocery_id'];
    this.selfPickup = json['self_pickup'];
    this.onlineOrder = json['online_order'];
  }
}
