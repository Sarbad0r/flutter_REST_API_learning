class Contact {
  int? id;
  String? name;
  String? email;
  String? subject;
  String? message;
  String? token;
  Contact({this.id, this.name, this.email, this.subject, this.message, this.token});
  
  
  factory Contact.fromJson(Map<String, dynamic> json){
    return Contact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      subject: json['subject'],
      message: json['message']
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "name":name,
      "email":email,
      "subject":subject,
      "message": message,
    };
  }
}
