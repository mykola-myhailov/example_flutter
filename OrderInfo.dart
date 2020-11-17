import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:kaban_performer/models/Order.dart';
import 'package:kaban_performer/proposals/OrderGalleryController.dart';
import '../Styles.dart' as styles;
import '../Widgets.dart';
import '../localisation.dart';


class OrderInfo extends StatefulWidget {
  OrderInfo(this._order, [this._canEditPrice = false, this._onPriceEdit]);

  final Order _order;
  final bool _canEditPrice;
  final Function(String price) _onPriceEdit;

  @override
  State<StatefulWidget> createState() =>
      _OrderInfoState(_order, _canEditPrice, _onPriceEdit);
}

class _OrderInfoState extends State<OrderInfo> {
  _OrderInfoState(this._order, this._canEditPrice, this._onPriceEdit);

  Order _order;
  bool _canEditPrice;
  TextEditingController _priceController = TextEditingController();
  Function(String price) _onPriceEdit;

  @override
  void initState() {
    _priceController.value = TextEditingValue(text: _order.price.toString());
    if (_onPriceEdit != null)
      _priceController.addListener(() => _onPriceEdit(_priceController.text));


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var title = Text(_order.title, style: styles.TextStyles.darkText32);
    var description = Text(_order.specialist,
        style: styles.TextStyles.darkText18.apply(fontFamily: 'Gilroy'));

    var time = Text(_order.formattedTime, style: styles.TextStyles.darkText32);
    var date = Text(_order.formattedDate2,
        style: styles.TextStyles.darkText18.apply(fontFamily: 'Gilroy'));

    var address = Text(_order.address, style: styles.TextStyles.darkText18);
    var addressDetail = Text(_order.addressDetail,
        style: styles.TextStyles.darkText18.apply(fontFamily: 'Gilroy'));

    var tfPrice = TextFormField(
      enabled: _canEditPrice,
      controller: _priceController,
      keyboardType: TextInputType.number,
      style: styles.TextStyles.darkText32,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        WhitelistingTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0), border: InputBorder.none),
    );

    var avatar = Container(child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(60)),
      //decoration:
      //BoxDecoration(shape: BoxShape.circle, color: Color(0xFFBDBCBE)),
      //height: 60,
      //width: 60,
      child: _order.photo == "https://kaban.itpromotion.eu/null"
      ?Image.asset('assets/drawable/ic_profile.png')
      :Image.network('https://kaban.itpromotion.eu/${_order.photo}',
      fit: BoxFit.cover,
      width: 60,
      height:60,),
    ));
    var ownerFullName = Widgets.labelDark18(_order.owner.fullName);

    String _photo = "";
    if (_order.gallery != null && _order.gallery.length > 0)_photo =_order.gallery.elementAt(0);
    else print ("emnty gallery");

    Widget serviceNamesWidget = ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      itemCount:   _order.serviceNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Center(child: Text(_order.serviceNames.elementAt(index), style: styles.TextStyles.darkText18)
        ));
      });
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title,
          SizedBox(height: 4),
          serviceNamesWidget,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: description),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.only(right: 6, bottom: 6),
                      decoration: BoxDecoration(
                          color: styles.Colors.orange, shape: BoxShape.circle),
                      child: Center(
                          //child: Image.asset('assets/drawable/ic_camera.png')),
                        child: GestureDetector(
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                                child: Image.network("https://kaban.itpromotion.eu/" + _photo, 
                                fit: BoxFit.cover,
                                width: 54,
                                height:54,)
                            ),
                            onTap: (){
                              if (_order.gallery != null && _order.gallery.length > 0)
                              galleryWidget(context, _order);
                              else  Fluttertoast.showToast(
                                  msg: Localization.of(context).trans("Для этого заказа нет изображений"),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                        )

                      )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: styles.Colors.orange, width: 1),
                          shape: BoxShape.circle,
                          color: styles.Colors.whiteDark),
                      child: Center(
                          child: Text(
                            '${_order.gallery.length}',
                            style: TextStyle(
                                fontSize: 10, color: styles.Colors.orange),
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          time,
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: date),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    color: styles.Colors.orange, shape: BoxShape.circle),
                child: Center(
                    child: Image.asset('assets/drawable/ic_calendar.png')),
              )
            ],
          ),
          SizedBox(height: 20),
          address,
          addressDetail,
          SizedBox(height: 36),
          Row(
            children: <Widget>[
              Container(
                  width: 128,
                  child: Column(children: <Widget>[
                    tfPrice,
                    Container(color: styles.Colors.black, width: 128, height: 1)
                  ])),
              Text('zł', style: styles.TextStyles.darkText24),
            ],
          ),
          SizedBox(height: 20),
          Widgets.labelDark18(Localization.of(context).trans('Заказчик')),
          SizedBox(height: 10),
          Row(
            children: <Widget>[avatar, SizedBox(width: 10), ownerFullName],
          )
        ],
      ),
    );
  }

}

void galleryWidget(BuildContext context, Order order) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(252, 246, 239, 1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              ),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.8,
              builder: (BuildContext context,
                  ScrollController scrollController) {
                return Material(
                    elevation: 4,
                    child: OrderGalleryController(order.gallery)
                );
              },
            ),
          ),
        ),
      ),
      isScrollControlled: true);
}


