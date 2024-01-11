
class UserModel {
    final int? id;
    final String? uid;
    final String? username;
    final String? email;
    final DateTime? emailVerifiedAt;
    final String? accountType;
    final dynamic referralCode;
    final dynamic avatarId;
    final int? levelId;
    final bool? isSupport;
    final dynamic providerName;
    final dynamic providerId;
    final dynamic fullname;
    final String? firstName;
    final String? lastName;
    final dynamic otherName;
    final dynamic headline;
    final dynamic description;
    final String? status;
    final String? balanceNet;
    final String? balanceWithdrawn;
    final String? balancePurchases;
    final String? balancePending;
    final String? balanceAvailable;
    final dynamic customerCode;
    final dynamic accountNumber;
    final dynamic accountName;
    final dynamic bankName;
    final int? freeTransfers;
    final String? referralBalance;
    final dynamic deletedAt;
    final dynamic lastActivity;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? countryId;
    final int? stateId;
    final dynamic city;
    final dynamic postCode;
    final dynamic address;
    final dynamic localGovernmentZone;
    final bool? activeStatus;

    UserModel({
        this.id,
        this.uid,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.accountType,
        this.referralCode,
        this.avatarId,
        this.levelId,
        this.isSupport,
        this.providerName,
        this.providerId,
        this.fullname,
        this.firstName,
        this.lastName,
        this.otherName,
        this.headline,
        this.description,
        this.status,
        this.balanceNet,
        this.balanceWithdrawn,
        this.balancePurchases,
        this.balancePending,
        this.balanceAvailable,
        this.customerCode,
        this.accountNumber,
        this.accountName,
        this.bankName,
        this.freeTransfers,
        this.referralBalance,
        this.deletedAt,
        this.lastActivity,
        this.createdAt,
        this.updatedAt,
        this.countryId,
        this.stateId,
        this.city,
        this.postCode,
        this.address,
        this.localGovernmentZone,
        this.activeStatus,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        accountType: json["account_type"],
        referralCode: json["referral_code"],
        avatarId: json["avatar_id"],
        levelId: json["level_id"],
        isSupport: json["is_support"],
        providerName: json["provider_name"],
        providerId: json["provider_id"],
        fullname: json["fullname"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        otherName: json["other_name"],
        headline: json["headline"],
        description: json["description"],
        status: json["status"],
        balanceNet: json["balance_net"],
        balanceWithdrawn: json["balance_withdrawn"],
        balancePurchases: json["balance_purchases"],
        balancePending: json["balance_pending"],
        balanceAvailable: json["balance_available"],
        customerCode: json["customer_code"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        bankName: json["bank_name"],
        freeTransfers: json["free_transfers"],
        referralBalance: json["referral_balance"],
        deletedAt: json["deleted_at"],
        lastActivity: json["last_activity"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        countryId: json["country_id"],
        stateId: json["state_id"],
        city: json["city"],
        postCode: json["post_code"],
        address: json["address"],
        localGovernmentZone: json["local_government_zone"],
        activeStatus: json["active_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "account_type": accountType,
        "referral_code": referralCode,
        "avatar_id": avatarId,
        "level_id": levelId,
        "is_support": isSupport,
        "provider_name": providerName,
        "provider_id": providerId,
        "fullname": fullname,
        "first_name": firstName,
        "last_name": lastName,
        "other_name": otherName,
        "headline": headline,
        "description": description,
        "status": status,
        "balance_net": balanceNet,
        "balance_withdrawn": balanceWithdrawn,
        "balance_purchases": balancePurchases,
        "balance_pending": balancePending,
        "balance_available": balanceAvailable,
        "customer_code": customerCode,
        "account_number": accountNumber,
        "account_name": accountName,
        "bank_name": bankName,
        "free_transfers": freeTransfers,
        "referral_balance": referralBalance,
        "deleted_at": deletedAt,
        "last_activity": lastActivity,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "country_id": countryId,
        "state_id": stateId,
        "city": city,
        "post_code": postCode,
        "address": address,
        "local_government_zone": localGovernmentZone,
        "active_status": activeStatus,
    };
}
