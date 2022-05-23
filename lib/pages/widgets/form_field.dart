import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/storage/validation_storage.dart';

@immutable
class EmailFormField extends StatelessWidget {
  String? title;
  TextInputType keyboardType;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? enabled;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  TextInputAction? textInputAction;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;

  EmailFormField({
    Key? key,
    this.enabled,
    this.autofillHints = const [AutofillHints.email],
    this.decoration,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.textInputAction,
    this.keyboardType = TextInputType.emailAddress,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHints,
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      key: key,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      validator: ValidationConstants.emailValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: HintTexts.emailHint,
        prefixIcon: const Icon(Icons.email_outlined),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  String? title;
  TextInputType keyboardType;
  TextEditingController? controller;
  bool? obscureText;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? enabled;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  TextInputAction? textInputAction;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;

  PasswordFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.autofillHints,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.controller,
    this.title,
    this.textInputAction,
    this.decoration,
    this.keyboardType = TextInputType.visiblePassword,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    _isPasswordVisible = false;
    super.initState();
  }

  void isVisible() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      obscureText: !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: HintTexts.passwordHint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(
              () {
                isVisible();
              },
            );
          },
        ),
      ),
    );
  }
}

class ConfirmPasswordFormField extends StatefulWidget {
  String? title;
  TextInputType keyboardType;
  TextEditingController? controller;
  bool? obscureText;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? enabled;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  TextInputAction? textInputAction;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;

  ConfirmPasswordFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.autofillHints,
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.controller,
    this.title,
    this.textInputAction,
    this.decoration,
    this.keyboardType = TextInputType.visiblePassword,
  }) : super(key: key);

  @override
  State<ConfirmPasswordFormField> createState() =>
      _ConfirmPasswordFormFieldState();
}

class _ConfirmPasswordFormFieldState extends State<ConfirmPasswordFormField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    _isPasswordVisible = false;
    super.initState();
  }

  void isVisible() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      obscureText: !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: HintTexts.passwordHint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(
              () {
                isVisible();
              },
            );
          },
        ),
      ),
    );
  }
}

class PhoneFormField extends StatelessWidget {
  String? title;
  TextInputType keyboardType;
  TextEditingController? controller;
  bool? obscureText;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? enabled;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;

  PhoneFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.autofillHints = const [AutofillHints.telephoneNumber],
    this.controller,
    this.title,
    this.keyboardType = TextInputType.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      autofillHints: autofillHints,
      onChanged: onChanged,
      obscureText: false,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      validator: ValidationConstants.phoneValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: HintTexts.phoneNumberHint,
        prefixIcon: const Icon(Icons.phone_android_outlined),
      ),
    );
  }
}

class NameFormField extends StatelessWidget {
  String? title;
  TextInputType keyboardType;
  TextEditingController? controller;
  bool? obscureText;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  bool? enabled;
  AutovalidateMode? autovalidateMode;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;

  NameFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.autofillHints = const [AutofillHints.name],
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.decoration,
    this.controller,
    this.title,
    this.keyboardType = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      autofillHints: autofillHints,
      controller: controller,
      obscureText: false,
      keyboardType: keyboardType,
      validator: ValidationConstants.nameValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: HintTexts.nameHint,
        prefixIcon: const Icon(Icons.person_outline),
      ),
    );
  }
}
