import 'package:correct_hustle/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRefresh
  });

  final String message;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, textAlign: TextAlign.center,),
          14.toColumSpace(),
          InkWell(
            onTap: () => onRefresh(),
            child: Text("Refresh", textAlign: TextAlign.center,)
          )
        ],
      ),
    );
  }
}