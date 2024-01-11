import 'package:auto_route/auto_route.dart';
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/interactions/alert.dart';
import 'package:correct_hustle/core/routes/routes.gr.dart';
import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:correct_hustle/features/chat/data/model/chat_quote_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ViewQuoteScreen extends StatelessWidget {
  const ViewQuoteScreen({
    super.key,
    required this.quote
  });

  final ChatQuoteModel quote;

  @override
  Widget build(BuildContext context) {
    final total = quote.items!.fold<num>(0, (p, i) => p + num.parse(i.totalPrice!));
    final gTotal = total + num.parse(quote.totalTax!);
    final isPaid = quote.paid == true;
    
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
                Text("Quote Detail", style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w700
                ),),
              ],
            ),
          ),

          8.toColumSpace(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  8.toColumSpace(),

                  Container(
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
                      ],
                    ),
                  ),

                  16.toColumSpace(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Quote Items', style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.w600,
                    ),),
                  ),

                  16.toColumSpace(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...(quote.items ?? []).map((e) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description", style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 13.sp
                            ),),
                            Text("${e.description}"),
                  
                            8.toColumSpace(),
                  
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text("Quantity", style: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 13.sp
                                    ),),
                                    Text("${e.quantity}"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Price", style: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 13.sp
                                    ),),
                                    Text("${moneyFormatter.format(num.parse(e.price ?? "0"))}"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Discount", style: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 13.sp
                                    ),),
                                    Text("${moneyFormatter.format(num.parse(e.discount ?? "0"))}"),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),

                  16.toColumSpace(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.router.push(AppRoute(
                          url: "https://pallytopit.com.ng/quotations/${quote.reference}/payment",
                          canExitFreely: true
                        ));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF1E46F5)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 0))
                      ),
                      child: Text("Payment", style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}