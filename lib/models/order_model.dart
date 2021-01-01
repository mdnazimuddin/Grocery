class OrderModel {
  int id;
  String company;
  String totalAmount;
  String orderNumber;
  DateTime orderDate;
  String status;

  OrderModel({
    this.id,
    this.company,
    this.totalAmount,
    this.orderNumber,
    this.orderDate,
    this.status,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    totalAmount = json['total_amount'];
    orderNumber = json['order_number'];
    orderDate = DateTime.parse(json['order_date']);
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = id;
    data['company'] = company;
    data['total_amount'] = totalAmount;
    data['order_number'] = orderNumber;
    data['order_date'] = orderDate;
    data['status'] = status;

    return data;
  }
}
