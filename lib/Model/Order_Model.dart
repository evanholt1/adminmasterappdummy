import 'package:intl/intl.dart';
import 'package:admin_eshop/Helper/String.dart';

class Order_Model {
  String id,
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
      invoice,
      delDate,
      delTime,
      countryCode;
  List<Attachment> attachList = [];

  List<OrderItem> itemList;
  List<String> listStatus = [];
  List<String> listDate = [];

  Order_Model(
      {this.id,
      this.name,
      this.mobile,
      this.delCharge,
      this.walBal,
      this.promo,
      this.promoDis,
      this.payMethod,
      this.total,
      this.subTotal,
      this.payable,
      this.address,
      this.taxPer,
      this.taxAmt,
      this.orderDate,
      this.dateTime,
      this.itemList,
      this.listStatus,
      this.listDate,
      this.isReturnable,
      this.isCancleable,
      this.isAlrCancelled,
      this.isAlrReturned,
      this.rtnReqSubmitted,
      this.activeStatus,
      this.otp,
      this.invoice,
      this.latitude,
      this.longitude,
      this.delDate,
      this.delTime,
      this.countryCode,
      this.deliveryBoyId,
      this.attachList});

  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    List<Attachment> attachmentList = [];
    var order = (parsedJson[ORDER_ITEMS] as List);
    if (order == null || order.isEmpty)
      return null;
    else
      itemList = order.map((data) => new OrderItem.fromJson(data)).toList();
    String date = parsedJson[DATE_ADDED];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    List<String> lStatus = [];
    List<String> lDate = [];

    var attachments = (parsedJson[ATTACHMENTS] as List);

    if (attachments == null || attachments.isEmpty)
      attachmentList = [];
    else
      attachmentList =
          attachments.map((data) => new Attachment.fromJson(data)).toList();

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
        delDate: parsedJson[DEL_DATE] != null
            ? DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(parsedJson[DEL_DATE]))
            : '',
        delTime: parsedJson[DEL_TIME] != null ? parsedJson[DEL_TIME] : '',
        attachList: attachmentList,
        deliveryBoyId: parsedJson[DELIVERY_BOY_ID]);
  }
}

class OrderItem {
  String id,
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
      {this.qty,
      this.id,
      this.name,
      this.price,
      this.subTotal,
      this.status,
      this.image,
      this.varientId,
      this.listDate,
      this.listStatus,
      this.isCancle,
      this.isReturn,
      this.isAlrReturned,
      this.isAlrCancelled,
      this.rtnReqSubmitted,
      this.attr_name,
      this.productId,
      this.varient_values,
      this.curSelected});

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

  Attachment({this.id, this.attachment});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(id: json[ID], attachment: json[ATTACHMENT]);
  }
}
