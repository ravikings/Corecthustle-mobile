class MessageModel {
    final int? id;
    final String? type;
    final int? fromId;
    final int? toId;
    final String? body;
    final dynamic attachment;
    final dynamic audioRecord;
    final dynamic quotationId;
    final dynamic customOfferId;
    final int? isAudio;
    final int? seen;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    MessageModel({
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

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        type: json["type"],
        fromId: json["from_id"],
        toId: json["to_id"],
        body: json["body"] == null ? json['message'] ?? "no message" : json['body'],
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
