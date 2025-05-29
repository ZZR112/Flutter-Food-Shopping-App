import 'package:grub_go/model/buger_model.dart';

List<BugerModel> getBurger() {
  List<BugerModel> burger = [];
  BugerModel bugerModel = new BugerModel();

  bugerModel.name = "Cheese Buger";
  bugerModel.image = "images/burger1.png";
  bugerModel.price = "50";
  burger.add(bugerModel);
  bugerModel = new BugerModel();

  bugerModel.name = "Veggie Buger";
  bugerModel.image = "images/burger2.png";
  bugerModel.price = "80";
  burger.add(bugerModel);
  bugerModel = new BugerModel();

  bugerModel.name = "Veggie Buger";
  bugerModel.image = "images/burger2.png";
  bugerModel.price = "80";
  burger.add(bugerModel);
  bugerModel = new BugerModel();

  bugerModel.name = "Veggie Buger";
  bugerModel.image = "images/burger2.png";
  bugerModel.price = "80";
  burger.add(bugerModel);
  bugerModel = new BugerModel();

  return burger;
}
