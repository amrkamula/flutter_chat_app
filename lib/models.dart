class Message{
  String time;
  String senderId;
  String content;
  String senderMail;
  int messageId;
  bool isImage;

  Message({required this.isImage,required this.senderId,required this.content,required this.time,required this.senderMail,required this.messageId});
}