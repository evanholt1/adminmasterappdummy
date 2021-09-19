import 'package:intl/intl.dart';

import '../Helper/String.dart';

class Model {
  String id, title;
  String? type, typeId, image, fromTime, lastTime, desc, status, email, date, msg, name, banner, uid;
  var list;
  List<attachment>? attach;
  Model(
      {required this.id,
      this.type,
      this.typeId,
      this.image,
      this.name,
      this.banner,
      this.list,
      required this.title,
      this.fromTime,
      this.desc,
      this.email,
      this.status,
      this.lastTime,
      this.msg,
      this.attach,
      this.uid,
      this.date});

  factory Model.fromTicket(Map<String, dynamic> parsedJson) {
    String date = parsedJson[DATE_CREATED];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    return new Model(
        id: parsedJson[ID],
        title: parsedJson[SUB],
        desc: parsedJson[DESC],
        typeId: parsedJson[TICKET_TYPE],
        email: parsedJson[EMAIL],
        status: parsedJson[STATUS],
        date: date,
        type: parsedJson[TIC_TYPE]);
  }

  factory Model.fromSupport(Map<String, dynamic> parsedJson) {
    return new Model(
      id: parsedJson[ID],
      title: parsedJson[TITLE],
    );
  }

  factory Model.fromChat(Map<String, dynamic> parsedJson) {
    //var listContent = parsedJson["attachments"];

    List<attachment> attachList;
    var listContent = (parsedJson["attachments"] as List);
    if (listContent == null || listContent.isEmpty)
      attachList = [];
    else
      attachList = listContent.map((data) => new attachment.setJson(data)).toList();

    String date = parsedJson[DATE_CREATED];

    date = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(date));
    return new Model(
        id: parsedJson[ID],
        title: parsedJson[TITLE],
        msg: parsedJson[MESSAGE],
        uid: parsedJson[USER_ID],
        name: parsedJson[NAME],
        date: date,
        attach: attachList);
  }
}

class attachment {
  String media, type;

  attachment({required this.media, required this.type});

  factory attachment.setJson(Map<String, dynamic> parsedJson) {
    return new attachment(
      media: parsedJson[MEDIA],
      type: parsedJson[ICON],
    );
  }
}
