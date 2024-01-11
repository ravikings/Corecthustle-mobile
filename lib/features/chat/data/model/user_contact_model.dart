import 'package:correct_hustle/features/chat/data/model/chat_message_model.dart';

class UserContactModel {
    User? user;
    MessageModel? lastMessage;
    int? unseenCounter;

    UserContactModel({
        this.user,
        this.lastMessage,
        this.unseenCounter,
    });

    factory UserContactModel.fromJson(Map<String, dynamic> json) => UserContactModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        lastMessage: json["lastMessage"] == null ? null : MessageModel.fromJson(json["lastMessage"]),
        unseenCounter: json["unseenCounter"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "lastMessage": lastMessage?.toJson(),
        "unseenCounter": unseenCounter,
    };
}

class LastMessage {
    int? id;
    String? type;
    int? fromId;
    int? toId;
    String? body;
    dynamic attachment;
    String? audioRecord;
    dynamic quotationId;
    dynamic customOfferId;
    int? isAudio;
    int? seen;
    DateTime? createdAt;
    DateTime? updatedAt;

    LastMessage({
        this.id,
        this.type,
        this.fromId,
        this.toId,
        this.body,
        this.attachment,
        this.audioRecord,
        this.quotationId,
        this.customOfferId,
        this.isAudio,
        this.seen,
        this.createdAt,
        this.updatedAt,
    });

    factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        type: json["type"],
        fromId: json["from_id"],
        toId: json["to_id"],
        body: json["body"],
        attachment: json["attachment"],
        audioRecord: json["audio_record"],
        quotationId: json["quotation_id"],
        customOfferId: json["custom_offer_id"],
        isAudio: json["is_audio"],
        seen: json["seen"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "from_id": fromId,
        "to_id": toId,
        "body": body,
        "attachment": attachment,
        "audio_record": audioRecord,
        "quotation_id": quotationId,
        "custom_offer_id": customOfferId,
        "is_audio": isAudio,
        "seen": seen,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class User {
    int? id;
    String? uid;
    String? username;
    String? email;
    DateTime? emailVerifiedAt;
    String? password;
    String? accountType;
    String? referralCode;
    dynamic avatarId;
    int? levelId;
    int? isSupport;
    dynamic providerName;
    dynamic providerId;
    dynamic fullname;
    String? firstName;
    String? lastName;
    dynamic otherName;
    dynamic headline;
    dynamic description;
    String? status;
    String? balanceNet;
    String? balanceWithdrawn;
    String? balancePurchases;
    String? balancePending;
    String? balanceAvailable;
    dynamic customerCode;
    dynamic accountNumber;
    dynamic accountName;
    dynamic bankName;
    int? freeTransfers;
    String? referralBalance;
    String? rememberToken;
    dynamic deletedAt;
    dynamic lastActivity;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic countryId;
    dynamic stateId;
    dynamic city;
    dynamic postCode;
    dynamic address;
    dynamic localGovernmentZone;
    int? activeStatus;
    DateTime? maxCreatedAt;

    User({
        this.id,
        this.uid,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.password,
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
        this.rememberToken,
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
        this.maxCreatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        password: json["password"],
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
        rememberToken: json["remember_token"],
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
        maxCreatedAt: json["max_created_at"] == null ? null : DateTime.parse(json["max_created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "password": password,
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
        "remember_token": rememberToken,
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
        "max_created_at": maxCreatedAt?.toIso8601String(),
    };
}
