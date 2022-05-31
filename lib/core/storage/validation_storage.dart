import 'package:form_field_validator/form_field_validator.dart';
import 'package:hrms/core/storage/text_storage.dart';

class ValidationConstants {
  static MultiValidator singUpPasswordValidator = MultiValidator([
    RequiredValidator(errorText: ValidateTexts.emptyPassword),
    MinLengthValidator(8, errorText: ValidateTexts.passwordLenght),
    PatternValidator(r'(?=.*?[#?!@$%^&*-.])',
        errorText: ValidateTexts.passwordCharacter)
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

  static RequiredValidator loginPasswordValidator = RequiredValidator(
    errorText: ValidateTexts.emptyPassword,
  );

  static MultiValidator phoneValidator = MultiValidator(
    [
      RequiredValidator(errorText: ValidateTexts.emptyPhoneNumber),
      PatternValidator(r'^5(?:9)?[0-9]{9}$',
          errorText: ValidateTexts.phoneNumberNotValid),
    ],
  );

  static RequiredValidator nameValidator = RequiredValidator(
    errorText: ValidateTexts.emptyName,
  );
}
