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
  void Function(String?)? onSaved;
  void Function(String)? onFieldSubmitted;
  String? hintText;

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
    this.hintText,
    this.controller,
    this.onFieldSubmitted,
    this.onSaved,
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
      onSaved: onSaved,
      key: key,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      validator: ValidationConstants.emailValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyText1,
        hintText: hintText,
        prefixIcon: const Icon(Icons.email_outlined),
      ),
    );
  }
}

class CityFormField extends StatelessWidget {
  String? initialValue;
  ValueChanged<String>? onChanged;
  String? title;
  TextInputType keyboardType;
  bool? enabled;
  String? hintText;

  CityFormField({
    Key? key,
    this.enabled,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      key: key,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyText1,
        hintText: hintText,
        prefixIcon: const Icon(Icons.location_on_outlined),
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
  void Function(String?)? onSaved;
  String? hintText;
  Widget? suffixIcon;

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
    this.hintText,
    this.suffixIcon,
    this.title,
    this.textInputAction,
    this.onSaved,
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
      maxLength: 14,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      obscureText: !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      validator: widget.validator,
      key: widget.key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: widget.initialValue?.isEmpty ?? true
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(
                    () {
                      isVisible();
                    },
                  );
                },
              )
            : null,
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
  void Function(String?)? onSaved;
  String? hintText;

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
    this.onSaved,
    this.hintText,
    this.keyboardType = TextInputType.visiblePassword,
  }) : super(key: key);

  @override
  State<ConfirmPasswordFormField> createState() => _ConfirmPasswordFormFieldState();
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
      maxLength: 14,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      obscureText: !_isPasswordVisible,
      onSaved: widget.onSaved,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      textInputAction: TextInputAction.done,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: 'Şifrenizi tekrar giriniz',
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
  TextInputAction? textInputAction;
  void Function(String?)? onSaved;
  String? hintText;

  PhoneFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
    this.textInputAction,
    this.hintText,
    this.onChanged,
    this.obscureText,
    this.autofillHints = const [AutofillHints.telephoneNumber],
    this.controller,
    this.title,
    this.onSaved,
    this.keyboardType = TextInputType.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 10,
      initialValue: initialValue,
      autofillHints: autofillHints,
      onChanged: onChanged,
      obscureText: false,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      validator: ValidationConstants.phoneValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
         hintStyle: Theme.of(context).textTheme.bodyText1,
        hintText: hintText,
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
  TextInputAction? textInputAction;
  InputDecoration? decoration = const InputDecoration();
  Iterable<String>? autofillHints;
  void Function(String?)? onSaved;
  String? hintText;

  NameFormField({
    Key? key,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.hintText,
    this.autofillHints = const [AutofillHints.name],
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.decoration,
    this.controller,
    this.title,
    this.onSaved,
    this.keyboardType = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      autofillHints: autofillHints,
      onSaved: onSaved,
      controller: controller,
      textInputAction: TextInputAction.done,
      obscureText: false,
      keyboardType: keyboardType,
      validator: ValidationConstants.nameValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
         hintStyle: Theme.of(context).textTheme.bodyText1,
        hintText: hintText,
        prefixIcon: const Icon(Icons.person_outline),
      ),
    );
  }
}
