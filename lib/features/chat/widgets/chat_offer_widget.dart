import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/features/chat/data/model/chat_offer_model.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class ChatOfferWidget extends StatefulWidget {
  ChatOfferWidget({
    super.key,
    required this.quotationId
  });

  String quotationId;

  @override
  State<ChatOfferWidget> createState() => _ChatOfferWidgetState();
}

class _ChatOfferWidgetState extends State<ChatOfferWidget> {

  final offerState = ProviderActionState<OfferModel>(data: null);
  bool offerIsMine = false;

  void loadFromCache() async {
    try {
      final offerData = await getIt<ILocalStorageService>().getItem(userDataBox, 'offer_${widget.quotationId}', defaultValue: null);
      if (offerData == null) {
        loadOffer();
      } else {
        final offer = OfferModel.fromJson(offerData);
        offerState.toSuccess(offer);
        offerIsMine = offer.ownerId == context.read<UserProfileProvider>().userProfileState.data!.id;
        setState(() {});
      }
    } catch (error) {
      loadOffer();
    }
  }

  void loadOffer() async {
    try {
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      // print("Token ::: $token");
      final url = "${appBaseUrl}offer-info?offerId=${widget.quotationId}";
      // print("Offer ::: Url ::: $url");
      final res = await getIt<Dio>().get(url, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      ));
      print("Offer ::: Response ::: ${res.data}");
      getIt<ILocalStorageService>().setItem(userDataBox, 'offer_${widget.quotationId}', res.data['data']);
      final offer = OfferModel.fromJson(res.data['data']);
      offerState.toSuccess(offer);
      offerIsMine = offer.ownerId == context.read<UserProfileProvider>().userProfileState.data!.id;
      setState(() {});
    } on DioException catch (error) {
      offerState.toError('Error: ${error.response!.data}');
      setState(() {});
      rethrow;
    } catch (error) {
      offerState.toError('Error: $error');
      setState(() {});
      rethrow;
    }
  }

  void withdrawOffer(String offerId) async {
    try {
      ToastAlert.showLoadingAlert("");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("Quote ::: ");
      final res = await getIt<Dio>().post("${appBaseUrl}withdraw-offer", data: {
        "offerId": offerId
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      ToastAlert.closeAlert();
      print("WithdrawResponse ::: ${res.data}");
      final success = res.data['success'];
      if (success == true) {
        ToastAlert.showAlert("Offer withdrawn successfully.");
        loadOffer();
      } else {
        ToastAlert.showErrorAlert("Unable to withdraw offer.");
      }
    } on DioException catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: ${error.response!.data}');
    } catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: $error');
    }
  }
  
  Future<void> acceptOffer(String offerId) async {
    try {
      ToastAlert.showLoadingAlert("");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("Quote ::: ");
      final res = await getIt<Dio>().post("${appBaseUrl}eval-offer", data: {
        "offerId": offerId,
        "status": 'accepted'
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      ToastAlert.closeAlert();
      print("WithdrawResponse ::: ${res.data}");
      final success = res.data['success'];
      if (success == true) {
        ToastAlert.showAlert("Offer withdrawn successfully.");
        loadOffer();
      } else {
        ToastAlert.showErrorAlert("Unable to withdraw offer.");
      }
    } on DioException catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: ${error.response!.data}');
    } catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: $error');
    }
  }
  
  Future<void> rejectOffer(String offerId) async {
    try {
      ToastAlert.showLoadingAlert("");
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("Quote ::: ");
      final res = await getIt<Dio>().post("${appBaseUrl}eval-offer", data: {
        "offerId": offerId,
        "status": 'rejected'
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      ToastAlert.closeAlert();
      print("WithdrawResponse ::: ${res.data}");
      final success = res.data['success'];
      if (success == true) {
        ToastAlert.showAlert("Offer withdrawn successfully.");
        // context.read<ChatMessagesProvider>(false);
        loadOffer();
      } else {
        ToastAlert.showErrorAlert("Unable to withdraw offer.");
      }
    } on DioException catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: ${error.response!.data}');
    } catch (error) {
      ToastAlert.closeAlert();
      ToastAlert.showErrorAlert('Error: $error');
    }
  }

  @override
  void initState() {
    loadFromCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("OfferId ::: ${widget.quotationId}");
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: DividerTheme.of(context).color ?? Colors.grey.withOpacity(.1),
          width: .1
        )
      ),
      child: Builder(
        builder: (context) {
          if (offerState.isLoading()) {
            return Container(
              color: Colors.grey.shade100,
              height: 100,
            );
          }
          if (offerState.isError()) {
            return Container(
              color: Colors.red.shade100,
              height: 100,
              child: Center(
                child: Text("${offerState.message}", style: TextStyle(color: Colors.white),),
              ),
            );
          }
          final offer = offerState.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text("${offer.gig!.title}"),
              ),
          
              const Divider(height: .1, thickness: .4,),
          
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${offer.description}"),
                    10.toColumSpace(),
                    Text("Offer price: ${moneyFormatter.format(num.parse(offer.offerAmount!))}"),
                    4.toColumSpace(),
                    Text("${offer.deliveryTime} day delivery"),
                  ],
                ),
              ),
          
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Builder(
                  builder: (context) {
                    if (offerIsMine && offer.offerStatus == null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final withdraw = await ToastAlert.showConfirmAlert(context, "Are you sure you want to withdraw this offer, this action can't be undone.");
                              if (withdraw) {
                                withdrawOffer(widget.quotationId);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFFF5841B)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                              )),
                              elevation: MaterialStateProperty.all(0),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 0))
                            ),
                            child: const Text("Witdraw Offer", style: TextStyle(
                              color: Colors.white
                            ),),
                          )
                        ],
                      );
                    }

                    // if (offer.offerStatus)

                    if (!offerIsMine && offer.offerStatus == null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async {
                                final accept = await ToastAlert.showConfirmAlert(context, "Are you sure you want to accept this offer, this action can't be undone.");
                                if (accept) {
                                  acceptOffer(widget.quotationId).then((value) {
                                    // loadOffer();
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xFF32C581)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                                )),
                                elevation: MaterialStateProperty.all(0),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 0))
                              ),
                              child: const Text("Accept Offer", style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                          ),
                          10.toRowSpace(),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async {
                                final reject = await ToastAlert.showConfirmAlert(context, "Are you sure you want to reject this offer, this action can't be undone.");
                                if (reject) {
                                  rejectOffer(widget.quotationId).then((value) {
                                    // loadOffer();
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xFFF5841B)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)
                                )),
                                elevation: MaterialStateProperty.all(0),
                                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 0))
                              ),
                              child: Text("Reject Offer", style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                          ),
                        ],
                      );
                    }
                    if (offer.offerStatus.toString().toLowerCase() == 'withdrawn') {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Offer Withdrawn", style: TextStyle(
                              color: Color(0xFF65758B)
                            ),)
                          ],
                        ),
                      );
                    }
                    if (offer.offerStatus.toString().toLowerCase() == 'rejected') {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Offer Rejected", style: TextStyle(
                              color: Color(0xFF65758B)
                            ),)
                          ],
                        ),
                      );
                    }
                    if (offer.offerStatus.toString().toLowerCase() == 'accepted') {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Offer Accepted", style: TextStyle(
                              color: Color(0xFF65758B)
                            ),),
                            if (!offerIsMine && offer.isPaid == false) ...[
                              10.toRowSpace(),

                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.router.push(AppRoute(url: "https://pallytopit.com.ng/checkout?offer=${offer.uid}", canExitFreely: true));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xFF32C581)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)
                                    )),
                                    elevation: MaterialStateProperty.all(0),
                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8, vertical: 0))
                                  ),
                                  child: const Text("Checkout", style: TextStyle(
                                    color: Colors.white
                                  ),),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                ),
              )
          
            ],
          ).animate().fadeIn();
        }
      ),
    );
  }
}