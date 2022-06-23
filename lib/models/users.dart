class User {
  String id;
  String username;
  String email;
  AddressDetail address;
  String phone;
  String website;
  CompanyDetail company;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"].toString(),
      username: map["username"].toString(),
      email: map["email"].toString(),
      phone: map["phone"].toString(),
      website: map["website"].toString(),
      address: map["address"],
      company: map["geo"],
    );
  }
}

class AddressDetail {
  String street;
  String suite;
  String city;
  String zipcode;
  GeoDetail geo;

  AddressDetail({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory AddressDetail.fromJson(Map<String, dynamic> map) {
    return AddressDetail(
      street: map["street"].toString(),
      suite: map["suite"].toString(),
      city: map["city"].toString(),
      zipcode: map["zipcode"].toString(),
      geo: map["geo"],
    );
  }
}

class GeoDetail {
  String lat;
  String lng;

  GeoDetail({required this.lat, required this.lng});

  factory GeoDetail.fromJson(Map<String, dynamic> map) {
    return GeoDetail(
      lat: map["lat"].toString(),
      lng: map["lng"].toString(),
    );
  }
}

class CompanyDetail {
  String name;
  String catchPhrase;
  String bs;

  CompanyDetail({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyDetail.fromJson(Map<String, dynamic> map) {
    return CompanyDetail(
      name: map["name"].toString(),
      catchPhrase: map["catchPhrase"].toString(),
      bs: map["bs"].toString(),
    );
  }
}
