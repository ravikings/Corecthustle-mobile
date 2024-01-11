class ChatQuoteModel {
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
    List<Item>? items;

    ChatQuoteModel({
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
        this.items,
    });

    factory ChatQuoteModel.fromJson(Map<String, dynamic> json) => ChatQuoteModel(
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
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
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
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    int? id;
    int? userId;
    int? quotationId;
    String? description;
    int? quantity;
    String? price;
    String? discount;
    String? totalPrice;
    DateTime? createdAt;
    DateTime? updatedAt;

    Item({
        this.id,
        this.userId,
        this.quotationId,
        this.description,
        this.quantity,
        this.price,
        this.discount,
        this.totalPrice,
        this.createdAt,
        this.updatedAt,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        userId: json["user_id"],
        quotationId: json["quotation_id"],
        description: json["description"],
        quantity: json["quantity"],
        price: json["price"],
        discount: json["discount"],
        totalPrice: json["total_price"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "quotation_id": quotationId,
        "description": description,
        "quantity": quantity,
        "price": price,
        "discount": discount,
        "total_price": totalPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
