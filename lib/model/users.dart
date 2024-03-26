class Users{
  String? displayName;
  String? email;
  String? photoURL;
  String? address;
  int? phoneNumber;


  Users(
      { this.displayName,  this.email, this.photoURL,this.address,this.phoneNumber});
Users.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    photoURL = json['photoURl'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['photoURL'] = this.photoURL;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;


    
    return data;
  }
  
}
