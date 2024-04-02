import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysavingapp/common/utils/mysaving_colors.dart';

class DashboardCurrencyPicker extends StatefulWidget {
  const DashboardCurrencyPicker({super.key, required this.onCurrencyChanged});
  final Function(String) onCurrencyChanged; // Add this field
  @override
  State<DashboardCurrencyPicker> createState() =>
      _DashboardCurrencyPickerState();
}

class _DashboardCurrencyPickerState extends State<DashboardCurrencyPicker> {
  String dropdownValue = 'PLN';
  static const List<String> supportedCurrencies = <String>[
    'PLN',
    'USD',
    'EUR',
    'GBP',
    // Add more currencies as needed
  ];

  Map<String, double>? currencyRates;

  Future<void> _fetchCurrencyRates(String baseCurrency) async {
    final url =
        'https://v6.exchangerate-api.com/v6/YOUR_API_KEY/latest/$baseCurrency';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      setState(() {
        currencyRates = decodedData['conversion_rates'].cast<String, double>();
      });
    } else {
      // Handle error if API call fails
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrencyRates(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 72,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: dropdownValue,
              iconSize: 0,
              elevation: 6,
              style: TextStyle(
                  color: MySavingColors.defaultBlueButton,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              onChanged: (String? value) async {
                setState(() {
                  dropdownValue = value!;
                });
                await _fetchCurrencyRates(dropdownValue);

                // Call the onCurrencyChanged callback passing the selected currency
                widget.onCurrencyChanged(dropdownValue);
              },
              items: supportedCurrencies.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(value),
                          Icon(
                            Icons.arrow_downward,
                            size: 18,
                            color: MySavingColors.defaultBlueButton,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  double convertToSelectedCurrency(double value) {
    if (currencyRates == null) {
      // Return the original value if exchange rates are not fetched yet
      return value;
    } else {
      final selectedCurrencyRate = currencyRates![dropdownValue];
      return value / selectedCurrencyRate!;
    }
  }
}
