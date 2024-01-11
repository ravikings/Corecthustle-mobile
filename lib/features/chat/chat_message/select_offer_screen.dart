import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/widgets/custom_error_widget.dart';
import 'package:correct_hustle/features/app/presentation/screen/app_screen.dart';
import 'package:correct_hustle/features/chat/data/model/gig_model.dart';
import 'package:correct_hustle/features/chat/state/send_message_provider.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SelectOfferScreen extends StatefulWidget {
  const SelectOfferScreen({super.key});

  @override
  State<SelectOfferScreen> createState() => _SelectOfferScreenState();
}

class _SelectOfferScreenState extends State<SelectOfferScreen> {

  final offerState = ProviderActionState<List<GigModel>>(data: []);

  void loadOffers() async {
    try {
      offerState.toLoading(); setState(() {});
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      // print("Offer ::: $token");
      final res = await getIt<Dio>().get("$appUrl/fetch/seller-gigs", options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      // print("Offers ::: ${res.data}");
      // print("Offer ::: ${res.data['data'][0]}");
      offerState.toSuccess(List.from(res.data['data']).map((e) => GigModel.fromJson(e)).toList());
      setState(() {});
    } on DioException catch (error) {
      offerState.toError('Offer ::: Error : ${error.response!.data}');
      setState(() {});
    } catch (error) {
      offerState.toError('Offer :: Error : $error');
      setState(() {});
    }
  }

  @override
  void initState() {
    loadOffers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          45.toColumSpace(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.router.pop(),
                  child: const Icon(Icons.arrow_back)
                ),
                16.toRowSpace(),
                Text("Create a Custom Offer", style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700
                ),),
              ],
            ),
          ),

          16.toColumSpace(),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: Color(0xFFEBF4FE),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Offer info", style: TextStyle(
                  fontSize: 16.sp, color: Color(0xFF1F429E),
                  fontWeight: FontWeight.w700
                ),),
                4.toColumSpace(),
                Text("Select an existing service you want to create custom offer.", style: TextStyle(
                  fontSize: 14.sp, color: Color(0xFF1F429E)
                ),),
              ],
            ),
          ),

          16.toColumSpace(),

          Expanded(
            child: Builder(
              builder: (context) {
                if (offerState.isLoading()) {
                  return const Center(
                    child: BrowserLoading(),
                  );
                }
                if (offerState.isError()) {
                  return CustomErrorWidget(message: offerState.message, onRefresh: ()=> loadOffers());
                }
                final offers = offerState.data ??[];
                if (offers.isEmpty) {
                  return CustomErrorWidget(message: "You do not have any offer.", onRefresh: ()=> loadOffers());
                }
                return ListView.separated(
                  itemCount: offers.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                    );
                  },
                  itemBuilder: (context, index) {
                    final gig = offers[index];
                    return InkWell(
                      onTap: () {
                        context.router.pop(gig);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green.shade100
                          ),
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${gig.title}", style: TextStyle(
                              fontSize: .875 * 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500
                            ),),
                            2.toColumSpace(),
                            Text("${moneyFormatter.format(num.parse(gig.price ?? "0"))}", style: TextStyle(
                              fontSize: 1 * 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w700
                            ),),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          )

        ],
      ),
    );
  }
}