import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'menus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '점심 정하기',
      home: roulette(title: 'Lunch Roulette'),
    );
  }
}

class roulette extends StatefulWidget {
  String title = '';

  roulette({Key? key, required this.title}) : super(key: key);

  @override
  _rouletteState createState() => _rouletteState();
}

class _rouletteState extends State<roulette> with TickerProviderStateMixin{

  late RouletteController _controller;
  CarouselController buttonCarouselController = CarouselController();

  final TextEditingController _menu1 = TextEditingController(text: '');
  final TextEditingController _menu2 = TextEditingController(text: '');
  final TextEditingController _menu3 = TextEditingController(text: '');
  final TextEditingController _menu4 = TextEditingController(text: '');
  final TextEditingController _menu5 = TextEditingController(text: '');
  final TextEditingController _menu6 = TextEditingController(text: '');
  final TextEditingController _menu7 = TextEditingController(text: '');
  final TextEditingController _menu8 = TextEditingController(text: '');
  final TextEditingController _menu9 = TextEditingController(text: '');

  late final textControllers;

  bool _clockwise = true;

  int totalmenu = 2;

  int _currentIndex = 0;


  final colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
    Colors.orange.withAlpha(30),
    Colors.white38,
    Colors.blueGrey,
  ];

  final menus = [
    'test',
  ];

  final styles = <TextStyle> [
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
    TextStyle(fontSize: 20, color: Colors.black),
  ];

  @override
  void initState() {

    textControllers = [
      _menu1,
      _menu2,
      _menu3,
      _menu4,
      _menu5,
      _menu6,
      _menu7,
      _menu8,
      _menu9,
    ];

    final group = RouletteGroup.uniform(
        menus.length,
        textBuilder: menus.elementAt,
        colorBuilder: colors.elementAt,
        textStyleBuilder: styles.elementAt

    );
    _controller = RouletteController(group: group, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(() {
      _controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;

    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      body:
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [

              //오늘의 추천 메뉴
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width,
                  height: 100,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('오늘의 추천 메뉴는 ?? 추천 버튼을 누르세요!'),

                          InkWell(
                            onTap: () {
                              Rolling();
                            },
                            child: Container(
                                width: 60,
                                height: 30,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(10)

                                ),
                                child: Text('추천!!')
                            ),
                          ),

                        ],

                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                              height: 40.0,
                              aspectRatio: 16/9,
                              viewportFraction: 1.0,
                              initialPage: Random().nextInt(pickmenus.length),
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.vertical
                          ),
                          items: pickmenus.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: width,
                                  color: Colors.blueGrey,
                                  alignment: Alignment.center,
                                  child: Text(i),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  )

              ),


              Container(
                margin: EdgeInsets.only(top: 20),
                width: width,
                alignment: Alignment.center,
                child: Text('메뉴 후보지 목록', style: TextStyle(fontSize: 20),),
              ),

              Container(
                width: width,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)
                ),

                child:
                Text(MenuLists(), style: TextStyle(wordSpacing: 1),),
              ),


              //룰렛
              Container(
                width: width,
                height: 700+MediaQuery.of(context).viewInsets.bottom,
                color: Colors.white,

                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: width,
                        alignment: Alignment.center,
                        child: Text('룰렛!!!', style: TextStyle(fontSize: 20),),
                      ),

                      Container(
                        width: width,
                        // padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: inputMenuList(totalmenu),
                        ),
                      ),
                      Container(
                        width: width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if(totalmenu <9) {
                                  totalmenu += 1;
                                  setState(() {

                                  });
                                }
                              },
                              child: Container(
                                width: 150,
                                height: 30,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text('추가'),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                if(totalmenu > 2) {
                                  totalmenu -= 1;
                                }
                                setState(() {

                                });
                              },
                              child: Container(
                                width: 150,
                                height: 30,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('빼기'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                          onTap: () {
                            MakeRoulette();
                          },
                          child: Container(
                            width: 200,
                            height: 30,
                            margin: EdgeInsets.symmetric(vertical : 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('룰렛 돌리기'),
                          )
                      ),



                      Text('오늘은 ?'),

                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            width: 260,
                            height: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Roulette(
                                controller: _controller,
                                style: const RouletteStyle(
                                    dividerThickness: 4,
                                    textLayoutBias: .8,
                                    centerStickerColor: Color(0xFF45A3FA)
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 50,
                            ), top: -10,
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                // decoration: BoxDecoration(
                //   color: Colors.pink.withAlpha(50)
                // ),
              ),



            ],
          )


        )


        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _controller.rollTo(
        //     Random().nextInt(totalmenu),
        //     clockwise: _clockwise,
        //     offset: Random().nextDouble()
        //   ),
        //   child: const Icon(Icons.refresh_rounded),
        // ),
      );
  }

  List<Widget> inputMenuList(int total) {

    late Widget menus;
    List<Widget> result = [];
    for(int i = 0; i < total; i++) {
      menus = menuTextfield(i);
      result.add(menus);
    }

    return result;
  }

  Widget menuTextfield(num) {

    return Container(
      width: 300,
      height: 40,
      child: TextField(
        controller: textControllers[num],
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          labelText: '메뉴',
        ),
      )
    );

  }

  void MakeRoulette() {

    List<String> Newmenus = [];
    for(int i = 0; i < totalmenu; i++) {
      Newmenus.add(textControllers[i].text);
    }

    _controller = RouletteController(
        group: RouletteGroup.uniform(
            totalmenu,
            textBuilder: Newmenus.elementAt,
            colorBuilder: colors.elementAt,
            textStyleBuilder: styles.elementAt

        ), vsync: this
      );

    setState(() {
      _controller.rollTo(
          Random().nextInt(totalmenu),
          clockwise: _clockwise,
          offset: Random().nextDouble()
      );
      //
      // debugPrint(Random().nextInt(totalmenu).toString());
      // debugPrint(totalmenu.toString());
    });

  }

  void Rolling() {
    buttonCarouselController.animateToPage(
      Random().nextInt(pickmenus.length),
      duration: Duration(milliseconds: 800), curve: Curves.fastLinearToSlowEaseIn
    );
  }

  String MenuLists() {

    var menustext = '';

    for(var i = 0; i < pickmenus.length; i ++) {
      menustext += pickmenus[i];
      menustext += ', ';
    }

    return menustext;

  }
}

