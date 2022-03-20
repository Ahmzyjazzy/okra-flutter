import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:okra_widget/raw/okra_html.dart';
import 'package:okra_widget/utils/helper.dart';
import 'dart:io' show Platform;
import 'view/web.dart';

class Okra {
  Okra._();
  static Future<void> buildWithOptions(
    BuildContext context, {
    required String key,
    required String token,
    String? appId,
    required List<String> products,
    String? environment,
    String? clientName,
    String? color,
    int? limit,
    bool? isCorporate,
    bool? payment,
    String? connectMessage,
    String? callbackUrl,
    String? redirectUrl,
    String? logo,
    String? widgetSuccess,
    String? widgetFailed,
    String? currency,
    bool? noPeriodic,
    String? exp,
    String? successTitle,
    String? successMessage,
    String? chargeType,
    int? chargeAmount,
    String? chargeNote,
    String? chargeCurrency,
    Map<String, Object>? guarantors,
    Map<String, Object>? filters,
    Function(String data)? onSuccess,
    Function(String message)? onError,
    Function(String message)? onClose,
    Function(String message)? beforeClose,
  }) async {
    AndroidDeviceInfo? androidDeviceInfo;
    IosDeviceInfo? iosDeviceInfo;

    if (Platform.isAndroid) {
      androidDeviceInfo = await Helper.getAndroidInfo();
    } else {
      iosDeviceInfo = await Helper.getIosInfo();
    }

    Map<String, dynamic> okraOptions = new Map();
    okraOptions["key"] = key;
    okraOptions["token"] = token;
    okraOptions["app_id"] = appId;
    okraOptions["env"] = environment;
    okraOptions["clientName"] = clientName ?? "";
    okraOptions["color"] = color ?? "#3AB795";
    okraOptions["limit"] = limit ?? 24;
    okraOptions["isCorporate"] = isCorporate ?? false;
    okraOptions["payment"] = payment ?? false;
    okraOptions["connectMessage"] = connectMessage;
    okraOptions["callback_url"] = callbackUrl ?? "";
    okraOptions["redirect_url"] = redirectUrl ?? "";
    okraOptions["logo"] = logo ?? "";
    okraOptions["widget_success"] = widgetSuccess ?? "";
    okraOptions["widget_failed"] = widgetFailed ?? "";
    okraOptions["currency"] = currency ?? "NGN";
    okraOptions["noPeriodic"] = noPeriodic ?? false;
    okraOptions["exp"] = exp ?? "";
    okraOptions["success_title"] = successTitle ?? "";
    okraOptions["guarantors"] = "'$guarantors'";
    okraOptions["filters"] = "'$filters'";
    var charge = {
      "type": chargeType ?? "",
      "amount": chargeAmount ?? "",
      "note": chargeNote ?? "",
      "currency": chargeCurrency ?? ""
    };
    okraOptions["charge"] = okraOptions["payment"] ? "'$charge'" : false;

    okraOptions["uuid"] = Platform.isAndroid
        ? androidDeviceInfo!.androidId
        : iosDeviceInfo!.identifierForVendor;
    String? deviceName =
        Platform.isAndroid ? androidDeviceInfo!.brand : iosDeviceInfo!.name;
    String? deviceModel =
        Platform.isAndroid ? androidDeviceInfo!.model : iosDeviceInfo!.model;
    okraOptions["deviceInfo"] = "";
    // okraOptions["deviceInfo"] = {
    //   "deviceName" : deviceName,
    //   "deviceModel" : deviceModel,
    //   "longitude" : 0,
    //   "latitude" :  0,
    //   "platform" : Platform.isAndroid ? "android" : "ios"
    // };

    for (String p in products) {
      int i = products.indexOf(p);
      products[i] = "'$p'";
    }
    okraOptions["products"] = products;

    okraOptions["source"] = "flutter";
    okraOptions["isWebview"] = true;
    print(products);
    print(mBuildOkraWidgetWithOptions(okraOptions));

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Web(
          okraOptions: okraOptions,
          useShort: false,
          onClose: onClose,
          onError: onError,
          onSuccess: onSuccess,
        ),
      ),
    );
  }

  static Future<void> buildWithShortUrl(
    BuildContext context, {
    required String shortUrl,
    Function(String data)? onSuccess,
    Function(String message)? onError,
    Function(String message)? onClose,
    Function(String message)? beforeClose,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Web(
          shortUrl: shortUrl,
          useShort: true,
          onClose: onClose,
          onError: onError,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}
