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

  static RequiredValidator loginPassowrdValidator = RequiredValidator(
    errorText: ValidateTexts.emptyPassword,
  );

  static MultiValidator phoneValidator = MultiValidator(
    [
      RequiredValidator(errorText: ValidateTexts.emptyPhoneNumber),
      PatternValidator(
          r'(\+90?|\d)( |-|\.)? ?\(?\(?(\d{3}\)?|\d{3})( |-|\.)? ?\d{3}( |-|\.)? ?\d{2}( |-|\.)?\d{2}',
          errorText: ValidateTexts.phoneNumberNotValid),
    ],
  );

  static RequiredValidator nameValidator = RequiredValidator(
    errorText: ValidateTexts.emptyName,
  );
}
