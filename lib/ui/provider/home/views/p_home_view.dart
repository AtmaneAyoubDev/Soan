import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../components/p_home_add_terms.dart';
import '../components/p_home_list_widget.dart';

class PhomeView extends StatefulWidget {
  const PhomeView({Key? key}) : super(key: key);

  @override
  State<PhomeView> createState() => _PhomeViewState();
}

class _PhomeViewState extends State<PhomeView> {
  bool isLoading = true;
  List<PorderModel> _ordersList = [];
  Future getOrders() async {
    if (mounted) {
      isLoading = true;
    }
    setState(() {});
    await ProviderController.getOrdersThatNeedsAnswer(
      token: Provider.of<ProviderProvider>(context, listen: false)
          .providerModel
          .apiToken,
    ).then((value) {
      _ordersList = value;
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    log(Provider.of<ProviderProvider>(context, listen: false)
        .providerModel
        .apiToken);
    if (Provider.of<ProviderProvider>(context, listen: false)
            .providerModel
            .terms !=
        "") {
      getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/images/home_back.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 70.h,
              ),
              TextWidget(
                text: LocaleKeys.titles_home.tr(),
                size: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 21.h,
              ),
              if (Provider.of<ProviderProvider>(context, listen: false)
                      .providerModel
                      .terms ==
                  "")
                const PhomeAddTerms(),
              if (Provider.of<ProviderProvider>(context, listen: false)
                      .providerModel
                      .terms !=
                  "")
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _ordersList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 20.h,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      PorderModel order = _ordersList[index];
                      return PhomeListWidget(
                        order: order,
                        getorder: () {
                          getOrders();
                        },
                      );
                    },
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
