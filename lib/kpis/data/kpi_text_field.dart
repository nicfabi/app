import 'package:flutter/material.dart';

class KpiTextField extends StatefulWidget {
  final Function fetchData;
  final String title;
  final IconData icon;
  final IconData iconNegative;
  final bool isDate;
  const KpiTextField(
      {super.key,
      required this.fetchData,
      required this.title,
      required this.icon,
      this.iconNegative = Icons.trending_down_rounded,
      this.isDate = false});

  @override
  _KpiTextFieldState createState() => _KpiTextFieldState();
}

class _KpiTextFieldState extends State<KpiTextField> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isDate) {
        DateTime initialDate =
            DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
        DateTime finalDate =
            DateTime(DateTime.now().year, DateTime.now().month, 1);
        widget
            .fetchData(
          initialDate.month,
          finalDate.month,
          initialDate.year,
          finalDate.year,
        )
            .then((data) {
          setState(() {
            _value = data;
          });
        });
      } else {
        widget.fetchData().then((data) {
          setState(() {
            _value = data;
          });
        });
      }
    });
  }

  bool _isNegative() {
    return _value < 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      height: 150,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 52, 9, 77),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isDate
                        ? (_isNegative() ? widget.iconNegative : widget.icon)
                        : widget.icon,
                    size: 45,
                    color: widget.isDate
                        ? (_isNegative() ? Colors.red : Colors.green)
                        : Colors.green,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.isDate
                        ? _value.toStringAsFixed(2) + " %"
                        : _value.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
