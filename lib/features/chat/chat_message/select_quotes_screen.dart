import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/core/state/user_profile_provider.dart';
import 'package:correct_hustle/core/styles/input_style.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/core/widgets/custom_error_widget.dart';
import 'package:correct_hustle/features/app/presentation/screen/app_screen.dart';
import 'package:correct_hustle/features/chat/data/model/quote_model.dart';
import 'package:correct_hustle/features/chat/state/chat_messages_provider.dart';
import 'package:correct_hustle/features/chat/state/send_message_provider.dart';
import 'package:correct_hustle/gen/assets.gen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SelectQuotesScreen extends StatefulWidget {
  const SelectQuotesScreen({super.key});

  @override
  State<SelectQuotesScreen> createState() => _SelectQuotesScreenState();
}

class _SelectQuotesScreenState extends State<SelectQuotesScreen> {

  final quoteState = ProviderActionState<List<QuoteModel>>(data: null);

  final searchParamController = TextEditingController();

  void loadOffers() async {
    try {
      quoteState.toLoading(); setState(() {});
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      // print("Quote ::: ");
      final res = await getIt<Dio>().post("$appBaseUrl/chat-quotes", data: {
        'search': searchParamController.text
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      // print("Quotes ::: ${res.data}");
      quoteState.toSuccess(List.from(res.data['data']).map((e) => QuoteModel.fromJson(e)).toList());
      setState(() {});
    } on DioException catch (error) {
      quoteState.toError('${error.response!.data['message']}');
      setState(() {});
    } catch (error) {
      quoteState.toError('Quote ::: Error : $error');
      setState(() {});
    }
  }

  @override
  void initState() {
    loadOffers();
    searchParamController.addListener(() {
      loadOffers();
    });
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
                Text("Quotation Details", style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700
                ),),
              ],
            ),
          ),

          // 16.toColumSpace(),

          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16.w),
          //   padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFEBF4FE),
          //     borderRadius: BorderRadius.circular(8)
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("Quote info", style: TextStyle(
          //         fontSize: 16.sp, color: Color(0xFF1F429E),
          //         fontWeight: FontWeight.w700
          //       ),),
          //       4.toColumSpace(),
          //       Text("Select an existing service you want to create custom offer.", style: TextStyle(
          //         fontSize: 14.sp, color: Color(0xFF1F429E)
          //       ),),
          //     ],
          //   ),
          // ),

          16.toColumSpace(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextFormField(
              decoration: defaultInputDecoration.copyWith(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Icon(Icons.search),
                ),
                hintText: "Find your quotes",
                constraints: BoxConstraints(
                  maxHeight: 48.h, minHeight: 48.h
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (v) => setState(() {}),
              controller: searchParamController,
            ),
          ),
          16.toColumSpace(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                final profile = context.read<ChatMessagesProvider>().otherUser;
              final url = "https://pallytopit.com.ng/seller/quotes/create?uid=${profile.uid}";
                print("Url ::: $url");
                context.router.push(AppRoute(
                  url: url,
                  canExitFreely: true
                ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF1E46F5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)
                )),
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 0))
              ),
              child: const Text("Create Quote", style: TextStyle(
                color: Colors.white
              ),),
            ),
          ),
          16.toColumSpace(),

          Expanded(
            child: Builder(
              builder: (context) {
                if (quoteState.isLoading()) {
                  return const Center(
                    child: BrowserLoading(),
                  );
                }
                if (quoteState.isError()) {
                  return CustomErrorWidget(message: quoteState.message, onRefresh: ()=> loadOffers());
                }
                final searh = searchParamController.text.toLowerCase();
                final data = (quoteState.data ?? []).where(
                  (element) => 
                    element.firstName!.toLowerCase().contains(searh) ||
                    element.lastName!.toLowerCase().contains(searh) ||
                    element.total!.toLowerCase().contains(searh) ||
                    element.totalQuantity!.toLowerCase().contains(searh)
                ).toList();

                if (data.isEmpty) {
                  return CustomErrorWidget(message: "You do not have any quote.", onRefresh: () => loadOffers());
                }
                return ListView.separated(
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                    );
                  },
                  itemBuilder: (context, index) {
                    final quote = data[index];
                    final total = num.parse(quote.total ?? "0");
                    final isPaid = quote.paid == true;
                    return InkWell(
                      onTap: () {
                        context.read<SendMessageProvider>().setQuote(quote);
                        context.router.pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              color: const Color(0xffD8F4DC),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40, width: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5A85AE),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Center(
                                      child: Text("${quote.firstName!.split('').first}${quote.lastName!.split('').first}", style: TextStyle(
                                        color: Color(0xFFA1C4E8),
                                        fontWeight: FontWeight.w700
                                      ),),
                                    )
                                  ),
                                  10.toRowSpace(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${quote.firstName} ${quote.lastName}", style: const TextStyle(
                                          color: Color(0xFF486F91)
                                        ),),
                                        Text("Ref: ${quote.reference}", style: const TextStyle(
                                          color: Color(0xFF76ABE0)
                                        ),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                      
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Total Disc.", style: TextStyle(
                                            fontSize: .875 * 16,
                                            color: Colors.grey.shade400, fontWeight: FontWeight.w600
                                          ),),
                                          Text("${moneyFormatter.format(total)}", style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600,
                                            color: Colors.black
                                          ),),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Total", style: TextStyle(
                                            fontSize: .875 * 16,
                                            color: Colors.grey.shade400, fontWeight: FontWeight.w600
                                          ),),
                                          Text("${moneyFormatter.format(num.parse(quote.totalTax!))}", style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600,
                                            color: Colors.black
                                          ),),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Paid", style: TextStyle(
                                            fontSize: .875 * 16,
                                            color: Colors.grey.shade400, fontWeight: FontWeight.w600
                                          ),),
                                          Text(isPaid ? "Paid" : "Unpaid", style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600,
                                            color: Colors.black
                                          ),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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