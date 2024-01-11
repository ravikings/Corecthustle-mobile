// To parse this JSON data, do
//
//     final gigModel = gigModelFromJson(jsonString);

import 'dart:convert';

GigModel gigModelFromJson(String str) => GigModel.fromJson(json.decode(str));

String gigModelToJson(GigModel data) => json.encode(data.toJson());

class GigModel {
    int? id;
    String? uid;
    int? userId;
    String? title;
    String? slug;
    String? description;
    String? price;
    String? priceType;
    int? hiringHours;
    int? deliveryTime;
    int? categoryId;
    int? subcategoryId;
    dynamic localAreaId;
    dynamic stateId;
    String? imageThumbId;
    String? imageMediumId;
    String? imageLargeId;
    String? status;
    bool? allowBooking;
    int? counterVisits;
    int? counterImpressions;
    int? counterSales;
    int? counterReviews;
    String? rating;
    int? ordersInQueue;
    int? hasUpgrades;
    int? hasFaqs;
    dynamic videoLink;
    dynamic videoId;
    dynamic deletedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? numberOfReview;
    dynamic fileVideoLink;
    dynamic shippingType;

    GigModel({
        this.id,
        this.uid,
        this.userId,
        this.title,
        this.slug,
        this.description,
        this.price,
        this.priceType,
        this.hiringHours,
        this.deliveryTime,
        this.categoryId,
        this.subcategoryId,
        this.localAreaId,
        this.stateId,
        this.imageThumbId,
        this.imageMediumId,
        this.imageLargeId,
        this.status,
        this.allowBooking,
        this.counterVisits,
        this.counterImpressions,
        this.counterSales,
        this.counterReviews,
        this.rating,
        this.ordersInQueue,
        this.hasUpgrades,
        this.hasFaqs,
        this.videoLink,
        this.videoId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.numberOfReview,
        this.fileVideoLink,
        this.shippingType,
    });

    factory GigModel.fromJson(Map<String, dynamic> json) => GigModel(
        id: json["id"],
        uid: json["uid"],
        userId: json["user_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        price: json["price"],
        priceType: json["price_type"],
        hiringHours: json["hiring_hours"],
        deliveryTime: json["delivery_time"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        localAreaId: json["local_area_id"],
        stateId: json["state_id"],
        imageThumbId: json["image_thumb_id"],
        imageMediumId: json["image_medium_id"],
        imageLargeId: json["image_large_id"],
        status: json["status"],
        allowBooking: json["allow_booking"],
        counterVisits: json["counter_visits"],
        counterImpressions: json["counter_impressions"],
        counterSales: json["counter_sales"],
        counterReviews: json["counter_reviews"],
        rating: json["rating"],
        ordersInQueue: json["orders_in_queue"],
        hasUpgrades: json["has_upgrades"],
        hasFaqs: json["has_faqs"],
        videoLink: json["video_link"],
        videoId: json["video_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        numberOfReview: json["number_of_review"],
        fileVideoLink: json["file_video_link"],
        shippingType: json["shipping_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "user_id": userId,
        "title": title,
        "slug": slug,
        "description": description,
        "price": price,
        "price_type": priceType,
        "hiring_hours": hiringHours,
        "delivery_time": deliveryTime,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "local_area_id": localAreaId,
        "state_id": stateId,
        "image_thumb_id": imageThumbId,
        "image_medium_id": imageMediumId,
        "image_large_id": imageLargeId,
        "status": status,
        "allow_booking": allowBooking,
        "counter_visits": counterVisits,
        "counter_impressions": counterImpressions,
        "counter_sales": counterSales,
        "counter_reviews": counterReviews,
        "rating": rating,
        "orders_in_queue": ordersInQueue,
        "has_upgrades": hasUpgrades,
        "has_faqs": hasFaqs,
        "video_link": videoLink,
        "video_id": videoId,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "number_of_review": numberOfReview,
        "file_video_link": fileVideoLink,
        "shipping_type": shippingType,
    };
}
