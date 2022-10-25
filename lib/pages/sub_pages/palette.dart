import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

const List<Color> colors = [
  Color.fromRGBO(127, 188, 210, 1),
  Color.fromRGBO(165, 241, 233, 1),
  Color.fromRGBO(255, 238, 175, 1),
  Color.fromRGBO(255, 192, 144, 1),
  Color.fromRGBO(245, 148, 148, 1),
];


class Palette extends StatefulWidget {
  const Palette({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    required this.colorHistory,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> colorHistory;

  @override
  State<Palette> createState() => _Palette();
}


class _Palette extends State<Palette> {
  final double _borderRadius = 30;
  final double _blurRadius = 5;
  final double _iconSize = 24;

  Widget pickerLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {

    return SizedBox(
      width: 300,
      height: 80,
      child: GridView.count(
        crossAxisCount: 5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2), blurRadius: _blurRadius)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          BlockPicker(
            pickerColor: widget.pickerColor,
            onColorChanged: widget.onColorChanged,
            availableColors: widget.colorHistory.isNotEmpty ? widget.colorHistory : colors,
            layoutBuilder: pickerLayoutBuilder,
            itemBuilder: pickerItemBuilder,
          ),
        ]
    );
  }
}