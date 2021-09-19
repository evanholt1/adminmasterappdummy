import 'package:admin_eshop/Helper/String.dart';
import 'package:intl/intl.dart';

class Order_Model {
  String? id,
      name,
      mobile,
      latitude,
      longitude,
      delCharge,
      walBal,
      promo,
      promoDis,
      payMethod,
      total,
      subTotal,
      payable,
      address,
      taxAmt,
      taxPer,
      orderDate,
      dateTime,
      isCancleable,
      isReturnable,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      activeStatus,
      otp,
      deliveryBoyId,
      delDate,
      delTime,
      countryCode;
  List<Attachment> attachList = [];
  String? invoice;
  List<OrderItem> itemList;
  List<String> listStatus = [];
  List<String> listDate = [];

  Order_Model(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.delCharge,
      required this.walBal,
      required this.promo,
      required this.promoDis,
      required this.payMethod,
      required this.total,
      required this.subTotal,
      required this.payable,
      required this.address,
      required this.taxPer,
      required this.taxAmt,
      required this.orderDate,
      required this.dateTime,
      required this.itemList,
      required this.listStatus,
      required this.listDate,
      required this.isReturnable,
      required this.isCancleable,
      required this.isAlrCancelled,
      required this.isAlrReturned,
      required this.rtnReqSubmitted,
      required this.activeStatus,
      required this.otp,
      this.invoice,
      required this.latitude,
      required this.longitude,
      required this.delDate,
      required this.delTime,
      required this.countryCode,
      required this.deliveryBoyId,
      required this.attachList});

  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    List<Attachment> attachmentList = [];
    var order = (parsedJson[ORDER_ITEMS] as List);
    // if (order == null || order.isEmpty)
    //   return null;
    // else
    itemList = order.map((data) => new OrderItem.fromJson(data)).toList();
    String date = parsedJson[DATE_ADDED];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    List<String> lStatus = [];
    List<String> lDate = [];

    var attachments = (parsedJson[ATTACHMENTS] as List);

    if (attachments == null || attachments.isEmpty)
      attachmentList = [];
    else
      attachmentList = attachments.map((data) => new Attachment.fromJson(data)).toList();

    var allSttus = parsedJson[STATUS];
    for (var curStatus in allSttus) {
      lStatus.add(curStatus[0]);
      lDate.add(curStatus[1]);
    }
    return new Order_Model(
        id: parsedJson[ID],
        name: parsedJson[USERNAME],
        mobile: parsedJson[MOBILE],
        delCharge: parsedJson[DEL_CHARGE],
        walBal: parsedJson[WAL_BAL],
        promo: parsedJson[PROMOCODE],
        promoDis: parsedJson[PROMO_DIS],
        payMethod: parsedJson[PAYMENT_METHOD],
        total: parsedJson[FINAL_TOTAL],
        subTotal: parsedJson[TOTAL],
        payable: parsedJson[TOTAL_PAYABLE],
        address: parsedJson[ADDRESS],
        taxAmt: parsedJson[TOTAL_TAX_AMT],
        taxPer: parsedJson[TOTAL_TAX_PER],
        dateTime: parsedJson[DATE_ADDED],
        isCancleable: parsedJson[ISCANCLEABLE],
        isReturnable: parsedJson[ISRETURNABLE],
        isAlrCancelled: parsedJson[ISALRCANCLE],
        isAlrReturned: parsedJson[ISALRRETURN],
        rtnReqSubmitted: parsedJson[ISRTNREQSUBMITTED],
        orderDate: date,
        itemList: itemList,
        listStatus: lStatus,
        listDate: lDate,
        activeStatus: parsedJson[ACTIVE_STATUS],
        otp: parsedJson[OTP],
        latitude: parsedJson[LATITUDE],
        countryCode: parsedJson[COUNTRY_CODE],
        longitude: parsedJson[LONGITUDE],
        delDate:
            parsedJson[DEL_DATE] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(parsedJson[DEL_DATE])) : '',
        delTime: parsedJson[DEL_TIME] != null ? parsedJson[DEL_TIME] : '',
        attachList: attachmentList,
        deliveryBoyId: parsedJson[DELIVERY_BOY_ID]);
  }
}

class OrderItem {
  String? id,
      name,
      qty,
      price,
      subTotal,
      status,
      image,
      varientId,
      isCancle,
      isReturn,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      varient_values,
      attr_name,
      productId,
      curSelected;

  List<String> listStatus = [];
  List<String> listDate = [];

  OrderItem(
      {required this.qty,
      required this.id,
      required this.name,
      required this.price,
      required this.subTotal,
      required this.status,
      required this.image,
      required this.varientId,
      required this.listDate,
      required this.listStatus,
      required this.isCancle,
      required this.isReturn,
      required this.isAlrReturned,
      required this.isAlrCancelled,
      required this.rtnReqSubmitted,
      required this.attr_name,
      required this.productId,
      required this.varient_values,
      required this.curSelected});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    List<String> lStatus = [];
    List<String> lDate = [];

    var allSttus = json[STATUS];
    for (var curStatus in allSttus) {
      lStatus.add(curStatus[0]);
      lDate.add(curStatus[1]);
    }
    return new OrderItem(
      id: json[ID],
      qty: json[QUANTITY],
      name: json[NAME],
      image: json[IMAGE],
      price: json[PRICE],
      subTotal: json[SUB_TOTAL],
      varientId: json[PRODUCT_VARIENT_ID],
      listStatus: lStatus,
      status: json[ACTIVE_STATUS],
      curSelected: json[ACTIVE_STATUS],
      listDate: lDate,
      isCancle: json[ISCANCLEABLE],
      isReturn: json[ISRETURNABLE],
      isAlrCancelled: json[ISALRCANCLE],
      isAlrReturned: json[ISALRRETURN],
      rtnReqSubmitted: json[ISRTNREQSUBMITTED],
      attr_name: json[ATTR_NAME],
      productId: json[PRODUCT_ID],
      varient_values: json[VARIENT_VALUE],
    );
  }
}

class Attachment {
  String id, attachment;

  Attachment({required this.id, required this.attachment});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(id: json[ID], attachment: json[ATTACHMENT]);
  }
}
