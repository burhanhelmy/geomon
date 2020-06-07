import 'package:flutter/material.dart';
import 'package:geomon/page/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class RadiusSlider extends StatefulWidget {
  double value = 0;
  @override
  _RadiusSliderState createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    _radiusText() {
      return Container(
          width: 80,
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            '${homeProvider.monitorRadius.toStringAsFixed(2)} m',
            textAlign: TextAlign.center,
          ));
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Slider(
                value: (homeProvider.monitorRadius /
                    homeProvider.maxMonitorRadius),
                onChanged: (double value) {
                  homeProvider.updateMonitorRadius(value);
                },
              ),
            ),
            _radiusText()
          ],
        ));
  }
}
