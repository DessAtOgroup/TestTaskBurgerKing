import 'package:flutter/cupertino.dart';

class Category {
  String name;
  Category(this.name);
}

class Dish {
  Category? category;
  String name;
  double price;
  double lastPrice;
  late Image picture;

  Dish(
      {@required this.category,
      this.name = "",
      this.price = 0,
      this.lastPrice = 0,
      Image? picture}) {
    if (category == null) {
      category = catList[0];
    }
    ;
    (picture == null) ? picture = Image.asset("") : picture = picture;
  }
}

final List<Category> catList = [
  Category("Популярные блюда"),
  Category("uhbkm"),
  Category("Комбо"),
  Category("Креветки"),
  Category("Гриль")
];

final List<Image> picFromAssets = [
  Image.asset("assets/images/1.jpg"),
  Image.asset("assets/images/2.png"),
  Image.asset("assets/images/3.png"),
  Image.asset("assets/images/4.png"),
  Image.asset("assets/images/5.png")
];

final List<String> pathsToImages = [
  "assets/images/1.jpg",
  "assets/images/2.png",
  "assets/images/3.png",
  "assets/images/4.png",
  "assets/images/5.png"
];

List<Dish> dishTable = [
  Dish(
      name: "Комбо с Воппером Дж.",
      price: 189,
      category: catList[0],
      picture: picFromAssets[0]),
  Dish(
      name: "Воппер с сыром",
      price: 249,
      lastPrice: 274.8,
      category: catList[0],
      picture: picFromAssets[1]),
  Dish(
      name: "Комбо на двоих с чизбургером",
      price: 399,
      lastPrice: 403.5,
      category: catList[0],
      picture: picFromAssets[2]),
  Dish(
      name: "Кинг наггетс (станд).",
      price: 499,
      lastPrice: 503.8,
      category: catList[0],
      picture: picFromAssets[3]),
  Dish(
      name: "КККК-комбо.",
      price: 499,
      lastPrice: 503.8,
      category: catList.firstWhere((element) => element.name == "Комбо"),
      picture: picFromAssets[4]),
];
