/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'package:cazuapp/components/etc.dart';
import 'package:formz/formz.dart';

enum PhoneCodeValidationError { invalid }

class PhoneCode extends FormzInput<String, PhoneCodeValidationError> {
  const PhoneCode.pure([super.value = '']) : super.pure();
  const PhoneCode.dirty([super.value = '']) : super.dirty();

  @override
  PhoneCodeValidationError? validator(String? value) {
    if (value!.isEmpty || value.length > 3 || !Etc.isNumeric(value)) {
      return PhoneCodeValidationError.invalid;
    } else {
      return null;
    }
  }
}
