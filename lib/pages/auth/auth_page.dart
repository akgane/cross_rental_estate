import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/pages/auth/widgets/auth_elevated_button.dart';
import 'package:rental_estate_app/pages/auth/widgets/auth_textform.dart';
import 'package:rental_estate_app/routes/app_routes.dart';
import 'package:rental_estate_app/widgets/splash_screen.dart';

import '../../providers/auth_provider.dart';

class AuthPage extends StatefulWidget {
  final bool isRegistering;

  const AuthPage({Key? key,
    this.isRegistering = false
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  String? errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      if (widget.isRegistering) {
        await authProvider.register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _usernameController.text.trim()
        );
      } else {
        await authProvider.login(
            _emailController.text.trim(),
            _passwordController.text.trim()
        );
      }

      if (authProvider.user != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      } else {
        throw Exception('Login failed: user is null');
      }

    } catch (e) {
      showDialog(context: context, builder: (_) =>
          AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ОК'),
              ),
            ],
          )
      );
    }finally{
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person_outline),
            label: Text(loc!.a_guest_mode),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
                arguments: {'guestMode': true}
              );
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            color: theme.scaffoldBackgroundColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                    widget.isRegistering
                                                        ? loc!.a_register
                                                        : loc!.a_login,
                                                    style: theme.textTheme
                                                        .titleLarge
                                                ),
                                              ]
                                          ),
                                          AuthTextFormField(
                                              formKey: ValueKey('email'),
                                              decorationLabel: loc.a_email,
                                              controller: _emailController,
                                              keyboardType: TextInputType
                                                  .emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    !value.contains('@'))
                                                  return loc
                                                      .a_enter_correct_email;
                                                return null;
                                              }),
                                          AuthTextFormField(
                                              formKey: ValueKey('password'),
                                              decorationLabel: loc.a_password,
                                              controller: _passwordController,
                                              obsecure: true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.length < 6)
                                                  return loc
                                                      .a_password_6_symbols;
                                                return null;
                                              }
                                          ),
                                          if(widget.isRegistering)...[
                                            AuthTextFormField(
                                                formKey: ValueKey('username'),
                                                decorationLabel: 'Username',
                                                controller: _usernameController,
                                                //TODO loc
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.length < 4)
                                                    return "Short username"; //TODO loc
                                                  return null;
                                                }
                                            )
                                          ],

                                          SizedBox(height: 16,),

                                          _isLoading
                                              ? SplashScreen()
                                              : AuthElevatedButton(
                                              text: widget.isRegistering
                                                  ? loc.a_register
                                                  : loc.a_login,
                                              theme: theme,
                                              onPressed: _submit),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: theme.textTheme
                                                  .bodyLarge,
                                            ),
                                            onPressed: () {
                                              Navigator
                                                  .of(context)
                                                  .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AuthPage(
                                                            isRegistering: !widget
                                                                .isRegistering,)
                                                  )
                                              );
                                            },
                                            child: Text(
                                              widget.isRegistering
                                                  ? loc.a_has_account
                                                  : loc.a_not_registered,
                                            ),
                                          ),
                                        ]
                                    )
                                )
                            )
                        ),
                      ]
                  )
              )
          )
      )
    );
  }
}