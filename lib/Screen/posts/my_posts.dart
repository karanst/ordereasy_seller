import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Model/my_posts_model.dart';
import 'package:eshopmultivendor/Screen/posts/add_posts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Helper/Constant.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({Key? key}) : super(key: key);

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}
bool _isLoading = true;
class _MyPostsScreenState extends State<MyPostsScreen> with TickerProviderStateMixin {

  // List<TablesList> tablesList = [];

  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  
  List<MyPostsList> myPosts = [];
  
  getMyPostsData() async{
    CUR_USERID = await getPrefrence(Id);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(getMyPostsApi.toString()));
    request.fields.addAll({
      SellerId : CUR_USERID.toString(),
      'type': selectedTab.toString()
    });

    print("this is refer request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = MyPostsModel.fromJson(result);
      setState(() {
        myPosts = finalResponse.data!;
        _isLoading = false;
      });
      print("this is referral data ${myPosts.length}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  // deleteTable(String tableId) async{
  //   CUR_USERID = await getPrefrence(Id);
  //   var headers = {
  //     'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(deleteTablesApi.toString()));
  //   request.fields.addAll({
  //     'id' : tableId.toString()
  //   });
  //
  //   print("this is refer request ${request.fields.toString()}");
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     String str = await response.stream.bytesToString();
  //     var result = json.decode(str);
  //     if(!result['error']){
  //       Fluttertoast.showToast(msg: '${result['message']}');
  //       getRestroTables();
  //     }
  //     print("this is referral data ${tablesList.length}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  int _currentPost =  0;

  List<Widget> _buildDots(int index) {
    List<Widget> dots = [];
    for (int i = 0; i < myPosts[index].images!.length; i++) {
      dots.add(
        Container(
          margin: EdgeInsets.all(2),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPost == i
                ? primary
                : Colors.grey.withOpacity(0.5),
          ),
        ),
      );
    }
    return dots;
  }
  
  Widget postCard(int i) {
    return Column(
      children: [
        myPosts[i].images!.length > 1
            ? Container(
          decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(10)
          ),
              child: Column(
                children: [
                  CarouselSlider(
          options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPost = index;
                    });
                  },
                  height: 200.0,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  aspectRatio: 1,
                  // 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: false,
                  autoPlayAnimationDuration:
                  Duration(milliseconds: 1000),
                  viewportFraction: 1.0,
          ),
          items:  myPosts[i].images!.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.35,
                            width: MediaQuery.of(context).size.width,
                            child: item.isEmpty ||  myPosts[i].images![0].toString() == imageUrl
                                ? Image.asset(
                              'assets/placeholder.png',
                              // widget.snap['postUrl'],
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              item,
                              // widget.snap['postUrl'],
                              fit: BoxFit.cover,
                            ),
                          ));
                    },
                  );
          }).toList(),
        ),
                  Text(myPosts[i].text.toString())
                ],
              ),
            )
            : Container(
          decoration: BoxDecoration(
              border: Border.all(color: primary),
              borderRadius: BorderRadius.circular(10)
          ),
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Container(
          child:  myPosts[i].images!.isEmpty ||  myPosts[i].images![0].toString() == imageUrl
              ? Image.asset(
            'assets/placeholder.png',
            // widget.snap['postUrl'],
            fit: BoxFit.cover,
          )
              : Image.network(
            myPosts[i].images![0].toString(),
            // widget.snap['postUrl'],
            fit: BoxFit.cover,
          ),
        ),
        ),
        myPosts[i].images!.length > 1 ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDots(i),
        )
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getMyPostsData();
  }
  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }
  noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(Duration(seconds: 2)).then(
                      (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {

                    } else {
                      await buttonController!.reverse();
                      setState(
                            () {},
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    Completer<Null> completer = new Completer<Null>();
    await Future.delayed(Duration(seconds: 3)).then(
          (onvalue) {
        completer.complete();
        // getRestroTables();
        setState(
              () {
            _isLoading = true;
          },
        );
      },
    );
    return completer.future;
  }

  Widget bodyWidget(){
    return _isNetworkAvail
        ? _isLoading
        ? shimmer()
        : RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: myPosts.length,
                    itemBuilder: (context, index){
                      return postCard(index);
                    }),
              ),
            ],
          ),
        )    )
        : noInternet(context);
  }

  // Widget tablesCard(int index){
  //   return Container(
  //     height: 160,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 40,
  //           top: 30,
  //           child: Card(
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //             child: Container(
  //               // height: 280,
  //               width: MediaQuery.of(context).size.width - 70,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: white,
  //                   border: Border.all(color: primary, width: 1)
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.only(top: 5, bottom: 5),
  //                     child:  Center(
  //                       child: Text(tablesList[index].name.toString(),
  //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: white)),
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: primary,
  //                       borderRadius: BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13))
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(width: 60,),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 5),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text("Booking Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                                   Text("₹ ${tablesList[index].price.toString()}",
  //                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                   // Container(
  //                                   //   padding: EdgeInsets.all(10),
  //                                   //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                                   //       borderRadius: BorderRadius.circular(15)),
  //                                   //   child: Text(bookingList[index].approxAmount.toString(),
  //                                   //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                   // ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                                 Text("${tablesList[index].totalTables.toString()}",
  //                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                               ],
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 5.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text("Benefits : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                                   Text("${tablesList[index].benifits.toString()}",
  //                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         // Column(
  //                         //   crossAxisAlignment: CrossAxisAlignment.start,
  //                         //   children: [
  //                         //     Row(
  //                         //       children: [
  //                         //         Text("Name : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                         //
  //                         //         Text(bookingList[index].users![0].detail!.username.toString(),
  //                         //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary)),
  //                         //       ],
  //                         //     ),
  //                         //     const SizedBox(height: 5,),
  //                         //     Row(
  //                         //       children: [
  //                         //         Text("Contact No.: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                         //         Text(bookingList[index].users![0].detail!.mobile.toString(),
  //                         //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
  //                         //       ],
  //                         //     ),
  //                         //   ],
  //                         // ),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   //   child: Row(
  //                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //     children: [
  //                   //       Text("Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                   //       Text("₹ ${tablesList[index].price.toString()}",
  //                   //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // Container(
  //                   //       //   padding: EdgeInsets.all(10),
  //                   //       //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                   //       //       borderRadius: BorderRadius.circular(15)),
  //                   //       //   child: Text(bookingList[index].approxAmount.toString(),
  //                   //       //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // ),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                   //
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   //   child: Row(
  //                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //     children: [
  //                   //       Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                   //       Text("${tablesList[index].totalTables.toString()}",
  //                   //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // Container(
  //                   //       //   padding: EdgeInsets.all(10),
  //                   //       //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                   //       //       borderRadius: BorderRadius.circular(15)),
  //                   //       //   child: Text(bookingList[index].approxAmount.toString(),
  //                   //       //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // ),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //
  //                   const SizedBox(height: 10,),
  //                   // Container(
  //                   //   width: MediaQuery.of(context).size.width,
  //                   //   padding: EdgeInsets.all(10),
  //                   //   decoration: BoxDecoration(
  //                   //       color: primary,
  //                   //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13))
  //                   //   ),
  //                   //   // child: Row(
  //                   //   //   mainAxisAlignment: MainAxisAlignment.end,
  //                   //   //   children: [
  //                   //   //     Padding(
  //                   //   //       padding: const EdgeInsets.only(right: 10.0),
  //                   //   //       child: Container(
  //                   //   //         padding: EdgeInsets.all(4),
  //                   //   //         decoration: BoxDecoration(
  //                   //   //             color: white,
  //                   //   //             borderRadius: BorderRadius.circular(8)
  //                   //   //         ),
  //                   //   //         child: Text("",
  //                   //   //           style: TextStyle(
  //                   //   //               color: primary,
  //                   //   //               fontWeight: FontWeight.w600,
  //                   //   //               fontSize: 16
  //                   //   //           ),),
  //                   //   //       ),
  //                   //   //     ),
  //                   //   //   ],
  //                   //   // ),
  //                   //   // child:
  //                   //   // bookingList[index].bookingStatus.toString() == "1" ?
  //                   //   // Row(
  //                   //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   //   //   children: [
  //                   //   //     ElevatedButton(
  //                   //   //       onPressed: (){
  //                   //   //       // showInformationDialog(context, index, bookingList[index]);
  //                   //   //     }, child: Text("Accept", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   //       style: ElevatedButton.styleFrom(
  //                   //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                   //   //           primary: white, shape: RoundedRectangleBorder(
  //                   //   //         borderRadius: BorderRadius.circular(10),
  //                   //   //
  //                   //   //       )),
  //                   //   //     ),
  //                   //   //     ElevatedButton(
  //                   //   //       onPressed: (){
  //                   //   //         // showInformationDialog(context, index, bookingList[index]);
  //                   //   //       }, child: Text("Reject", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   //       style: ElevatedButton.styleFrom(
  //                   //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                   //   //           primary: white, shape: RoundedRectangleBorder(
  //                   //   //         borderRadius: BorderRadius.circular(10),
  //                   //   //
  //                   //   //       )),
  //                   //   //     ),
  //                   //   //   ],
  //                   //   // )
  //                   //   // : SizedBox.shrink(),
  //                   // ),
  //
  //                   // Spacer(),
  //                   // Divider(
  //                   //   thickness: 2,
  //                   //   color: secondary,
  //                   // ),
  //                   // Expanded(
  //                   //   child: Padding(
  //                   //     padding: const EdgeInsets.only(right: 8.0),
  //                   //     child: DropdownButtonFormField(
  //                   //       dropdownColor: white,
  //                   //       isDense: true,
  //                   //       iconEnabledColor: primary,
  //                   //       hint: Text(
  //                   //         getTranslated(context, "UpdateStatus")!,
  //                   //         style: Theme.of(this.context)
  //                   //             .textTheme
  //                   //             .subtitle2!
  //                   //             .copyWith(
  //                   //             color: primary,
  //                   //             fontWeight: FontWeight.bold),
  //                   //       ),
  //                   //       decoration: InputDecoration(
  //                   //         filled: true,
  //                   //         isDense: true,
  //                   //         fillColor: white,
  //                   //         contentPadding: EdgeInsets.symmetric(
  //                   //             vertical: 10, horizontal: 10),
  //                   //         enabledBorder: OutlineInputBorder(
  //                   //           borderSide: BorderSide(color: primary),
  //                   //         ),
  //                   //       ),
  //                   //       value: orderItem.status,
  //                   //       onChanged: (dynamic newValue) {
  //                   //         setState(
  //                   //               () {
  //                   //             orderItem.curSelected = newValue;
  //                   //             updateOrder(
  //                   //               orderItem.curSelected,
  //                   //               updateOrderItemApi,
  //                   //               model.id,
  //                   //               true,
  //                   //               i,
  //                   //             );
  //                   //           },
  //                   //         );
  //                   //       },
  //                   //       items: statusList.map(
  //                   //             (String st) {
  //                   //           return DropdownMenuItem<String>(
  //                   //             value: st,
  //                   //             child: Text(
  //                   //               capitalize(st),
  //                   //               style: Theme.of(this.context)
  //                   //                   .textTheme
  //                   //                   .subtitle2!
  //                   //                   .copyWith(
  //                   //                   color: primary,
  //                   //                   fontWeight:
  //                   //                   FontWeight.bold),
  //                   //             ),
  //                   //           );
  //                   //         },
  //                   //       ).toList(),
  //                   //     ),
  //                   //   ),
  //                   // ),
  //                   // statusUpdateWidget(index, bookingList[index]),
  //                   // ElevatedButton(onPressed: (){
  //                   //   // showInformationDialog(context, index, bookingList[index]);
  //                   // }, child: Text("Change Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   style: ElevatedButton.styleFrom(
  //                   //       fixedSize: Size(MediaQuery.of(context).size.width - 60, 50),
  //                   //       primary: primary, shape: RoundedRectangleBorder(
  //                   //     borderRadius: BorderRadius.circular(10),
  //                   //
  //                   //   )),
  //                   // )
  //                   // Container(
  //                   //   width: MediaQuery.of(context).size.width,
  //                   //   height: 60,
  //                   //   child: Row(
  //                   //     children: [
  //                   //       Container(
  //                   //         width: MediaQuery.of(context).size.width/2,
  //                   //         height: 60,
  //                   //         child: DropdownButton(
  //                   //           hint: Text('Select Status'), // Not necessary for Option 1
  //                   //           value: categoryValue,
  //                   //           onChanged: (String? newValue) {
  //                   //             setState(() {
  //                   //               categoryValue = newValue;
  //                   //             });
  //                   //           },
  //                   //           items: leadStatus.map((item) {
  //                   //             return DropdownMenuItem(
  //                   //               child:  Text(item),
  //                   //               value: item,
  //                   //             );
  //                   //           }).toList(),
  //                   //         ),
  //                   //       ),
  //                   //       // Container(
  //                   //       //     padding: EdgeInsets.all(8),
  //                   //       //     decoration: BoxDecoration(
  //                   //       //         color: secondary,
  //                   //       //         borderRadius: BorderRadius.circular(10)
  //                   //       //     ),
  //                   //       //     child: Center(child: Text(bookingList[index].status.toString(), style: TextStyle(fontSize: 14,
  //                   //       //         color: Colors.white,
  //                   //       //         fontWeight: FontWeight.w600)))),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Card(
  //           elevation: 4,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(100)
  //           ),
  //           child:  tablesList[index].image != null || tablesList[index].image !='' ?
  //           Container(
  //             height: 100,
  //             width: 100,
  //             decoration: BoxDecoration(
  //               // border: Border.all(color: primary, width: 1),
  //               shape: BoxShape.circle,
  //                 image: DecorationImage(
  //                     image: NetworkImage(tablesList[index].image.toString()),
  //                     fit: BoxFit.fill
  //                 ),
  //                 // borderRadius: BorderRadius.circular(15)
  //             ),
  //             // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //           )
  //           : Container(
  //             height: 100,
  //             width: 100,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               image: DecorationImage(
  //                   image:  AssetImage('assets/images/placeholder.png'),
  //                   fit: BoxFit.fill
  //               ),
  //               // borderRadius: BorderRadius.circular(15)
  //             ),
  //             // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  int selectedTab = 1 ;

  tabBarView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width/1.7 - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    selectedTab = 1;
                  });
                  // getPosts("1");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: primary,),
                      color: selectedTab  == 1 ? primary : white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("Current Posts", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: selectedTab  == 1 ? white : primary,
                  ),),
                ),
              ),
              // const SizedBox(width: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    selectedTab = 2;
                  });
                  // getPosts("2");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: primary,),
                      color: selectedTab  == 2 ? primary : white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("All Posts", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: selectedTab  == 2 ? white : primary,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tablesCard1(int index){
  //   return Container(
  //     // height: 160,
  //     child: Stack(
  //       children: [
  //         // Positioned(
  //         // left: 40,
  //         // top: 30,
  //         // child:
  //         Card(
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //           child: Container(
  //             // height: 280,
  //             width: MediaQuery.of(context).size.width ,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15),
  //                 color: white,
  //                 border: Border.all(color: primary, width: 1)
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
  //                   child:  Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(tablesList[index].name.toString(),
  //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: white)),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           IconButton(
  //                               onPressed: (){
  //                                 Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTable(
  //                                     data: tablesList[index]
  //                                 )));
  //                               }, icon: Icon(Icons.edit, color: white)),
  //                           IconButton(onPressed: (){
  //                             showDialog(
  //                                 context: context,
  //                                 barrierDismissible: false,
  //                                 builder: (BuildContext context) {
  //                                   return AlertDialog(
  //                                     title: Text("Confirm Delete"),
  //                                     content: Text("Are you sure you want to Delete?"),
  //                                     actions: <Widget>[
  //                                       ElevatedButton(
  //                                         style: ElevatedButton.styleFrom(primary: primary),
  //                                         child: Text("YES", style: TextStyle(color: white),),
  //                                         onPressed: () {
  //                                           deleteTable(tablesList[index].id.toString());
  //                                           Navigator.pop(context);
  //                                         },
  //                                       ),
  //                                       ElevatedButton(
  //                                         style: ElevatedButton.styleFrom(primary: primary),
  //                                         child: Text("NO", style: TextStyle(color: white),),
  //                                         onPressed: () {
  //                                           Navigator.pop(context);
  //                                         },
  //                                       )
  //                                     ],
  //                                   );
  //                                 });
  //                           }, icon: Icon(Icons.delete_forever, color: white))
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                   decoration: BoxDecoration(
  //                       color: primary,
  //                       borderRadius: BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13))
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       tablesList[index].image == null || tablesList[index].image =='https://developmentalphawizz.com/blind_date/' ?
  //                       Container(
  //                         height: 100,
  //                         width: 100,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           image: DecorationImage(
  //                               image:  AssetImage('assets/images/placeholder.png'),
  //                               fit: BoxFit.fitHeight
  //                           ),
  //                           // borderRadius: BorderRadius.circular(15)
  //                         ),
  //                         // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //                       )
  //                           : Container(
  //                         height: 100,
  //                         width: 100,
  //                         decoration: BoxDecoration(
  //                           // border: Border.all(color: primary, width: 1),
  //                           // shape: BoxShape.circle,
  //                           borderRadius: BorderRadius.circular(12),
  //                           image: DecorationImage(
  //                               image: NetworkImage(tablesList[index].image.toString()),
  //                               fit: BoxFit.fill
  //                           ),
  //                           // borderRadius: BorderRadius.circular(15)
  //                         ),
  //                         // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //                       ),
  //                       const SizedBox(width: 15,),
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //
  //                           Padding(
  //                             padding: const EdgeInsets.only(bottom: 5),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text("Booking Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                                 Text("₹ ${tablesList[index].price.toString()}",
  //                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
  //                               ],
  //                             ),
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                               Text("${tablesList[index].totalTables.toString()}",
  //                                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
  //                             ],
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 5.0),
  //                             child: Row(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text("Benefits : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontColor),),
  //                                 Container(
  //                                   width: MediaQuery.of(context).size.width/2 -50,
  //                                   child: Text("${tablesList[index].benifits.toString()}",
  //                                       maxLines: 2,
  //                                       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //
  //                 const SizedBox(height: 10,),
  //                 // Container(
  //                 //   width: MediaQuery.of(context).size.width,
  //                 //   padding: EdgeInsets.all(10),
  //                 //   decoration: BoxDecoration(
  //                 //       color: primary,
  //                 //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13))
  //                 //   ),
  //                 //   // child: Row(
  //                 //   //   mainAxisAlignment: MainAxisAlignment.end,
  //                 //   //   children: [
  //                 //   //     Padding(
  //                 //   //       padding: const EdgeInsets.only(right: 10.0),
  //                 //   //       child: Container(
  //                 //   //         padding: EdgeInsets.all(4),
  //                 //   //         decoration: BoxDecoration(
  //                 //   //             color: white,
  //                 //   //             borderRadius: BorderRadius.circular(8)
  //                 //   //         ),
  //                 //   //         child: Text("",
  //                 //   //           style: TextStyle(
  //                 //   //               color: primary,
  //                 //   //               fontWeight: FontWeight.w600,
  //                 //   //               fontSize: 16
  //                 //   //           ),),
  //                 //   //       ),
  //                 //   //     ),
  //                 //   //   ],
  //                 //   // ),
  //                 //   // child:
  //                 //   // bookingList[index].bookingStatus.toString() == "1" ?
  //                 //   // Row(
  //                 //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 //   //   children: [
  //                 //   //     ElevatedButton(
  //                 //   //       onPressed: (){
  //                 //   //       // showInformationDialog(context, index, bookingList[index]);
  //                 //   //     }, child: Text("Accept", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                 //   //       style: ElevatedButton.styleFrom(
  //                 //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                 //   //           primary: white, shape: RoundedRectangleBorder(
  //                 //   //         borderRadius: BorderRadius.circular(10),
  //                 //   //
  //                 //   //       )),
  //                 //   //     ),
  //                 //   //     ElevatedButton(
  //                 //   //       onPressed: (){
  //                 //   //         // showInformationDialog(context, index, bookingList[index]);
  //                 //   //       }, child: Text("Reject", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                 //   //       style: ElevatedButton.styleFrom(
  //                 //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                 //   //           primary: white, shape: RoundedRectangleBorder(
  //                 //   //         borderRadius: BorderRadius.circular(10),
  //                 //   //
  //                 //   //       )),
  //                 //   //     ),
  //                 //   //   ],
  //                 //   // )
  //                 //   // : SizedBox.shrink(),
  //                 // ),
  //
  //                 // Spacer(),
  //                 // Divider(
  //                 //   thickness: 2,
  //                 //   color: secondary,
  //                 // ),
  //                 // Expanded(
  //                 //   child: Padding(
  //                 //     padding: const EdgeInsets.only(right: 8.0),
  //                 //     child: DropdownButtonFormField(
  //                 //       dropdownColor: white,
  //                 //       isDense: true,
  //                 //       iconEnabledColor: primary,
  //                 //       hint: Text(
  //                 //         getTranslated(context, "UpdateStatus")!,
  //                 //         style: Theme.of(this.context)
  //                 //             .textTheme
  //                 //             .subtitle2!
  //                 //             .copyWith(
  //                 //             color: primary,
  //                 //             fontWeight: FontWeight.bold),
  //                 //       ),
  //                 //       decoration: InputDecoration(
  //                 //         filled: true,
  //                 //         isDense: true,
  //                 //         fillColor: white,
  //                 //         contentPadding: EdgeInsets.symmetric(
  //                 //             vertical: 10, horizontal: 10),
  //                 //         enabledBorder: OutlineInputBorder(
  //                 //           borderSide: BorderSide(color: primary),
  //                 //         ),
  //                 //       ),
  //                 //       value: orderItem.status,
  //                 //       onChanged: (dynamic newValue) {
  //                 //         setState(
  //                 //               () {
  //                 //             orderItem.curSelected = newValue;
  //                 //             updateOrder(
  //                 //               orderItem.curSelected,
  //                 //               updateOrderItemApi,
  //                 //               model.id,
  //                 //               true,
  //                 //               i,
  //                 //             );
  //                 //           },
  //                 //         );
  //                 //       },
  //                 //       items: statusList.map(
  //                 //             (String st) {
  //                 //           return DropdownMenuItem<String>(
  //                 //             value: st,
  //                 //             child: Text(
  //                 //               capitalize(st),
  //                 //               style: Theme.of(this.context)
  //                 //                   .textTheme
  //                 //                   .subtitle2!
  //                 //                   .copyWith(
  //                 //                   color: primary,
  //                 //                   fontWeight:
  //                 //                   FontWeight.bold),
  //                 //             ),
  //                 //           );
  //                 //         },
  //                 //       ).toList(),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // statusUpdateWidget(index, bookingList[index]),
  //                 // ElevatedButton(onPressed: (){
  //                 //   // showInformationDialog(context, index, bookingList[index]);
  //                 // }, child: Text("Change Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
  //                 //   style: ElevatedButton.styleFrom(
  //                 //       fixedSize: Size(MediaQuery.of(context).size.width - 60, 50),
  //                 //       primary: primary, shape: RoundedRectangleBorder(
  //                 //     borderRadius: BorderRadius.circular(10),
  //                 //
  //                 //   )),
  //                 // )
  //                 // Container(
  //                 //   width: MediaQuery.of(context).size.width,
  //                 //   height: 60,
  //                 //   child: Row(
  //                 //     children: [
  //                 //       Container(
  //                 //         width: MediaQuery.of(context).size.width/2,
  //                 //         height: 60,
  //                 //         child: DropdownButton(
  //                 //           hint: Text('Select Status'), // Not necessary for Option 1
  //                 //           value: categoryValue,
  //                 //           onChanged: (String? newValue) {
  //                 //             setState(() {
  //                 //               categoryValue = newValue;
  //                 //             });
  //                 //           },
  //                 //           items: leadStatus.map((item) {
  //                 //             return DropdownMenuItem(
  //                 //               child:  Text(item),
  //                 //               value: item,
  //                 //             );
  //                 //           }).toList(),
  //                 //         ),
  //                 //       ),
  //                 //       // Container(
  //                 //       //     padding: EdgeInsets.all(8),
  //                 //       //     decoration: BoxDecoration(
  //                 //       //         color: secondary,
  //                 //       //         borderRadius: BorderRadius.circular(10)
  //                 //       //     ),
  //                 //       //     child: Center(child: Text(bookingList[index].status.toString(), style: TextStyle(fontSize: 14,
  //                 //       //         color: Colors.white,
  //                 //       //         fontWeight: FontWeight.w600)))),
  //                 //     ],
  //                 //   ),
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         // ),
  //         // Card(
  //         //   elevation: 4,
  //         //   shape: RoundedRectangleBorder(
  //         //       borderRadius: BorderRadius.circular(100)
  //         //   ),
  //         //   child:  tablesList[index].image != null || tablesList[index].image !='' ?
  //         //   Container(
  //         //     height: 100,
  //         //     width: 100,
  //         //     decoration: BoxDecoration(
  //         //       // border: Border.all(color: primary, width: 1),
  //         //       shape: BoxShape.circle,
  //         //       image: DecorationImage(
  //         //           image: NetworkImage(tablesList[index].image.toString()),
  //         //           fit: BoxFit.fill
  //         //       ),
  //         //       // borderRadius: BorderRadius.circular(15)
  //         //     ),
  //         //     // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //         //   )
  //         //       : Container(
  //         //     height: 100,
  //         //     width: 100,
  //         //     decoration: BoxDecoration(
  //         //       shape: BoxShape.circle,
  //         //       image: DecorationImage(
  //         //           image:  AssetImage('assets/images/placeholder.png'),
  //         //           fit: BoxFit.fill
  //         //       ),
  //         //       // borderRadius: BorderRadius.circular(15)
  //         //     ),
  //         //     // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //         //   ),
  //         // )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            centerTitle: true,
            title: Image.asset('assets/images/homelogo.png', height: 60,),
            backgroundColor: primary,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: white,),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPosts()));
                    if(result != null){
                      // getRestroTables();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: white),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add Table ", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),),
                        Icon(Icons.add_box, color: Colors.white,)
                      ],
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //   height: 30,
              //   child: Container(
              //     height: 30,
              //     width: 100,
              //     decoration: BoxDecoration(
              //       color: Colors.white, borderRadius: BorderRadius.circular(20)
              //     ),
              //     child: Center(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text("Add Table", style: TextStyle(
              //             color: primary
              //           ),),
              //           Icon(Icons.add_box, color: primary,)
              //         ],
              //       ),
              //     ),
              //   ),
              // )

            ],
          ),
        ),
        body: Column(
          children: [
            tabBarView(),
            bodyWidget(),
          ],
        )
    );
  }
}
