import 'package:grub_go/model/chinese_model.dart';

List<ChineseMordel> getChinese() {
  List<ChineseMordel> chinese = [];
  ChineseMordel chineseModel = new ChineseMordel();

  chineseModel.name = "Noodle";
  chineseModel.image = "images/chinese1.png";
  chineseModel.price = "50";
  chinese.add(chineseModel);
  chineseModel = new ChineseMordel();

  chineseModel.name = "Noodle Soup";
  chineseModel.image = "images/chinese2.png";
  chineseModel.price = "60";
  chinese.add(chineseModel);
  chineseModel = new ChineseMordel();

  chineseModel.name = "Noodle Soup";
  chineseModel.image = "images/chinese2.png";
  chineseModel.price = "60";
  chinese.add(chineseModel);
  chineseModel = new ChineseMordel();

  chineseModel.name = "Noodle Soup";
  chineseModel.image = "images/chinese2.png";
  chineseModel.price = "60";
  chinese.add(chineseModel);
  chineseModel = new ChineseMordel();

  return chinese;
}
