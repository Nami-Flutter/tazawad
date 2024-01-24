class MembershipModel {
  int? membershipId;
  String? membershipName;
  String? details;
  bool? isMember;
  String? memberExpiry;
  String? planType;
  String? planPrice;
  String? planDuration;

  MembershipModel(
      {this.membershipId,
      this.membershipName,
      this.details,
      this.isMember,
      this.memberExpiry,
      this.planType,
      this.planPrice,
      this.planDuration});

  MembershipModel.fromJson(Map<String, dynamic> json) {
    membershipId = json['membership_id'];
    membershipName = json['membership_name'];
    details = json['details'];
    isMember = json['is_member'];
    memberExpiry = json['member_expiry'];
    planType = json['plan_type'];
    planPrice = json['plan_price'];
    planDuration = json['plan_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_id'] = this.membershipId;
    data['membership_name'] = this.membershipName;
    data['details'] = this.details;
    data['is_member'] = this.isMember;
    data['member_expiry'] = this.memberExpiry;
    data['plan_type'] = this.planType;
    data['plan_price'] = this.planPrice;
    data['plan_duration'] = this.planDuration;
    return data;
  }
}
