import 'package:flutter/material.dart';
import "dart:math";
import "package:et_mob/spreading_widget.dart";

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, RouteAware {
  HomePageState();
  double bRadius = 20.0;
  TextEditingController departureController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  ScrollController scrollController = ScrollController();
  double scrollPosition = 0;
  bool get isAtTop => scrollPosition == 0;
  GlobalKey listViewKey = GlobalKey();
  double leftSpace = 0;
  bool isScrollable = true;

  void scrollListener() {
    setState(() {
      scrollPosition = scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> circularButtonsList = [
      buildCircularButton(const AssetImage("assets/tours-and-activities.jpg"),
          "Tours and Activities"),
      const SizedBox(width: 50),
      buildCircularButton(
          const AssetImage("assets/duty-free.png"), "Duty Free"),
      const SizedBox(width: 50),
      buildCircularButton(
          const AssetImage("assets/flight-pass.png"), "Flight Pass"),
    ];
    List<Widget> fareCards = [
      buildFareCard("Dubai", 39656, "assets/dubai.png"),
      buildFareCard("Milan", 65599, "assets/milan.jpg"),
      buildFareCard("Paris", 32647, "assets/paris.jpg"),
    ];

    return MaterialApp(
        home: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                appBar: AppBar(
                    leading: const Icon(Icons.menu, color: Colors.white),
                    title: Image.asset("assets/ethiopian-logo.jpg"),
                    backgroundColor: Colors.green[700],
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.language, color: Colors.white),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.notifications,
                              color: Colors.white),
                          onPressed: () {})
                    ],
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(100.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 10),
                            child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Book a flight",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left),
                                  Text("Make your flight unforgettable!",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.left),
                                  SizedBox(height: 20.0),
                                ])))),
                body: Scaffold(
                  appBar: PreferredSize(
                      preferredSize: isAtTop
                          ? const Size.fromHeight(150)
                          : const Size.fromHeight(75),
                      child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(255, 235, 59, 1)),
                          clipBehavior: Clip.hardEdge,
                          child: buildBookField(isTop: isAtTop))),
                  body: Container(
                      color: Colors.white,
                      height: double.infinity,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView(
                        primary: false,
                        key: listViewKey,
                        controller: scrollController,
                        physics: !isScrollable
                            ? const NeverScrollableScrollPhysics()
                            : null,
                        children: [
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          SizedBox(
                              height: 70,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: Colors.amber),
                                  child: const Text("Search Flights",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.black)),
                                  onPressed: () {})),
                          const SizedBox(height: 20),
                          const Text("Join ShebaMiles",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          buildShebaMiles(),
                          const SizedBox(height: 20),
                          const Text("Best fares from Addis Ababa",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0)),
                          const SizedBox(height: 20),
                          Align(
                              alignment: Alignment.center,
                              child: Listener(
                                  onPointerDown: (details) {
                                    setState(() {
                                      isScrollable = false;
                                    });
                                  },
                                  onPointerUp: (details) {
                                    setState(() {
                                      isScrollable = true;
                                    });
                                  },
                                  child: SpreadingWidget(
                                      key: const Key('spreading widget'),
                                      spreadWidgetsCount: 3,
                                      spreadAngleBetweenConsecutiveWidgets:
                                          -pi / 32,
                                      centerOfSpread: Alignment.bottomRight,
                                      cardWidth: 300,
                                      cardHeight: 125,
                                      spreadableCardWidth: 325,
                                      spreadableCardHeight: 150,
                                      children: fareCards))),
                          const SizedBox(height: 100),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: circularButtonsList))
                        ],
                      )),
                  bottomNavigationBar: BottomNavigationBar(
                    unselectedItemColor: Colors.grey,
                    selectedItemColor: Colors.green,
                    backgroundColor: Colors.white,
                    showUnselectedLabels: true,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.flight), label: "Book"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.luggage), label: "My Trip"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.check), label: "Check in")
                    ],
                  ),
                ))));
  }

  Widget buildCircularButton(AssetImage image, String label) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2.0),
              shape: BoxShape.circle),
          child: CircleAvatar(
              radius: 25,
              backgroundImage: image,
              backgroundColor: Colors.white)),
      const SizedBox(height: 10),
      SizedBox(
          width: 75,
          height: 40,
          child: Container(
              color: Colors.transparent,
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )))
    ]);
  }

  Widget buildFareCard(String city, int priceInETB, String imagePath) {
    return Container(
        height: 150,
        width: 325,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(bRadius))),
        child: Stack(
          children: [
            Container(color: Colors.brown),
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
            Positioned(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.transparent,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(city,
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                          const Spacer(),
                          const Text("From",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400)),
                          Text("$priceInETB ETB",
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800))
                        ]))),
            Positioned(
                right: 5.0,
                bottom: 5.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.amber,
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {}))
          ],
        ));
  }

  Widget buildBookField({required bool isTop}) {
    Axis barDirection = isTop ? Axis.vertical : Axis.horizontal;
    double spacingWidth = isTop ? double.infinity : 15.0;
    double spacingHeight = isTop ? 15.0 : double.infinity;
    IconData swapIcon = isTop ? Icons.swap_vert : Icons.swap_horiz;
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
        color: Colors.white,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Flex(direction: barDirection, children: [
                Flexible(
                    child: buildDeparture(
                        isAtTop: isTop, parentConstraints: constraints)),
                SizedBox(height: spacingHeight, width: spacingWidth),
                Flexible(
                    child: buildDestination(
                        isAtTop: isTop, parentConstraints: constraints)),
              ]),
              Positioned(
                  left: constraints.maxWidth / 2 - 36,
                  top: constraints.maxHeight / 2 - 25,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white),
                      child: Icon(swapIcon),
                      onPressed: () {}))
            ],
          );
        }));
  }

  Widget buildDeparture({required bool isAtTop, required parentConstraints}) {
    return Container(
        width: isAtTop
            ? parentConstraints.maxWidth
            : parentConstraints.maxWidth / 2,
        height: 100,
        child: TextField(
          controller: departureController,
          decoration: const InputDecoration(
              hintText: "Addis Ababa",
              labelText: "From",
              prefixIcon: Icon(Icons.flight_takeoff),
              border: OutlineInputBorder()),
          keyboardType: TextInputType.text,
        ));
  }

  Widget buildDestination({required bool isAtTop, required parentConstraints}) {
    return Container(
        width: isAtTop
            ? parentConstraints.maxWidth
            : parentConstraints.maxWidth / 2,
        height: 100,
        child: TextField(
          controller: destinationController,
          decoration: const InputDecoration(
              labelText: "To",
              prefixIcon: Icon(Icons.flight_takeoff),
              border: OutlineInputBorder()),
          keyboardType: TextInputType.text,
        ));
  }

  Widget buildShebaMiles() {
    return Container(
        height: 150,
        width: 350,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.brown, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned.fill(
              child: Image.asset("assets/sheba_miles.png", fit: BoxFit.cover)),
          Positioned(
              bottom: 0,
              child: Opacity(
                  opacity: 0.3,
                  child: Container(
                      color: Colors.grey,
                      width: 350,
                      height: 40,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: const Text("ABCDEFGHIJKLMNO",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15))),
                            SizedBox(
                                width: 30,
                                child: IconButton(
                                    icon: const Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                    onPressed: () {}))
                          ]))))
        ]));
  }
}
