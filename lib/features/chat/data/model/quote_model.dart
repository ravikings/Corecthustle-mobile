// To parse this JSON data, do
//
//     final quoteModel = quoteModelFromJson(jsonString);

import 'dart:convert';

QuoteModel quoteModelFromJson(String str) => QuoteModel.fromJson(json.decode(str));

String quoteModelToJson(QuoteModel data) => json.encode(data.toJson());

class QuoteModel {
    int? id;
    int? userId;
    int? customerId;
    int? orderId;
    String? paymentMethod;
    DateTime? quoteDate;
    dynamic recurType;
    String? reference;
    int? isDraft;
    bool? isApproved;
    bool? paid;
    bool? canWallet;
    int? inWallet;
    String? total;
    DateTime? expiresAt;
    dynamic approvedAt;
    String? totalDiscount;
    String? totalTax;
    String? totalQuantity;
    String? profitValue;
    String? commissionValue;
    dynamic signatureImage;
    String? note;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? firstName;
    String? lastName;

    QuoteModel({
        this.id,
        this.userId,
        this.customerId,
        this.orderId,
        this.paymentMethod,
        this.quoteDate,
        this.recurType,
        this.reference,
        this.isDraft,
        this.isApproved,
        this.paid,
        this.canWallet,
        this.inWallet,
        this.total,
        this.expiresAt,
        this.approvedAt,
        this.totalDiscount,
        this.totalTax,
        this.totalQuantity,
        this.profitValue,
        this.commissionValue,
        this.signatureImage,
        this.note,
        this.createdAt,
        this.updatedAt,
        this.firstName,
        this.lastName,
    });

    factory QuoteModel.fromJson(Map<String, dynamic> json) => QuoteModel(
        id: json["id"],
        userId: json["user_id"],
        customerId: json["customer_id"],
        orderId: json["order_id"],
        paymentMethod: json["payment_method"],
        quoteDate: json["quote_date"] == null ? null : DateTime.parse(json["quote_date"]),
        recurType: json["recur_type"],
        reference: json["reference"],
        isDraft: json["is_draft"],
        isApproved: json["is_approved"],
        paid: json["paid"],
        canWallet: json["can_wallet"],
        inWallet: json["in_wallet"],
        total: json["total"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        approvedAt: json["approved_at"],
        totalDiscount: json["total_discount"],
        totalTax: json["total_tax"],
        totalQuantity: json["total_quantity"],
        profitValue: json["profit_value"],
        commissionValue: json["commission_value"],
        signatureImage: json["signature_image"],
        note: json["note"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "customer_id": customerId,
        "order_id": orderId,
        "payment_method": paymentMethod,
        "quote_date": quoteDate?.toIso8601String(),
        "recur_type": recurType,
        "reference": reference,
        "is_draft": isDraft,
        "is_approved": isApproved,
        "paid": paid,
        "can_wallet": canWallet,
        "in_wallet": inWallet,
        "total": total,
        "expires_at": expiresAt?.toIso8601String(),
        "approved_at": approvedAt,
        "total_discount": totalDiscount,
        "total_tax": totalTax,
        "total_quantity": totalQuantity,
        "profit_value": profitValue,
        "commission_value": commissionValue,
        "signature_image": signatureImage,
        "note": note,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
    };
}
