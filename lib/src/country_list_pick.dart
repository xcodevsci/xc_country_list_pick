import '../support/code_country.dart';
import '../support/code_countrys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
export '../support/code_country.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick(
      {this.onChanged,
      this.isShowFlag,
      this.isDownIcon,
      this.isShowTitle,
      this.initialSelection,
      this.fontFamily,
      this.borderRadius,
      this.background,
      this.textColor,
      this.textSize});
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isDownIcon;
  final String initialSelection;
  final double borderRadius;
  final String fontFamily;
  final Color background;
  final Color textColor;
  final double textSize;
  final ValueChanged<CountryCode> onChanged;

  @override
  _CountryListPickState createState() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList
        .map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'assets/flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    elements.sort((a, b) {
      return a.name.toString().compareTo(b.name.toString());
    });

    return _CountryListPickState(elements);
  }
}

class _CountryListPickState extends State<CountryListPick> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  final TextEditingController _formSearchcontroller = TextEditingController();

  _CountryListPickState(this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }
    _formSearchcontroller.addListener(_filterElements);
    super.initState();
  }

  void _filterElements() {
    /*String s = _formSearchcontroller.text.toUpperCase();
    setState(() {
      elements = elements
          .where((e) =>
      e.code.contains(s) ||
          e.dialCode.contains(s) ||
          e.name.toUpperCase().contains(s))
          .toList();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
        decoration: BoxDecoration(
            color: widget.background,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadius),
                topRight: Radius.circular(widget.borderRadius))),
        child: MediaQuery(
          data: const MediaQueryData(
            // The native iOS picker's text scaling is fixed, so we will also fix it
            // as well in our picker.
            textScaleFactor: 1.0,
          ),
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 45.0,

                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius))),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      controller: _formSearchcontroller,
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      decoration: InputDecoration.collapsed(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      //onChanged: _filterElements,
                    ),
                  ),
                ),
              )
            ),*/
              Flexible(
                flex: 6,
                child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: 1,
                    ),
                    itemExtent: 50,
                    backgroundColor: Colors.transparent,
                    useMagnifier: true,
                    magnification: 1.1,
                    //looping: true,
                    onSelectedItemChanged: (value) {
                      //print(elements[value].name);
                      selectedItem = elements[value];
                      setState(() {});
                    },
                    children: elements.map((CountryCode countryCode) {
                      return Container(
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        child: ListTile(
                          leading: Image.asset(
                            countryCode.flagUri,
                            width: 32.0,
                          ),
                          title: Text(
                              widget.isShowTitle
                                  ? countryCode.toCountryStringOnly()
                                  : countryCode.toString(),
                              style: TextStyle(
                                  fontSize: widget.textSize,
                                  fontFamily: "${widget.fontFamily}",
                                  color: widget.textColor)),
                          trailing: selectedItem.code == countryCode.code
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          //subtitle: Text(countryCode.toString()),
                        ),
                      );

                      /*Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        selectedItem.flagUri,
                        package: 'country_list_pick',
                        width: 32.0,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(widget.isShowTitle
                          ? countryCode.toCountryStringOnly()
                          : countryCode.toString(),style: TextStyle(fontSize: 25.0,fontFamily: "${widget.fontFamily}",color: widget.textColor),),
                    ),
                  ),
                ],
              )*/
                    }).toList()),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0.0),
                  child: RaisedButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: widget.textColor),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      widget.onChanged(selectedItem);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
