class Message {
  String? mId;
  String? senderId;
  String? recieverId;
  String? text;
  int? time;
  bool? isMy;

  get getIsMy => this.isMy;

  set setIsMy(isMy) => this.isMy = isMy;

  get getTime => this.time;
  set setTime(time) => this.time = time;
  get getMId => this.mId;

  set setMId(mId) => this.mId = mId;

  get getSenderId => this.senderId;

  set setSenderId(senderId) => this.senderId = senderId;

  get getRecieverId => this.recieverId;

  set setRecieverId(recieverId) => this.recieverId = recieverId;

  get getText => this.text;

  set setText(text) => this.text = text;

  Message(String mId, String senderId, String recieverId, String text, int time,
      bool isMy) {
    this.mId = mId;
    this.senderId = senderId;
    this.recieverId = recieverId;
    this.text = text;
    this.time = time;
    this.isMy = isMy;
  }
}
