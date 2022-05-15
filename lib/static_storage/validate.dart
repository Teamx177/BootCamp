// import 'package:hrms/static_storage/texts.dart';

// class FormFieldValidators {
//   String? emailEmpty(String? data) {
//     if ((data?.isNotEmpty ?? false)) {
//       return null;
//     } else {
//       return ValidateTexts.emptyEmail;
//     }
//   }

//   String? passwordEmpty(String? data) {
//     if ((data?.isNotEmpty ?? false)) {
//       return ValidateTexts.emptyPassword;
//     }
//     if (data!.trim().length < 8) {
//       return ValidateTexts.passwordLenght;
//     } else {
//       return null;
//     }
//   }

//   String? nameEmpty(String? data) {
//     return (data?.isNotEmpty ?? false) ? null : ValidateTexts.emptyName;
//   }

//   String? validateEmail(
//     String? value,
//   ) {
//     RegExp regex = RegExp(r'\S+@\S+\.\S+');
//     if ((value?.isNotEmpty ?? false)) {
//       return ValidateTexts.emptyEmail;
//     }
//     if (!regex.hasMatch(value!)) {
//       return ValidateTexts.emailNotValid;
//     } else {
//       return ValidateTexts.emptyEmail;
//     }
//   }
// }

import 'package:form_field_validator/form_field_validator.dart';
import 'package:hrms/static_storage/texts.dart';

class ValidationConstants {
  static MultiValidator singUpPasswordValidator = MultiValidator([
    RequiredValidator(errorText: ValidateTexts.emptyPassword),
    MinLengthValidator(8, errorText: ValidateTexts.passwordLenght),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: ValidateTexts.passwordCharacter)
  ]);

  static MultiValidator emailValidator = MultiValidator(
    [
      RequiredValidator(errorText: ValidateTexts.emptyEmail),
      EmailValidator(errorText: ValidateTexts.emailNotValid),
    ],
  );

  static MatchValidator passwordMatchValidator = MatchValidator(
    errorText: ValidateTexts.passwordNotMatch,
  );

  static RequiredValidator loginPassowrdValidator = RequiredValidator(
    errorText: ValidateTexts.emptyPassword,
  );
}
