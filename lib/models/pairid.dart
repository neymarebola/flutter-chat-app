class PairId {
  String? senderId;
  String? receiverId;
  get getSenderId => this.senderId;

  set setSenderId(senderId) => this.senderId = senderId;

  get getReceiverId => this.receiverId;

  set setReceiverId(receiverId) => this.receiverId = receiverId;

  PairId(String senderId, String receiverId) {
    this.senderId = senderId;
    this.receiverId = receiverId;
  }
}
