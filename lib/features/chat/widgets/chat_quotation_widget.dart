import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/features/chat/data/model/chat_quote_mode.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatQuotationWidget extends StatefulWidget {
  ChatQuotationWidget({
    super.key,
    required this.quotationId
  });

  String quotationId;

  @override
  State<ChatQuotationWidget> createState() => _ChatQuotationWidgetState();
}

class _ChatQuotationWidgetState extends State<ChatQuotationWidget> {

  final quotationState = ProviderActionState<ChatQuoteModel>(data: null);

  void loadFromCache() async {
    try {
      final offerData = await getIt<ILocalStorageService>().getItem(userDataBox, 'quote_${widget.quotationId}', defaultValue: null);
      if (offerData == null) {
        loadQuotation();
      } else {
        final quote = ChatQuoteModel.fromJson(offerData);
        quotationState.toSuccess(quote);
        setState(() {});
      }
    } catch (error) {
      loadQuotation();
    }
  }

  void loadQuotation() async {
    try {
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("Quote ::: ");
      final res = await getIt<Dio>().post("$appBaseUrl/chat-quote", data: {
        "quoteId": widget.quotationId
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "X-Csrf-Token": "0QET8gXARhz2Ub49PlvmAwEP7pVEab3vhjPhnxnn"
        }
      ));
      final quote = ChatQuoteModel.fromJson(res.data['data']);
      await getIt<ILocalStorageService>().setItem(userDataBox, 'quote_${widget.quotationId}', res.data['data']);
      quotationState.toSuccess(quote);
      setState(() {});
    } on DioException catch (error) {
      quotationState.toError('Error: ${error.response!.data}');
      setState(() {});
    } catch (error) {
      quotationState.toError('Error: $error');
      setState(() {});
    }
  }

  @override
  void initState() {
    loadFromCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (quotationState.isError()) {
          return Container(
            color: Colors.red.withOpacity(.5),
            height: 150,
            child: Center(
              child: Text(quotationState.message),
            ),
          );
        }
        if (quotationState.isLoading()) {
          return Container(
            height: 150,
            color: Colors.grey,
          );
        }
        final quote = quotationState.data!;
        print("Quote ::: ${quote.toJson()}");
        final total = quote.items!.fold<num>(0, (p, i) => p + num.parse(i.totalPrice!));
        final gTotal = total + num.parse(quote.totalTax!);
        final isPaid = quote.paid == true;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white
          ),
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
                        child: Text("${quote.firstName!.split('').first}${quote.lastName!.split('').first}", style: const TextStyle(
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
                            Text("Sub Total", style: TextStyle(
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
                            Text("Total Tax", style: TextStyle(
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
                            Text("Grand Total", style: TextStyle(
                              fontSize: .875 * 16,
                              color: Colors.grey.shade400, fontWeight: FontWeight.w600
                            ),),
                            Text("${moneyFormatter.format(gTotal)}", style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600,
                              color: Colors.black
                            ),),
                          ],
                        ),
                      ],
                    ),
                    10.toColumSpace(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                        children: [
                          const TextSpan(
                            text: "Quotation is "
                          ),
                          TextSpan(
                            text: "${isPaid ? "Paid" : "Unpaid"}",
                            style: TextStyle(
                              color: isPaid ? Colors.green : Colors.red
                            ),
                          ),
                        ]
                      ))
                  ],
                ),
              ),

              InkWell(
                onTap: () => context.router.push(ViewQuoteRoute(quote: quote)),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("View Quote", style: TextStyle(
                        color: Color(0xFF65758B)
                      ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ).animate().fadeIn();
      }
    );
  }
}