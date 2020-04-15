import '../support/code_country.dart';
import '../support/code_countrys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
export '../support/code_country.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick({
    this.onChanged,
    this.isShowFlag,
    this.isDownIcon,
    this.isShowTitle,
    this.initialSelection,
    this.fontFamily,
    this.borderRadius,
    this.background,
    this.textColor,
    this.textSize,
    this.initialItem
  });
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isDownIcon;
  final String initialSelection;
  final double borderRadius;
  final String fontFamily;
  final Color background;
  final Color textColor;
  final double textSize;
  final int initialItem;
  final ValueChanged<CountryCode> onChanged;

  @override
  _CountryListPickState createState() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList.map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'assets/flags/${s['code'].toLowerCase()}.png',
              lang: s['lang']
            )).toList();

    elements.sort((a, b) => a.name.toString().compareTo(b.name.toString()));

    return _CountryListPickState(elements);
  }
}

class _CountryListPickState extends State<CountryListPick> {
  CountryCode selectedItem;
  List<CountryCode> countries;
  List<CountryCode> elements = [];

  final TextEditingController _searchController = TextEditingController();
  FixedExtentScrollController _cupertinoController;

  Icon icon = Icon(Icons.search);

  var diff = 0.0;

  var posSelected = 0;
  var height = 0.0;
  var _sizeheightcontainer;
  var _heightscroller;
  var _text;
  var _oldtext;
  var _itemsizeheight = 50.0;
  double _offsetContainer = 0.0;
  bool isShow = true;
  List _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  _CountryListPickState(this.elements);

  @override
  void initState() {
    //countries = elements;
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }
    _cupertinoController = FixedExtentScrollController(initialItem: widget.initialItem,);
    _searchController.addListener(_scrollListener);
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      elements = elements
          .where((e) =>
      e.code.contains(s) ||
          e.dialCode.contains(s) ||
          e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 && (_offsetContainer + details.delta.dy) <= (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected = ((_offsetContainer / _heightscroller) % _alphabet.length).round();
        _text = _alphabet[posSelected];
        if (_text != _oldtext) {
          for (var i = 0; i < elements.length; i++) {
            if (_text.toString().compareTo(elements[i].name.toString().toUpperCase()[0]) == 0) {
              _cupertinoController.jumpTo((i * _itemsizeheight) + 15);
              break;
            }
          }
          _oldtext = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _offsetContainer = details.globalPosition.dy - diff;
  }
  _scrollListener() {
    if ((_cupertinoController.offset) >=
        (_cupertinoController.position.maxScrollExtent)) {}
    if (_cupertinoController.offset <=
        _cupertinoController.position.minScrollExtent &&
        !_cupertinoController.position.outOfRange) {}
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = Icon(
        Icons.search,
        color: Theme.of(context).secondaryHeaderColor,
      );
      this.cupertinoTitle = Text("");
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
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
          child:
          Stack(
            children: <Widget>[
              /*Align(
                alignment: Alignment.topRight,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: cupertinoTitle,
                    ),
                    Flexible(
                      child: IconButton(
                        icon: icon,
                        onPressed: () {
                          setState(() {
                            isShow = true;
                            if (this.icon.icon == Icons.search) {
                              isShow = false;
                              this.icon = Icon(
                                Icons.close,
                                color: Theme.of(context).secondaryHeaderColor,
                              );
                              this.cupertinoTitle = Container(
                                //color: Colors.red,
                                child: TextField(
                                  controller: _searchController,
                                  onTap: (){
                                    print("hello");
                                  },

                                  style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                  ),
                                  enabled: true,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Search...",
                                      hintStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor,),
                                      enabled: true
                                  ),
                                  onChanged: _filterElements,
                                ),
                              );
                            } else {
                              _handleSearchEnd();
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),*/
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(right: 35.0),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: CupertinoPicker(
                            scrollController: _cupertinoController,
                            itemExtent: 50,
                            backgroundColor: Colors.transparent,
                            useMagnifier: true,
                            magnification: 1.1,
                            //squeeze: 2.0,
                            //looping: true,
                            onSelectedItemChanged: (value) {
                              //print(elements[value].name);
                              selectedItem = elements[value];
                              widget.onChanged(selectedItem);
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
                            }).toList()
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(

                  child: Text(
                    "OK",
                    style: TextStyle(color: widget.textColor),
                  ),
                  color: Colors.transparent,

                  onPressed: () {
                    widget.onChanged(selectedItem);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragStart: _onVerticalDragStart,
                  child: Padding(
                    padding: EdgeInsets.only(top: 35.0,right: 5.0),
                    child: Container(
                      height: 20.0 * 30,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: []..addAll(
                          List.generate(_alphabet.length, (index) => _getAlphabetItem(index)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ));
  }

  Widget cupertinoTitle = Text("");
  _getAlphabetItem(int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            posSelected = index;
            _text = _alphabet[posSelected];
            if (_text != _oldtext) {
              for (var i = 0; i < elements.length; i++) {
                if (_text.toString().compareTo(
                    elements[i].name.toString().toUpperCase()[0]) ==
                    0) {
                  _cupertinoController.jumpTo((i * _itemsizeheight) + 10);
                  break;
                }
              }
              _oldtext = _text;
            }
          });
        },
        child: Container(
          width: 40,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == posSelected ? Colors.blue : Colors.transparent,
            shape: BoxShape.circle,

          ),
          child: Text(
            _alphabet[index],
            textAlign: TextAlign.center,
            style: (index == posSelected)
                ? TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white)
                : TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
