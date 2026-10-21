import 'package:flutter/services.dart';

/// A [TextInputFormatter] that formats the input for a card expiration date.
///
/// This formatter ensures that the input is in the format "MM/YY" where MM
/// represents the month and YY represents the year. It automatically adds
/// the "/" separator between the month and year if necessary.
class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    var valueToReturn = '';

    for (var i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      final nonZeroIndex = i + 1;
      final contains = valueToReturn.contains(RegExp(r'\/'));
      if (nonZeroIndex.isEven && nonZeroIndex != newValueString.length && !contains) {
        valueToReturn += '/';
      }
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}

/// A [TextInputFormatter] that formats the input text as a card number.
///
/// This formatter adds spaces after every 4 digits in the input text.
/// It is typically used for formatting credit card numbers.
class CardNumberTextInputFormatter extends TextInputFormatter {
  CardNumberTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isNotEmpty) {
      final newValueString = newValue.text;
      
      if (newValue.selection.baseOffset == 0) {
        return newValue;
      }

      final stringBuff = StringBuffer();
      for (var i = 0; i < newValueString.length; i++) {
        stringBuff.write(newValueString[i]);
        final nonZeroIndex = i + 1;
        if (nonZeroIndex % 4 == 0 && nonZeroIndex != newValueString.length) {
          stringBuff.write(' ');
        }
      }

      return newValue.copyWith(
        text: stringBuff.toString(),
        selection: TextSelection.collapsed(offset: stringBuff.length),
      );
    }
    return newValue;
  }
}
