import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled/data/menu_data.dart';
import 'package:untitled/presentation/bloc.dart';

///настройки конкретного экрана
class ScreenSettings {
  double abPreferredH =
      30; //высота аппбара, будет рассчитана при билде. От нее рассчитывается высота меню и радиусы кнопок.
  double abPreferredW = 390; // ширина аппбара, при билде пересчитается.
  double screenH = 500; //Это высота экрана, при билде рассчитаем реальную
  double picW = 180; //ширина плитки и картинки в ней
  double picH = 180; //картинки все квадратные.
  double paddingCnst =
      10; // типовой паддинг для всех элементов. Пересчитается при билде от высоты аппбара.

  ScreenSettings(
      {this.abPreferredH = 30,
      this.abPreferredW = 390,
      this.screenH = 500,
      this.picW = 180,
      this.picH = 180,
      this.paddingCnst = 10}) {
    print('in constructor');
    reCalc();
  }

  void reCalc() {
    if (abPreferredH.isInfinite) {
      abPreferredH = 30;
    }
    ;
    if (abPreferredW.isInfinite) {
      abPreferredW = 390;
    }
    ;
    if (screenH.isInfinite) {
      screenH = 500;
    }
    ;
    if (picW.isInfinite) {
      picW = 180;
    }
    ;
    if (picH.isInfinite) {
      picH = 180;
    }
    ;
    if (paddingCnst.isInfinite) {
      paddingCnst = 10;
    }
    ;

    paddingCnst = abPreferredH /
        3; //ширина паддинга должна быть примерно треть от высоты аппбара.
    picW = (abPreferredW - paddingCnst * 3) /
        2; // в экран входит 2 картинки и 3 паддинга (по краям и между колонками)
    picH = picW; //картинки квадратные
  }
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  _firstpageState createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  Update _update = Update();
  ScreenSettings _screenSettings = ScreenSettings();

  @override
  void dispose() {
    _update.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _update.outputEventStream,
      builder: (context, snapshot) {
        _screenSettings.screenH = MediaQuery.of(context).size.height;
        _screenSettings.abPreferredW = MediaQuery.of(context).size.width;

        return _getbody(
            ss: snapshot.data); //в снапшоте всегда текущая категория
      },
      initialData: catList[0],
    );
  }

  Widget _getbody({ss}) {
    PreferredSizeWidget myAppBar = AppBar(
      title: Row(
          children: [Text('Бургер кинг')],
          mainAxisAlignment: MainAxisAlignment.center),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: "не нажимать",
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('некуда отступать. позади москва')));
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: 'Информация',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'некоторые кнопки нужны просто для того, чтобы на них нажимали.')));
          },
        )
      ],
    );
    _screenSettings.abPreferredH = myAppBar.preferredSize.height;
    _screenSettings.reCalc();

    return Scaffold(
        appBar: myAppBar,
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Column(children: [
            categoriesAsGrid(ss),

            SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: _screenSettings.paddingCnst),
                  child: GridView.count(
                      childAspectRatio: 0.7 /*todo wtf? при =1 оверфлоу */,
                      crossAxisCount: 2,
                      children: menuAsGrid(ss)),
                ),
                height: _screenSettings.screenH -
                    2 * _screenSettings.abPreferredH -
                    25) // todo сделать адекватнее. Сейчас: от высоты экрана убираем две высоты аппбара, и панель статуса андроида (да, 25, мэджик намбер) получаем остаток для боди скафолда
          ]),
        ));
  }

  ///формирует тело каталога - меню в смысле набор блюд
  List<Widget> menuAsGrid(dynamic catFilter) {
    List<Widget> rezult = [];

    for (int i = 0; i < dishTable.length; i++) {
      if (dishTable[i].category == catFilter && catList.contains(catFilter)) {
        if (_screenSettings.picW.isInfinite) {
          _screenSettings.reCalc();
        }
        ;
        Widget iW = GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${dishTable[i].name} отправлен в корзину')));
          },
          child: Container(
              child: Column(
            children: <Widget>[
              Container(
                  width: (_screenSettings.picW.isInfinite)
                      ? 180
                      : _screenSettings
                          .picW, //todo явная ошибка, не пойму почему
                  height: (_screenSettings.picH.isInfinite)
                      ? 180
                      : _screenSettings.picH,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage(pathsToImages[
                            i]), //todo тут пути переделать на что-нибудь похожее на правду.
                        fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(_screenSettings.abPreferredH / 4),
                        topRight:
                            Radius.circular(_screenSettings.abPreferredH / 4)),
                  )),
              //Padding(padding: EdgeInsets.only(top: abPreferredH / 4)),
              Container(
                width: _screenSettings.picW, //todo
                height: _screenSettings.picH / 2,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(_screenSettings.abPreferredH / 4),
                      bottomRight:
                          Radius.circular(_screenSettings.abPreferredH / 4)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(_screenSettings.paddingCnst),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Text(""),
                        Text(dishTable[i].name),
                        //Padding(padding: EdgeInsets.only(top: _screenSettings.paddingCnst)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  dishTable[i].price.toInt().toString() + " ₽"),
                              Text(
                                (dishTable[i].lastPrice.toInt() != 0)
                                    ? dishTable[i]
                                            .lastPrice
                                            .toInt()
                                            .toString() +
                                        " ₽"
                                    : "",
                                style: TextStyle(color: Colors.grey),
                              )
                            ]),
                      ]),
                ),
              )
            ],
          )),
        );

        rezult.add(iW);
      }
    }
    return rezult;
  }

  ///формирует верхнее меню категорий
  Widget categoriesAsGrid(dynamic catFilter) {
    PreferredSizeWidget ab = AppBar();
    _screenSettings.abPreferredH = ab.preferredSize.height;
    _screenSettings.reCalc();

    List<Widget> rezult = [];

    for (int i = 0; i < catList.length; i++) {
      bool isCurrent = catFilter == catList[i];
      rezult.add(GestureDetector(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(_screenSettings.abPreferredH /
                  4.5), //todo возможно есть выравнивание посередине, пока не нашел.
              child: Text(catList[i].name,
                  style: TextStyle(
                      color: (isCurrent) ? Colors.black : Colors.grey,
                      fontSize: _screenSettings.abPreferredH / 3)),
            ),
            color: (isCurrent) ? Colors.yellow : Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(_screenSettings.abPreferredH)),
          ),
          onTap: () {
            _update.inputEventSink.add(catList[i]);
          }));
    }

    return SizedBox(
        height: _screenSettings.abPreferredH,
        width: _screenSettings.abPreferredW,
        child: Padding(
          padding: EdgeInsets.only(
              left: _screenSettings.paddingCnst,
              right: _screenSettings.paddingCnst),
          child: ListView(scrollDirection: Axis.horizontal, children: rezult),
        ));
    ;
  }
}
