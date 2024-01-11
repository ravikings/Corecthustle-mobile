class OtherUserInfoModel {
    final bool? favorite;
    final Fetch? fetch;
    final String? userAvatar;

    OtherUserInfoModel({
        this.favorite,
        this.fetch,
        this.userAvatar,
    });

    factory OtherUserInfoModel.fromJson(Map<String, dynamic> json) => OtherUserInfoModel(
        favorite: json["favorite"],
        fetch: json["fetch"] == null ? null : Fetch.fromJson(json["fetch"]),
        userAvatar: json["user_avatar"],
    );

    Map<String, dynamic> toJson() => {
        "favorite": favorite,
        "fetch": fetch?.toJson(),
        "user_avatar": userAvatar,
    };
}

class Fetch {
    final int? id;
    final String? uid;
    final String? username;
    final String? firstName;
    final String? lastName;
    final dynamic avatarId;
    final bool? activeStatus;
    final bool? isSupport;
    final String? avatarSrc;
    final dynamic avatar;

    Fetch({
        this.id,
        this.uid,
        this.username,
        this.firstName,
        this.lastName,
        this.avatarId,
        this.activeStatus,
        this.isSupport,
        this.avatarSrc,
        this.avatar,
    });

    factory Fetch.fromJson(Map<String, dynamic> json) => Fetch(
        id: json["id"],
        uid: json["uid"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatarId: json["avatar_id"],
        activeStatus: json["active_status"],
        isSupport: json["is_support"],
        avatarSrc: json["avatar_src"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "avatar_id": avatarId,
        "active_status": activeStatus,
        "is_support": isSupport,
        "avatar_src": avatarSrc,
        "avatar": avatar,
    };
}
