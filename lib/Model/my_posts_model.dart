/// error : false
/// message : "Post fetched successfully"
/// data : [{"id":"3624","seller_id":"1281","product_id":"3624","text":"this is new description ","old_price":"1000","new_price":"800","create_at":"2023-06-06 18:39:22","image":"uploads/media/2023/image2.jpg","post_type":"1","start_date":"","end_date":"","product_identity":null,"category_id":"206","sub_category_id":"207","tax":"1","row_order":"0","type":"simple_product","stock_type":null,"name":"New Product","short_description":"Dummy description","slug":"new-product","indicator":null,"cod_allowed":"1","minimum_order_quantity":"1","quantity_step_size":"1","total_allowed_quantity":null,"is_prices_inclusive_tax":"0","is_returnable":"0","is_cancelable":"0","cancelable_till":null,"other_images":"[\"uploads\\/media\\/2023\\/image3.jpg\"]","video_type":"","video":"","tags":"","warranty_period":"","guarantee_period":"","made_in":null,"sku":null,"recommend_products":"0","stock":null,"availability":null,"rating":"0","no_of_ratings":"0","description":"<p>sfsf</p>","deliverable_type":"1","deliverable_zipcodes":null,"status":"1","date_added":"2023-04-15 17:46:03","container_price":"","images":["https://developmentalphawizz.com/mt/uploads/media/2023/uploads/media/2023/image2.jpg"]}]

