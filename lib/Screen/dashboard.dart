import 'dart:async';
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/PushNotificationService.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Screen/Authentication/Login.dart';
import 'package:eshopmultivendor/Screen/Home.dart';
import 'package:eshopmultivendor/Screen/OrderList.dart';
import 'package:eshopmultivendor/Screen/ProductList.dart';
import 'package:eshopmultivendor/Screen/posts/my_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'Search.dart';

class RestaurantDashboard extends StatefulWidget {
  final String title;
  final sellerId;
  final catId;
  final sellerData;
  final showAll;
  const RestaurantDashboard({Key? key,
    required this.title,
    this.sellerId,
    this.sellerData,
    this.catId,
    this.showAll}) : super(key: key);

  @override
  State<RestaurantDashboard> createState() => _RestaurantDashboardState();
}

class _RestaurantDashboardState extends State<RestaurantDashboard> with TickerProviderStateMixin {
  int _selBottom = 0;
  late TabController _tabController;
  bool _isNetworkAvail = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    // initDynamicLinks();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );

    final pushNotificationService = PushNotificationService(
        context: context);
    pushNotificationService.initialise();

    _tabController.addListener(
          () {
        Future.delayed(Duration(seconds: 0)).then(
              (value) {
            if (_tabController.index == 3) {
              if (CUR_USERID == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                _tabController.animateTo(0);
              }
            }
          },
        );

        setState(
              () {
            _selBottom = _tabController.index;
          },
        );
      },
    );
  }

  // void initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //         final Uri? deepLink = dynamicLink?.link;
  //
  //         if (deepLink != null) {
  //           if (deepLink.queryParameters.length > 0) {
  //             int index = int.parse(deepLink.queryParameters['index']!);
  //
  //             int secPos = int.parse(deepLink.queryParameters['secPos']!);
  //
  //             String? id = deepLink.queryParameters['id'];
  //
  //             String? list = deepLink.queryParameters['list'];
  //
  //             getProduct(id!, index, secPos, list == "true" ? true : false);
  //           }
  //         }
  //       }, onError: (OnLinkErrorException e) async {
  //     print(e.message);
  //   });
  //
  //   final PendingDynamicLinkData? data =
  //   await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri? deepLink = data?.link;
  //   if (deepLink != null) {
  //     if (deepLink.queryParameters.length > 0) {
  //       int index = int.parse(deepLink.queryParameters['index']!);
  //
  //       int secPos = int.parse(deepLink.queryParameters['secPos']!);
  //
  //       String? id = deepLink.queryParameters['id'];
  //
  //       // String list = deepLink.queryParameters['list'];
  //
  //       getProduct(id!, index, secPos, true);
  //     }
  //   }
  // }

  // Future<void> getProduct(String id, int index, int secPos, bool list) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     try {
  //       var parameter = {
  //         ID: id,
  //       };
  //
  //       // if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID;
  //       Response response =
  //       await post(getProductApi, headers: headers, body: parameter)
  //           .timeout(Duration(seconds: timeOut));
  //
  //       var getdata = json.decode(response.body);
  //       bool error = getdata["error"];
  //       String msg = getdata["message"];
  //       if (!error) {
  //         var data = getdata["data"];
  //
  //         List<Product> items = [];
  //
  //         items =
  //             (data as List).map((data) => new Product.fromJson(data)).toList();
  //
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => ProductDetail(
  //               index: list ? int.parse(id) : index,
  //               model: list
  //                   ? items[0]
  //                   : sectionList[secPos].productList![index],
  //               secPos: secPos,
  //               list: list,
  //             )));
  //       } else {
  //         if (msg != "Products Not Found !") setSnackbar(msg, context);
  //       }
  //     } on TimeoutException catch (_) {
  //       setSnackbar(getTranslated(context, 'somethingMSg')!, context);
  //     }
  //   } else {
  //     {
  //       if (mounted)
  //         setState(() {
  //           _isNetworkAvail = false;
  //         });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index != 0) {
          _tabController.animateTo(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        // appBar: _getAppBar(),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Home(),
            OrderList(
              show : true
            ),
            MyPostsScreen(
              show: true,
            ),
            ProductList(
              flag: "",
              show: true,
            )

          ],
        ),
        //fragments[_selBottom],
        // bottomNavigationBar: _getBottomBar(),
        bottomNavigationBar: _getBottomNavigator(),
      ),
    );
  }

  AppBar _getAppBar() {
    String? title;
    if (_selBottom == 1)
      title = "Orders";
    //  title = getTranslated(context, 'CATEGORY');
    else if (_selBottom == 2)
      title = "Products";
    //title = getTranslated(context, 'OFFER');
    // else if (_selBottom == 3) title = getTranslated(context, 'ABOUT_LBL');
    // title = getTranslated(context, 'MYBAG');
    // else if (_selBottom == 4)
    //   title = getTranslated(context, 'PROFILE');

    return AppBar(
      centerTitle: _selBottom == 0 ? true : false,
      title: _selBottom == 0
          ? Text(
        "Dashboard",
        style: TextStyle(
            color: primary, fontWeight: FontWeight.normal),
      )
          : Text(
        title!,
        style: TextStyle(
            color: primary, fontWeight: FontWeight.normal),
      ),

      // leading: _selBottom == 0
      //     ? InkWell(
      //   child: Center(
      //       child: SvgPicture.asset(
      //         imagePath + "search.svg",
      //         height: 20,
      //         color: colors.primary,
      //       )),
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Search(),
      //         ));
      //   },
      // )
      //     : null,
      // iconTheme: new IconThemeData(color: colors.primary),
      // centerTitle:_curSelected == 0? false:true,
      // actions: <Widget>[
      //   _selBottom == 0 || _selBottom == 4
      //       ? Container()
      //       : IconButton(
      //       icon: SvgPicture.asset(
      //         imagePath + "search.svg",
      //         height: 20,
      //         color: colors.primary,
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => Search(),
      //             ));
      //       }),
      //   _selBottom == 4
      //       ? Container()
      //       : IconButton(
      //     icon: SvgPicture.asset(
      //       imagePath + "desel_notification.svg",
      //       color: colors.primary,
      //     ),
      //     onPressed: () {
      //       CUR_USERID != null
      //           ? Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => NotificationList(),
      //           ))
      //           : Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => Login(),
      //           ));
      //     },
      //   ),
      //   _selBottom == 4
      //       ? Container()
      //       : IconButton(
      //     padding: EdgeInsets.all(0),
      //     icon: SvgPicture.asset(
      //       imagePath + "desel_fav.svg",
      //       color: colors.primary,
      //     ),
      //     onPressed: () {
      //       CUR_USERID != null
      //           ? Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => Favorite(),
      //           ))
      //           : Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => Login(),
      //           ));
      //     },
      //   ),
      // ],
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Widget _getBottomBar() {
    return Material(
        color: Theme.of(context).colorScheme.background,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                  color: Colors.black54, blurRadius: 10)
            ],
          ),
          child: TabBar(
            onTap: (_) {
              if (_tabController.index == 3) {
                if (CUR_USERID == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                  _tabController.animateTo(0);
                }
              }
            },
            controller: _tabController,
            tabs: [
              Tab(
                icon: _selBottom == 0
                    ? Icon(Icons.home)
                    : Icon(Icons.home_outlined),
                text:
                _selBottom == 0 ? "Home" : null,
              ),
              // Tab(
              //   icon: _selBottom == 1
              //       ? SvgPicture.asset(
              //           imagePath + "category01.svg",
              //           color: colors.primary,
              //         )
              //       : SvgPicture.asset(
              //           imagePath + "category.svg",
              //           color: colors.primary,
              //         ),
              //   text:
              //       _selBottom == 1 ? getTranslated(context, 'category') : null,
              // ),
              Tab(
                icon: _selBottom == 1
                    ? Icon(Icons.shopping_cart):
        Icon(Icons.shopping_cart_outlined),
                text: _selBottom == 1 ? "Orders": null,
              ),

              Tab(
                icon: _selBottom == 2
                    ? Icon(Icons.wallet_giftcard):
                Icon(Icons.wallet_giftcard_rounded),
                text:
                _selBottom == 2 ? "Products" : null,
              ),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: primary, width: 5.0),
              insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
            ),
            labelStyle: TextStyle(fontSize: 9),
            labelColor: primary,
          ),
        ));
  }

  Widget _getBottomNavigator() {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: CurvedNavigationBar(
        height: 75,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Container(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.home, size: 30),
          ),
          //Icon(Icons.category, size: 30),
          Container(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.shopping_cart, size: 30),
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.local_offer_outlined, size: 30),
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.wallet_giftcard_rounded, size: 30),
          ),

          // Container(
          //   padding: EdgeInsets.all(4),
          //   child: SvgPicture.asset(
          //     'assets/images/pro_myorder.svg',
          //     height: 25,
          //     color: primary,
          //   ),
          // ),
          //
          // Container(
          //     padding: EdgeInsets.all(4),
          //     child: ImageIcon(
          //       AssetImage('assets/images/chat.png'),
          //       size: 30,
          //     )
          // ),

          // Padding(
          //   padding:  EdgeInsets.only(top: _selBottom == 3
          //       ? 0 : 10.0),
          //   child: Container(
          //     padding: EdgeInsets.all(4),
          //     child: Column(
          //       children: [
          //         Icon(Icons.person, size: 30),
          //         _selBottom == 3
          //             ? Text(
          //                 "Profile",
          //                 style: TextStyle(
          //                     color: colors.primary,
          //                     fontSize: 10,
          //                     fontWeight: FontWeight.w600),
          //               )
          //             : SizedBox.shrink()
          //       ],
          //     ),
          //   ),
          // ),
        ],
        onTap: (index) {
          _tabController.animateTo(index);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
