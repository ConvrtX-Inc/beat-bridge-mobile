///Model for Subscription
class SubscriptionModel {
  ///Constructor
  SubscriptionModel(
      {this.id = '',
      this.price = '',
      this.value = 0,
      this.isSelected = false,
      this.code = ''});

  ///Initialization for id
  String id;

  ///Initialization for price
  String price;

  ///Initialization for value
  double value;

  ///Initialization for isSelected
  bool isSelected;

  ///Initialization for code
  String code;
}
