import 'package:grub_go/model/mexican_model.dart';

List<MexicanModel> getMexican() {
  List<MexicanModel> mexican = [];
  MexicanModel mexicanModel = new MexicanModel();

  mexicanModel.name = "Churro";
  mexicanModel.image = "images/mexican1.png";
  mexicanModel.price = "50";
  mexican.add(mexicanModel);
  mexicanModel = new MexicanModel();

  mexicanModel.name = "Tamale";
  mexicanModel.image = "images/mexican2.png";
  mexicanModel.price = "40";
  mexican.add(mexicanModel);
  mexicanModel = new MexicanModel();

  mexicanModel.name = "Tamale";
  mexicanModel.image = "images/mexican2.png";
  mexicanModel.price = "40";
  mexican.add(mexicanModel);
  mexicanModel = new MexicanModel();

  mexicanModel.name = "Tamale";
  mexicanModel.image = "images/mexican2.png";
  mexicanModel.price = "40";
  mexican.add(mexicanModel);
  mexicanModel = new MexicanModel();

  return mexican;
}