class MyPostsModel {
  MyPostsModel({
      bool? error, 
      String? message, 
      List<MyPostsList>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  MyPostsModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MyPostsList.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<MyPostsList>? _data;
MyPostsModel copyWith({  bool? error,
  String? message,
  List<MyPostsList>? data,
}) => MyPostsModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<MyPostsList>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "3624"
/// seller_id : "1281"
/// product_id : "3624"
/// text : "this is new description "
/// old_price : "1000"
/// new_price : "800"
/// create_at : "2023-06-06 18:39:22"
/// image : "uploads/media/2023/image2.jpg"
/// post_type : "1"
/// start_date : ""
/// end_date : ""
/// product_identity : null
/// category_id : "206"
/// sub_category_id : "207"
/// tax : "1"
/// row_order : "0"
/// type : "simple_product"
/// stock_type : null
/// name : "New Product"
/// short_description : "Dummy description"
/// slug : "new-product"
/// indicator : null
/// cod_allowed : "1"
/// minimum_order_quantity : "1"
/// quantity_step_size : "1"
/// total_allowed_quantity : null
/// is_prices_inclusive_tax : "0"
/// is_returnable : "0"
/// is_cancelable : "0"
/// cancelable_till : null
/// other_images : "[\"uploads\\/media\\/2023\\/image3.jpg\"]"
/// video_type : ""
/// video : ""
/// tags : ""
/// warranty_period : ""
/// guarantee_period : ""
/// made_in : null
/// sku : null
/// recommend_products : "0"
/// stock : null
/// availability : null
/// rating : "0"
/// no_of_ratings : "0"
/// description : "<p>sfsf</p>"
/// deliverable_type : "1"
/// deliverable_zipcodes : null
/// status : "1"
/// date_added : "2023-04-15 17:46:03"
/// container_price : ""
/// images : ["https://developmentalphawizz.com/mt/uploads/media/2023/uploads/media/2023/image2.jpg"]

class MyPostsList {
  MyPostsList({
      String? id, 
      String? sellerId, 
      String? productId, 
      String? text, 
      String? oldPrice, 
      String? newPrice, 
      String? createAt, 
      String? image, 
      String? postType, 
      String? startDate, 
      String? endDate, 
      dynamic productIdentity, 
      String? categoryId, 
      String? subCategoryId, 
      String? tax, 
      String? rowOrder, 
      String? type, 
      dynamic stockType, 
      String? name, 
      String? shortDescription, 
      String? slug, 
      dynamic indicator, 
      String? codAllowed, 
      String? minimumOrderQuantity, 
      String? quantityStepSize, 
      dynamic totalAllowedQuantity, 
      String? isPricesInclusiveTax, 
      String? isReturnable, 
      String? isCancelable, 
      dynamic cancelableTill, 
      String? otherImages, 
      String? videoType, 
      String? video, 
      String? tags, 
      String? warrantyPeriod, 
      String? guaranteePeriod, 
      dynamic madeIn, 
      dynamic sku, 
      String? recommendProducts, 
      dynamic stock, 
      dynamic availability, 
      String? rating, 
      String? noOfRatings, 
      String? description, 
      String? deliverableType, 
      dynamic deliverableZipcodes, 
      String? status, 
      String? dateAdded, 
      String? containerPrice, 
      List<String>? images,}){
    _id = id;
    _sellerId = sellerId;
    _productId = productId;
    _text = text;
    _oldPrice = oldPrice;
    _newPrice = newPrice;
    _createAt = createAt;
    _image = image;
    _postType = postType;
    _startDate = startDate;
    _endDate = endDate;
    _productIdentity = productIdentity;
    _categoryId = categoryId;
    _subCategoryId = subCategoryId;
    _tax = tax;
    _rowOrder = rowOrder;
    _type = type;
    _stockType = stockType;
    _name = name;
    _shortDescription = shortDescription;
    _slug = slug;
    _indicator = indicator;
    _codAllowed = codAllowed;
    _minimumOrderQuantity = minimumOrderQuantity;
    _quantityStepSize = quantityStepSize;
    _totalAllowedQuantity = totalAllowedQuantity;
    _isPricesInclusiveTax = isPricesInclusiveTax;
    _isReturnable = isReturnable;
    _isCancelable = isCancelable;
    _cancelableTill = cancelableTill;
    _otherImages = otherImages;
    _videoType = videoType;
    _video = video;
    _tags = tags;
    _warrantyPeriod = warrantyPeriod;
    _guaranteePeriod = guaranteePeriod;
    _madeIn = madeIn;
    _sku = sku;
    _recommendProducts = recommendProducts;
    _stock = stock;
    _availability = availability;
    _rating = rating;
    _noOfRatings = noOfRatings;
    _description = description;
    _deliverableType = deliverableType;
    _deliverableZipcodes = deliverableZipcodes;
    _status = status;
    _dateAdded = dateAdded;
    _containerPrice = containerPrice;
    _images = images;
}

  MyPostsList.fromJson(dynamic json) {
    _id = json['id'];
    _sellerId = json['seller_id'];
    _productId = json['product_id'];
    _text = json['text'];
    _oldPrice = json['old_price'];
    _newPrice = json['new_price'];
    _createAt = json['create_at'];
    _image = json['image'];
    _postType = json['post_type'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _productIdentity = json['product_identity'];
    _categoryId = json['category_id'];
    _subCategoryId = json['sub_category_id'];
    _tax = json['tax'];
    _rowOrder = json['row_order'];
    _type = json['type'];
    _stockType = json['stock_type'];
    _name = json['name'];
    _shortDescription = json['short_description'];
    _slug = json['slug'];
    _indicator = json['indicator'];
    _codAllowed = json['cod_allowed'];
    _minimumOrderQuantity = json['minimum_order_quantity'];
    _quantityStepSize = json['quantity_step_size'];
    _totalAllowedQuantity = json['total_allowed_quantity'];
    _isPricesInclusiveTax = json['is_prices_inclusive_tax'];
    _isReturnable = json['is_returnable'];
    _isCancelable = json['is_cancelable'];
    _cancelableTill = json['cancelable_till'];
    _otherImages = json['other_images'];
    _videoType = json['video_type'];
    _video = json['video'];
    _tags = json['tags'];
    _warrantyPeriod = json['warranty_period'];
    _guaranteePeriod = json['guarantee_period'];
    _madeIn = json['made_in'];
    _sku = json['sku'];
    _recommendProducts = json['recommend_products'];
    _stock = json['stock'];
    _availability = json['availability'];
    _rating = json['rating'];
    _noOfRatings = json['no_of_ratings'];
    _description = json['description'];
    _deliverableType = json['deliverable_type'];
    _deliverableZipcodes = json['deliverable_zipcodes'];
    _status = json['status'];
    _dateAdded = json['date_added'];
    _containerPrice = json['container_price'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
  }
  String? _id;
  String? _sellerId;
  String? _productId;
  String? _text;
  String? _oldPrice;
  String? _newPrice;
  String? _createAt;
  String? _image;
  String? _postType;
  String? _startDate;
  String? _endDate;
  dynamic _productIdentity;
  String? _categoryId;
  String? _subCategoryId;
  String? _tax;
  String? _rowOrder;
  String? _type;
  dynamic _stockType;
  String? _name;
  String? _shortDescription;
  String? _slug;
  dynamic _indicator;
  String? _codAllowed;
  String? _minimumOrderQuantity;
  String? _quantityStepSize;
  dynamic _totalAllowedQuantity;
  String? _isPricesInclusiveTax;
  String? _isReturnable;
  String? _isCancelable;
  dynamic _cancelableTill;
  String? _otherImages;
  String? _videoType;
  String? _video;
  String? _tags;
  String? _warrantyPeriod;
  String? _guaranteePeriod;
  dynamic _madeIn;
  dynamic _sku;
  String? _recommendProducts;
  dynamic _stock;
  dynamic _availability;
  String? _rating;
  String? _noOfRatings;
  String? _description;
  String? _deliverableType;
  dynamic _deliverableZipcodes;
  String? _status;
  String? _dateAdded;
  String? _containerPrice;
  List<String>? _images;
MyPostsList copyWith({  String? id,
  String? sellerId,
  String? productId,
  String? text,
  String? oldPrice,
  String? newPrice,
  String? createAt,
  String? image,
  String? postType,
  String? startDate,
  String? endDate,
  dynamic productIdentity,
  String? categoryId,
  String? subCategoryId,
  String? tax,
  String? rowOrder,
  String? type,
  dynamic stockType,
  String? name,
  String? shortDescription,
  String? slug,
  dynamic indicator,
  String? codAllowed,
  String? minimumOrderQuantity,
  String? quantityStepSize,
  dynamic totalAllowedQuantity,
  String? isPricesInclusiveTax,
  String? isReturnable,
  String? isCancelable,
  dynamic cancelableTill,
  String? otherImages,
  String? videoType,
  String? video,
  String? tags,
  String? warrantyPeriod,
  String? guaranteePeriod,
  dynamic madeIn,
  dynamic sku,
  String? recommendProducts,
  dynamic stock,
  dynamic availability,
  String? rating,
  String? noOfRatings,
  String? description,
  String? deliverableType,
  dynamic deliverableZipcodes,
  String? status,
  String? dateAdded,
  String? containerPrice,
  List<String>? images,
}) => MyPostsList(  id: id ?? _id,
  sellerId: sellerId ?? _sellerId,
  productId: productId ?? _productId,
  text: text ?? _text,
  oldPrice: oldPrice ?? _oldPrice,
  newPrice: newPrice ?? _newPrice,
  createAt: createAt ?? _createAt,
  image: image ?? _image,
  postType: postType ?? _postType,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  productIdentity: productIdentity ?? _productIdentity,
  categoryId: categoryId ?? _categoryId,
  subCategoryId: subCategoryId ?? _subCategoryId,
  tax: tax ?? _tax,
  rowOrder: rowOrder ?? _rowOrder,
  type: type ?? _type,
  stockType: stockType ?? _stockType,
  name: name ?? _name,
  shortDescription: shortDescription ?? _shortDescription,
  slug: slug ?? _slug,
  indicator: indicator ?? _indicator,
  codAllowed: codAllowed ?? _codAllowed,
  minimumOrderQuantity: minimumOrderQuantity ?? _minimumOrderQuantity,
  quantityStepSize: quantityStepSize ?? _quantityStepSize,
  totalAllowedQuantity: totalAllowedQuantity ?? _totalAllowedQuantity,
  isPricesInclusiveTax: isPricesInclusiveTax ?? _isPricesInclusiveTax,
  isReturnable: isReturnable ?? _isReturnable,
  isCancelable: isCancelable ?? _isCancelable,
  cancelableTill: cancelableTill ?? _cancelableTill,
  otherImages: otherImages ?? _otherImages,
  videoType: videoType ?? _videoType,
  video: video ?? _video,
  tags: tags ?? _tags,
  warrantyPeriod: warrantyPeriod ?? _warrantyPeriod,
  guaranteePeriod: guaranteePeriod ?? _guaranteePeriod,
  madeIn: madeIn ?? _madeIn,
  sku: sku ?? _sku,
  recommendProducts: recommendProducts ?? _recommendProducts,
  stock: stock ?? _stock,
  availability: availability ?? _availability,
  rating: rating ?? _rating,
  noOfRatings: noOfRatings ?? _noOfRatings,
  description: description ?? _description,
  deliverableType: deliverableType ?? _deliverableType,
  deliverableZipcodes: deliverableZipcodes ?? _deliverableZipcodes,
  status: status ?? _status,
  dateAdded: dateAdded ?? _dateAdded,
  containerPrice: containerPrice ?? _containerPrice,
  images: images ?? _images,
);
  String? get id => _id;
  String? get sellerId => _sellerId;
  String? get productId => _productId;
  String? get text => _text;
  String? get oldPrice => _oldPrice;
  String? get newPrice => _newPrice;
  String? get createAt => _createAt;
  String? get image => _image;
  String? get postType => _postType;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  dynamic get productIdentity => _productIdentity;
  String? get categoryId => _categoryId;
  String? get subCategoryId => _subCategoryId;
  String? get tax => _tax;
  String? get rowOrder => _rowOrder;
  String? get type => _type;
  dynamic get stockType => _stockType;
  String? get name => _name;
  String? get shortDescription => _shortDescription;
  String? get slug => _slug;
  dynamic get indicator => _indicator;
  String? get codAllowed => _codAllowed;
  String? get minimumOrderQuantity => _minimumOrderQuantity;
  String? get quantityStepSize => _quantityStepSize;
  dynamic get totalAllowedQuantity => _totalAllowedQuantity;
  String? get isPricesInclusiveTax => _isPricesInclusiveTax;
  String? get isReturnable => _isReturnable;
  String? get isCancelable => _isCancelable;
  dynamic get cancelableTill => _cancelableTill;
  String? get otherImages => _otherImages;
  String? get videoType => _videoType;
  String? get video => _video;
  String? get tags => _tags;
  String? get warrantyPeriod => _warrantyPeriod;
  String? get guaranteePeriod => _guaranteePeriod;
  dynamic get madeIn => _madeIn;
  dynamic get sku => _sku;
  String? get recommendProducts => _recommendProducts;
  dynamic get stock => _stock;
  dynamic get availability => _availability;
  String? get rating => _rating;
  String? get noOfRatings => _noOfRatings;
  String? get description => _description;
  String? get deliverableType => _deliverableType;
  dynamic get deliverableZipcodes => _deliverableZipcodes;
  String? get status => _status;
  String? get dateAdded => _dateAdded;
  String? get containerPrice => _containerPrice;
  List<String>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['seller_id'] = _sellerId;
    map['product_id'] = _productId;
    map['text'] = _text;
    map['old_price'] = _oldPrice;
    map['new_price'] = _newPrice;
    map['create_at'] = _createAt;
    map['image'] = _image;
    map['post_type'] = _postType;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['product_identity'] = _productIdentity;
    map['category_id'] = _categoryId;
    map['sub_category_id'] = _subCategoryId;
    map['tax'] = _tax;
    map['row_order'] = _rowOrder;
    map['type'] = _type;
    map['stock_type'] = _stockType;
    map['name'] = _name;
    map['short_description'] = _shortDescription;
    map['slug'] = _slug;
    map['indicator'] = _indicator;
    map['cod_allowed'] = _codAllowed;
    map['minimum_order_quantity'] = _minimumOrderQuantity;
    map['quantity_step_size'] = _quantityStepSize;
    map['total_allowed_quantity'] = _totalAllowedQuantity;
    map['is_prices_inclusive_tax'] = _isPricesInclusiveTax;
    map['is_returnable'] = _isReturnable;
    map['is_cancelable'] = _isCancelable;
    map['cancelable_till'] = _cancelableTill;
    map['other_images'] = _otherImages;
    map['video_type'] = _videoType;
    map['video'] = _video;
    map['tags'] = _tags;
    map['warranty_period'] = _warrantyPeriod;
    map['guarantee_period'] = _guaranteePeriod;
    map['made_in'] = _madeIn;
    map['sku'] = _sku;
    map['recommend_products'] = _recommendProducts;
    map['stock'] = _stock;
    map['availability'] = _availability;
    map['rating'] = _rating;
    map['no_of_ratings'] = _noOfRatings;
    map['description'] = _description;
    map['deliverable_type'] = _deliverableType;
    map['deliverable_zipcodes'] = _deliverableZipcodes;
    map['status'] = _status;
    map['date_added'] = _dateAdded;
    map['container_price'] = _containerPrice;
    map['images'] = _images;
    return map;
  }

}