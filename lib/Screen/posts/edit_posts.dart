// import 'dart:convert';
// import 'dart:io';
// import 'package:eshopmultivendor/Helper/Color.dart';
// import 'package:eshopmultivendor/Helper/Session.dart';
// import 'package:eshopmultivendor/Helper/String.dart';
// import 'package:eshopmultivendor/Model/NewModel/table_type_model.dart';
// import 'package:eshopmultivendor/Model/NewModel/tables_list_model.dart';
// import 'package:eshopmultivendor/Screen/ManageTables/add_table.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class EditTable extends StatefulWidget {
//   final TablesList? data;
//   const EditTable({Key? key, this.data}) : super(key: key);
//
//   @override
//   State<EditTable> createState() => _EditTableState();
// }
//
// class _EditTableState extends State<EditTable> {
//
//
//   List selectedCategoryItems = [];
//   String? selectCatItems;
//   List _selectedItems = [];
//
//   void _showMultiSelect() async {
//     final List? results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return MultiSelect();
//         });
//       },
//     );
//
//     // Update UI
//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//       });
//       selectedCategoryItems = results.map((item) => item.name).toList();
//       selectCatItems = selectedCategoryItems.join(',');
//       print(
//           "this is result == ${_selectedItems.toString()} aaaaand ${selectedCategoryItems.toString()} &&&&&& ${selectCatItems.toString()}");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getTableTypes();
//     if(widget.data != null) {
//       setState(() {
//         categoryValue = widget.data!.name.toString();
//         tableAmountController = TextEditingController(text: widget.data!.price.toString());
//         tableCountController = TextEditingController(text: widget.data!.totalTables.toString());
//         benefitsController = TextEditingController(text: widget.data!.benifits.toString());
//       });
//     }
//   }
//
//   File? tableImage;
//   List<TableType> tableType = [];
//   String? categoryValue;
//   TextEditingController  tableAmountController = TextEditingController();
//   TextEditingController  tableCountController = TextEditingController();
//   TextEditingController  benefitsController = TextEditingController();
//
//   void requestPermission(BuildContext context) async{
//     return await showDialog<void>(
//       context: context,
//       // barrierDismissible: barrierDismissible, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(6))),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               InkWell(
//                 onTap: () async {
//                   getFromGallery();
//                 },
//                 child: Container(
//                   child: ListTile(
//                       title:  Text("Gallery"),
//                       leading: Icon(
//                         Icons.image,
//                         color: primary,
//                       )),
//                 ),
//               ),
//               Container(
//                 width: 200,
//                 height: 1,
//                 color: Colors.black12,
//               ),
//               InkWell(
//                 onTap: () async {
//                   getFromCamera();
//                 },
//                 child: Container(
//                   child: ListTile(
//                       title:  Text("Camera"),
//                       leading: Icon(
//                         Icons.camera,
//                         color: primary,
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//   }
//
//   Future<void> getFromGallery() async {
//     var result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: false,
//     );
//     if (result != null) {
//       setState(() {
//         tableImage = File(result.files.single.path.toString());
//       });
//       Navigator.pop(context);
//
//     } else {
//       // User canceled the picker
//     }
//   }
//
//   Future<void> getFromCamera() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         tableImage = File(pickedFile.path.toString());
//       });
//       Navigator.pop(context);
//     } else {
//
//     }
//   }
//
//
//   getTableTypes() async{
//     CUR_USERID = await getPrefrence(Id);
//     var headers = {
//       'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse(getTableTypesApi.toString()));
//     request.fields.addAll({
//       // UserId : CUR_USERID.toString()
//     });
//
//     print("this is refer request ${request.fields.toString()}");
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       String str = await response.stream.bytesToString();
//       var result = json.decode(str);
//       var finalResponse = TableTypeModel.fromJson(result);
//       setState(() {
//         tableType = finalResponse.data!;
//       });
//       print("this is referral data ${tableType.length}");
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   editRestroTables() async{
//     CUR_USERID = await getPrefrence(Id);
//     var headers = {
//       'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse(addRestroTablesApi.toString()));
//     request.fields.addAll({
//       UserId : CUR_USERID.toString(),
//       'table_name': categoryValue != null ?
//       categoryValue.toString() : "",
//       'table_amount': tableAmountController.text.toString(),
//       'table_count': tableCountController.text.toString(),
//       'table_benefits':_selectedItems.isEmpty
//           ? widget.data!.benifits != null || widget.data!.benifits.toString() !=''? widget.data!.benifits.toString(): '' : selectCatItems.toString(),
//       'id': widget.data!.id.toString()
//     });
//     if (tableImage != null) {
//       request.files.add(
//           await http.MultipartFile.fromPath('image', tableImage!.path));
//     }
//
//     print("this is refer request ${request.fields.toString()}");
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       String str = await response.stream.bytesToString();
//       var result = json.decode(str);
//       bool error  = result['error'];
//       String msg = result['message'];
//       if(!error) {
//         Fluttertoast.showToast(msg: msg);
//         Navigator.pop(context, 'true');
//       }else{
//
//       }
//       // var finalResponse = TableTypeModel.fromJson(result);
//       // setState(() {
//       //   tableType = finalResponse.data!;
//       // });
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   selectImage() async {
//     PickedFile? pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         tableImage = File(pickedFile.path);
//         // imagePath = File(pickedFile.path) ;
//         // filePath = imagePath!.path.toString();
//       });
//     }
//   }
//
//   _selectImage(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             title: const Text('Add Table Image'),
//             children: [
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Click Image from Camera'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   PickedFile? pickedFile = await ImagePicker().getImage(
//                     source: ImageSource.camera,
//                     maxHeight: 240.0,
//                     maxWidth: 240.0,
//                   );
//                   if (pickedFile != null) {
//                     setState(() {
//                       tableImage = File(pickedFile.path);
//                       // imagePath = File(pickedFile.path) ;
//                       // filePath = imagePath!.path.toString();
//                     });
//                     print("profile pic from camera ${tableImage}");
//                   }
//                 },
//               ),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Choose image from gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   selectImage();
//                   // getFromGallery();
//                   // setState(() {
//                   //   // _file = file;Start
//                   // });
//                 },
//               ),
//               // SimpleDialogOption(
//               //   padding: const EdgeInsets.all(20),
//               //   child: const Text('Choose Video from gallery'),
//               //   onPressed: () {
//               //     Navigator.of(context).pop();
//               //   },
//               // ),
//
//               // SimpleDialogOption(
//               //   padding: const EdgeInsets.all(20),
//               //   child: const Text('Cancel'),
//               //   onPressed: () {
//               //     Navigator.of(context).pop();
//               //   },
//               // ),
//             ],
//           );
//         });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       WillPopScope(
//           onWillPop: () async {
//             showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text("Confirm Exit"),
//                     content: Text("Are you sure you want to exit?"),
//                     actions: <Widget>[
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             primary: primary
//                         ),
//                         child: Text("YES"),
//                         onPressed: () {
//                           SystemNavigator.pop();
//                         },
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             primary: primary
//                         ),
//                         child: Text("NO"),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       )
//                     ],
//                   );
//                 }
//             );
//             return true;
//           },
//           child:
//
//           Scaffold(
//             appBar: PreferredSize(
//               preferredSize: Size.fromHeight(80),
//               child: AppBar(
//                 centerTitle: true,
//                 title: Image.asset('assets/images/homelogo.png', height: 60,),
//                 backgroundColor: primary,
//                 leading: IconButton(
//                   onPressed: (){
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(Icons.arrow_back_ios, color: white,),
//                 ),
//               ),
//             ),
//             body:
//             SingleChildScrollView(
//               child: Form(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset('assets/images/restaurant.png', height: 40, width: 40,),
//                           const SizedBox(width: 10,),
//                           Text("Edit Tables", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),),
//                         ],
//                       ),
//                       const SizedBox(height: 10,),
//                       Center(
//                         child: Container(
//                           height: 150,
//                           width: 150,
//                           decoration: BoxDecoration(
//                             // border: Border.all(color: primary, width: 1),
//                             // shape: BoxShape.circle,
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                                 image: NetworkImage(widget.data!.image.toString()),
//                                 fit: BoxFit.fill
//                             ),
//                             // borderRadius: BorderRadius.circular(15)
//                           ),
//                           // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
//                         ),
//                       ),
//                       // widget.data!.subList != null ?
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 5),
//                         child: Text("Table Type", style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: primary
//                         ),),
//                       ),
//
//                       Padding(
//                           padding: const EdgeInsets.only( bottom: 8),
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             height: 50,
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                                 color: white,
//                                 borderRadius: BorderRadius.circular(80),
//                                 border: Border.all(color: primary)
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton(
//                                 hint: Text('Select Table Type'), // Not necessary for Option 1
//                                 value: categoryValue,
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     categoryValue = newValue;
//                                   });
//                                   tableType.forEach((element) {
//                                     if(element.tableType == categoryValue){
//                                       setState(() {
//                                         tableAmountController.text = element.price!;
//                                       });
//                                     }
//                                   });
//                                   //
//                                   print("this is tbale selected value $categoryValue");
//                                 },
//                                 items: tableType.map((item) {
//                                   return DropdownMenuItem(
//                                     child:  Text(item.tableType!, style:TextStyle(color: Colors.black),),
//                                     value: item.tableType,
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           )
//                       ),
//                       // : SizedBox.shrink(),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 12, bottom: 12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8.0, bottom: 5),
//                                   child: Text("Table Amount", style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: primary
//                                   ),),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8),
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                       color: white,
//                                       borderRadius: BorderRadius.circular(80),
//                                       border: Border.all(color: primary)
//                                   ),
//                                   width: MediaQuery.of(context).size.width/2-30,
//                                   child: TextFormField(
//                                     style: TextStyle(color: Colors.black),
//                                     controller: tableAmountController,
//                                     keyboardType: TextInputType.number,
//                                     maxLength: 10,
//                                     decoration: InputDecoration(
//                                         suffix: Text("₹"),
//                                         counterText: '',
//                                         border: InputBorder.none,
//                                         hintText: "Table Amount"
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 12, bottom: 12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8.0,  bottom: 5),
//                                   child: Text("Table Count", style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: primary
//                                   ),),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(8),
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                       color: white,
//                                       borderRadius: BorderRadius.circular(80),
//                                       border: Border.all(color: primary)
//                                   ),
//                                   width: MediaQuery.of(context).size.width/2-30,
//                                   child: TextFormField(
//                                     style: TextStyle(color: Colors.black),
//                                     keyboardType: TextInputType.number,
//                                     maxLength: 10,
//                                     controller: tableCountController,
//                                     decoration: InputDecoration(
//                                         counterText: '',
//                                         border: InputBorder.none,
//                                         hintText: "Table Count"
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
//                         child: Text("Benefits", style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: primary
//                         ),),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           _showMultiSelect();
//                         },
//                         child: Padding(
//                             padding: const EdgeInsets.only( bottom: 12),
//                             child: Container(
//                                 padding: EdgeInsets.all(8),
//                                 // height: 80,
//                                 decoration: BoxDecoration(
//                                     color: white,
//                                     borderRadius: BorderRadius.circular(80),
//                                     border: Border.all(color: primary)
//                                 ),
//                                 width: MediaQuery.of(context).size.width,
//                                 child:
//                                 _selectedItems.isEmpty
//                                     ? benefitsController.text.isNotEmpty ?
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, top: 20, bottom: 20),
//                                   child: Text(
//                                     benefitsController.text.toString(),
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: primary,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ) :
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, top: 20, bottom: 20),
//                                   child: Text(
//                                     'Benefits',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: primary,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 )
//                                     : Wrap(
//                                   children: _selectedItems.map((item) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 8.0, right: 8),
//                                       child: Chip(
//                                         backgroundColor:
//                                         primary,
//                                         label: Text(
//                                           "${item.name}",
//                                           style: TextStyle(
//                                               color:
//                                               white),
//                                           //item.name
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 )
//                             )
//                         ),
//                       ),
//                       ElevatedButton(
//                           onPressed: (){
//                             _selectImage(context);
//                             // requestPermission(context);
//                           },
//                           style: ElevatedButton.styleFrom(primary: primary, shape: StadiumBorder()),
//                           child: Text("Upload Images", style: TextStyle(
//                               color: white
//                           ),)),
//
//                       tableImage == null ?
//                       SizedBox.shrink():
//                       Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             image: DecorationImage(
//                                 image: FileImage(File(tableImage!.path)),
//                                 fit: BoxFit.fill
//                               //AssetImage(Image.file(file)File(tableImage!.path)),
//                             )
//                         ),
//                         width: MediaQuery.of(context).size.width/1.7,
//                         height: MediaQuery.of(context).size.width/1.7,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0, bottom: 30),
//                         child: ElevatedButton(
//                             onPressed: (){
//                               if(tableAmountController.text.isNotEmpty && tableCountController.text.isNotEmpty && categoryValue != null){
//                                 editRestroTables();
//                               }else{
//                                 Fluttertoast.showToast(msg: "All Fields are required!");
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 primary: primary,
//                                 shape: StadiumBorder(),
//                                 // RoundedRectangleBorder(
//                                 //   borderRadius: BorderRadius.circular(15),
//                                 // ),
//                                 fixedSize: Size(MediaQuery.of(context).size.width - 40, 50)
//                             ),
//                             child: Text("Edit Table", style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w600,
//                                 color: white
//                             ),)),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//       );
//   }
// }
