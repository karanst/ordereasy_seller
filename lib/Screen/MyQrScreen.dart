import 'dart:convert';

import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Helper/Session.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({Key? key}) : super(key: key);

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {

  var qrData;

  getQrData()async{
    var headers = {
      'Cookie': 'ci_session=64fe01a68225d4c49684d135ab13d2ab80b0990a'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}get_seller_details'));
    request.fields.addAll({
      'id': '${CUR_USERID}'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      setState(() {
        qrData = jsonResponse['data'][0];
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300),(){
      return getQrData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        getTranslated(context, "My Qr")!,
        context,
      ),
      body: qrData ==null ? CircularProgressIndicator() : Container(
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
            height: 100,
              width: 100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network("${imageUrl}${qrData['qrcode']}",fit: BoxFit.fill,),),
            ),
            SizedBox(height: 10,),
            Text("${qrData['qr_number']}"),
          ],
        ),
      ),
    );
  }
}
