import 'dart:convert';
import 'dart:io';
import 'package:eshopmultivendor/Helper/ApiBaseHelper.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Model/ProductModel/Product.dart';
import 'package:eshopmultivendor/Model/my_posts_model.dart';
import 'package:eshopmultivendor/Screen/Home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditPostScreen extends StatefulWidget {
  MyPostsList? data;
   EditPostScreen({Key? key, this.data}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {


  List<Product> productList = [];
  List<ProductModel> tempList1 = [];
  List<Product> tempList = [];
  String? sortBy = 'p.id', orderBy = "DESC", flag = ' ';
  int offset = 0;
  int total = 0;
  String? totalProduct;
  bool isLoadingmore = true;
  ScrollController controller = new ScrollController();
  bool _isNetworkAvail = true;
  List<String> selectedId = [];
  bool _isFirstLoad = true;
  String? filter = "";

  bool _isLoading = false;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();


  @override
  void initState() {
    super.initState();
    if(widget.data != null){
      setState(() {
        oldPriceController.text  = widget.data!.oldPrice.toString();
        newPriceController.text =  widget.data!.newPrice.toString();
        descriptionController.text =  widget.data!.text.toString();
        startController.text =  widget.data!.startDate.toString();
        endController.text =  widget.data!.endDate.toString();
        selectedTab = int.parse(widget.data!.postType.toString());
        // categoryValue = widget.data?.productId;
      });
    }
    getProduct('0');
    // getTableTypes();
  }

  List selectedCategoryItems = [];
  String? selectCatItems;
  List _selectedItems = [];
  // void _showMultiSelect() async {
  //   final List? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return MultiSelect(
  //         );
  //       });
  //     },
  //   );
  //
  //   // Update UI
  //   if (results != null) {
  //     setState(() {
  //       _selectedItems = results;
  //     });
  //     selectedCategoryItems = results.map((item) => item.name).toList();
  //     selectCatItems = selectedCategoryItems.join(',');
  //     print(
  //         "this is result == ${_selectedItems.toString()} aaaaand ${selectedCategoryItems.toString()} &&&&&& ${selectCatItems.toString()}");
  //   }
  // }

  File? tableImage;
  // List<TableType> tableType = [];
  String? categoryValue;
  TextEditingController  oldPriceController = TextEditingController();
  TextEditingController  newPriceController = TextEditingController();
  TextEditingController  descriptionController = TextEditingController();
  TextEditingController  startController = TextEditingController();
  TextEditingController  endController = TextEditingController();

  void requestPermission(BuildContext context) async{
    return await showDialog<void>(
      context: context,
      // barrierDismissible: barrierDismissible, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  getFromGallery();
                },
                child: Container(
                  child: ListTile(
                      title:  Text("Gallery"),
                      leading: Icon(
                        Icons.image,
                        color: primary,
                      )),
                ),
              ),
              Container(
                width: 200,
                height: 1,
                color: Colors.black12,
              ),
              InkWell(
                onTap: () async {
                  getFromCamera();
                },
                child: Container(
                  child: ListTile(
                      title:  Text("Camera"),
                      leading: Icon(
                        Icons.camera,
                        color: primary,
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  // Future<void> getFromGallery() async {
  //   var result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //   if (result != null) {
  //     setState(() {
  //       tableImage = File(result.files.single.path.toString());
  //     });
  //     Navigator.pop(context);
  //
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  String _dateValue = '';
  var dateFormate;

  Future<Null> getProduct(String top) async {
    if (readProduct) {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        var parameter = {
          //CATID: widget.id ?? '',
          SellerId: CUR_USERID,
          SORT: sortBy,
          Order: orderBy,
          // LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
          TOP_RETAED: top,
          // FLAG: flag
        };
        // if (selId != null && selId != "") {
        //   parameter[AttributeValueIds] = selId;
        // }
        apiBaseHelper.postAPICall(getProductsApi, parameter).then(
              (getdata) async {
            bool error = getdata["error"];
            String? msg = getdata["message"];
            if (!error) {
              total = int.parse(getdata["total"]);

              if (_isFirstLoad) {
                // filterList = getdata["filters"];
                _isFirstLoad = false;
              }

              if ((offset) < total) {
                tempList.clear();
                tempList1.clear();
                var data = getdata["data"];
                tempList = (data as List)
                    .map((data) => new Product.fromJson(data))
                    .toList();
                tempList1 = (data as List)
                    .map((data) => new ProductModel.fromJson(data))
                    .toList();
                // getAvailVarient();

                // offset = offset + perPage;
              }
            } else {
              if (msg != "Products Not Found !")
                //setSnackbar(msg!);
                isLoadingmore = false;
            }
            if (mounted)
              setState(() {
                _isLoading = false;
              });
          },
          onError: (error) {
            // setSnackbar(error.toString());
            if (mounted)
              setState(
                    () {
                  _isLoading = false;
                  isLoadingmore = false;
                },
              );
          },
        );
      } else {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      }
    } else {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
      Future.delayed(Duration(microseconds: 500)).then((_) async {
        // setSnackbar('You have not authorized permission for read Product!!');
      });
    }
    return null;
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future _selectDate(String type) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        //firstDate: DateTime.now().subtract(Duration(days: 1)),
        // lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primary,
                accentColor: Colors.black,
                colorScheme: ColorScheme.light(primary: primary),
                // ColorScheme.light(primary: const Color(0xFFEB6C67)),
                buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (picked != null)
      setState(() {
        String yourDate = picked.toString();
        _dateValue = convertDateTimeDisplay(yourDate);
        print(_dateValue);
        dateFormate =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
      });
    if (type == "1") {
      setState(() {
        startController = TextEditingController(text: _dateValue);
      });
    } else {
      setState(() {
        endController = TextEditingController(text: _dateValue);
      });
    }
  }

  Future<void> getFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        tableImage = File(pickedFile.path.toString());
      });
      Navigator.pop(context);
    } else {

    }
  }


  // getTableTypes() async{
  //   CUR_USERID = await getPrefrence(Id);
  //   var headers = {
  //     'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(getTableTypesApi.toString()));
  //   request.fields.addAll({
  //     // UserId : CUR_USERID.toString()
  //   });
  //
  //   print("this is refer request ${request.fields.toString()}");
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     String str = await response.stream.bytesToString();
  //     var result = json.decode(str);
  //     var finalResponse = TableTypeModel.fromJson(result);
  //     setState(() {
  //       tableType = finalResponse.data!;
  //     });
  //     print("this is referral data ${tableType.length}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  updatePost() async{
    CUR_USERID = await getPrefrence(Id);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(updatePostsApi.toString()));
    request.fields.addAll({
      SellerId : CUR_USERID.toString(),
      'product_id': categoryValue.toString(),
      'text':descriptionController.text.toString(),
      'old_price':oldPriceController.text.toString(),
      'new_price': newPriceController.text.toString(),
      'start_date':selectedTab == 1 ?  startController.text.toString() : "",
      'end_date': selectedTab == 1 ? endController.text.toString() : "",
      'post_type': selectedTab.toString()

    });
    if (tableImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image[]', tableImage!.path));
    }

    print("this is refer request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      bool error  = result['error'];
      String msg = result['message'];
      if(!error) {
        // Fluttertoast.showToast(msg: msg);
        Navigator.pop(context, 'true');
      }else{

      }
      // var finalResponse = TableTypeModel.fromJson(result);
      // setState(() {
      //   tableType = finalResponse.data!;
      // });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  selectImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        tableImage = File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }
  var imagePathList;
  bool isImages = false;

  Future<void> getFromGallery() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        isImages = true;
        // servicePic = File(result.files.single.path.toString());
      });
      imagePathList = result.paths.toList();
      // imagePathList.add(result.paths.toString()).toList();
      print("SERVICE PIC === ${imagePathList.length}");
    } else {
      // User canceled the picker
    }
  }

  Widget uploadMultiImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () async {
              getFromGallery();
              // await pickImages();
            },
            child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primary),
                child: Center(
                    child: Text(
                      "Upload Pictures",
                      style: TextStyle(color: white),
                    )))),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: isImages,
            child: imagePathList != null ? buildGridView() : SizedBox.shrink()
        )

      ],
    );
  }

  Widget buildGridView() {
    return Container(
      height: 165,
      child: GridView.builder(
        itemCount: imagePathList.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height/2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.file(File(imagePathList[index]),
                          fit: BoxFit.cover),
                    ),
                  )),
              Positioned(
                top: 5,
                right: 10,
                child: InkWell(
                  onTap: (){
                    setState((){
                      imagePathList.remove(imagePathList[index]);
                    });

                  },
                  child: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: Colors.red.withOpacity(0.7),),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Table Image'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Click Image from Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile? pickedFile = await ImagePicker().getImage(
                    source: ImageSource.camera,
                    maxHeight: 240.0,
                    maxWidth: 240.0,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      tableImage = File(pickedFile.path);
                      imagePathList.add(tableImage);
                      // imagePath = File(pickedFile.path) ;
                      // filePath = imagePath!.path.toString();
                    });
                    print("profile pic from camera ${tableImage}");
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose image from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  //selectImage();
                  getFromGallery();
                  // setState(() {
                  //   // _file = file;Start
                  // });
                },
              ),
              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Choose Video from gallery'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),

              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Cancel'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        });
  }



  int selectedTab = 1 ;

  tabBarView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 10),
        child: Container(
          width: 242,
          decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(12),
            color: white,
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
                  width: 120,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    // border: Border.all(color: primary,),
                      color: selectedTab  == 1 ? primary : white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("Current Posts", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: selectedTab  == 1 ? white : primary,
                    ),),
                  ),
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
                  width: 120,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    // border: Border.all(color: primary,),
                      color: selectedTab  == 2 ? primary : white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("All Posts", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: selectedTab  == 2 ? white : primary,
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Exit"),
                    content: Text("Are you sure you want to exit?"),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primary
                        ),
                        child: Text("YES"),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primary
                        ),
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
            return true;
          },
          child:

          Scaffold(
            appBar: AppBar(
              title: Text("Edit Post", style: TextStyle(
                  color: primary
              ),),
              elevation: 5,
              titleSpacing: 0,
              iconTheme: IconThemeData(color: primary),
              backgroundColor: white,
              leading: Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: primary,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            body:
            SingleChildScrollView(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // tabBarView(),
                      tempList.isNotEmpty ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                            child: Text("Product", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primary
                            ),),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: primary)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text('Select Product'), // Not necessary for Option 1
                                value: categoryValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    categoryValue = newValue;
                                  });
                                  // tempList.forEach((element) {
                                  //   if(element.tableType == categoryValue){
                                  //     setState(() {
                                  //       tableAmountController.text = element.price!;
                                  //     });
                                  //   }
                                  // });
                                  //
                                  print("this is tbale selected value $categoryValue");
                                },
                                items: tempList.map((item) {
                                  return DropdownMenuItem(
                                    child:  Text(item.name!, style:TextStyle(color: Colors.black),),
                                    value: item.id,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                          : SizedBox.shrink(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                                  child: Text("Old Price", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primary
                                  ),),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 12, right: 8),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primary)
                                  ),
                                  width: MediaQuery.of(context).size.width/2-30,
                                  child: TextFormField(
                                    // enabled: false,
                                    style: TextStyle(color: Colors.black),
                                    controller: oldPriceController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        suffix: Text("₹"),
                                        counterText: '',
                                        border: InputBorder.none,
                                        hintText: "Old Price"
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,  bottom: 5),
                                  child: Text("New Price", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primary
                                  ),),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, left: 12, right: 8),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primary)
                                  ),
                                  width: MediaQuery.of(context).size.width/2-30,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    controller: newPriceController,
                                    decoration: InputDecoration(
                                        suffix: Text("₹"),
                                        counterText: '',
                                        border: InputBorder.none,
                                        hintText: "New Price"
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                        child: Text("Description", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primary
                        ),),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 80,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primary)
                        ),
                        width: MediaQuery.of(context).size.width-30,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          // maxLength: 10,
                          controller: descriptionController,
                          decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: "Description"
                          ),
                        ),
                      ),
                      selectedTab == 1 ?
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,  bottom: 5),
                                  child: Text("Start Date", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primary
                                  ),),
                                ),
                                Container(
                                  // padding: EdgeInsets.only(top: 10, left: 12, right: 8),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primary)
                                  ),
                                  width: MediaQuery.of(context).size.width/2-30,
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black54),
                                    readOnly: true,
                                    controller: startController,
                                    onTap: () {
                                      _selectDate("1");
                                    },
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        border: InputBorder.none,
                                        hintText: 'Start Date',
                                        hintStyle: TextStyle(color: Colors.black54)),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,  bottom: 5),
                                  child: Text("End Date", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primary
                                  ),),
                                ),
                                Container(
                                  // padding: EdgeInsets.only(top: 10, left: 12, right: 8),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primary)
                                  ),
                                  width: MediaQuery.of(context).size.width/2-30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      style: const TextStyle(color: Colors.black54),
                                      readOnly: true,
                                      controller: endController,
                                      onTap: () {
                                        _selectDate("2");
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        border: InputBorder.none,
                                        hintText: 'End Date',
                                        hintStyle: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          : SizedBox.shrink(),
                      ElevatedButton(
                          onPressed: (){
                            _selectImage(context);
                            // requestPermission(context);
                          },
                          style: ElevatedButton.styleFrom(primary: primary, shape: StadiumBorder()),
                          child: Text("Upload Images", style: TextStyle(
                              color: white
                          ),)),

                      tableImage == null ?
                      SizedBox.shrink():
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: FileImage(File(tableImage!.path)),
                                fit: BoxFit.fill
                              //AssetImage(Image.file(file)File(tableImage!.path)),
                            )
                        ),
                        width: MediaQuery.of(context).size.width/1.7,
                        height: MediaQuery.of(context).size.width/1.7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                        child: ElevatedButton(
                            onPressed: (){
                              if(selectedTab == 1){
                                if(oldPriceController.text.isNotEmpty && newPriceController.text.isNotEmpty && descriptionController.text.isNotEmpty ||
                                    startController.text.isNotEmpty && endController.text.isNotEmpty){
                                  updatePost();
                                }else{
                                  Fluttertoast.showToast(msg: "Please fill all details!");
                                }
                              }else{
                                if(oldPriceController.text.isNotEmpty && newPriceController.text.isNotEmpty && descriptionController.text.isNotEmpty ){
                                  updatePost();
                                }else{
                                  Fluttertoast.showToast(msg: "Please fill all details!");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: primary,
                                shape: StadiumBorder(),
                                // RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(15),
                                // ),
                                fixedSize: Size(MediaQuery.of(context).size.width - 40, 50)
                            ),
                            child: Text("Update Post", style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600,
                                color: white
                            ),)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      );
  }
}



