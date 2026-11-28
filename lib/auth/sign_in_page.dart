import 'package:flutter/material.dart';

import 'account_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
    this.service = const UnconfiguredAccountService(),
  });

  final AccountService service;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool busy = false;
  bool creatingAccount = false;
  bool hidePassword = true;
  String? message;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  Future<void> submit({bool reset = false}) async {
    if (busy) return;
    FocusScope.of(context).unfocus();
    setState(() => message = null);
    if (reset) {
      final error = validateEmail(email.text);
      if (error != null) {
        setState(() => message = error);
        return;
      }
    } else if (!form.currentState!.validate()) {
      return;
    }
    setState(() => busy = true);
    try {
      if (reset) {
        await widget.service.resetPassword(email.text.trim());
        if (!mounted) return;
        setState(() {
          message = 'If this address has an account, check your inbox for a reset link.';
        });
      } else {
        final account = creatingAccount
            ? await (widget.service as RegistrationService).register(
                email.text.trim(),
                password.text,
              )
            : await widget.service.signIn(email.text.trim(), password.text);
        if (!mounted) return;
        Navigator.of(context).pop(account);
      }
    } on AccountFailure catch (error) {
      if (mounted) setState(() => message = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => message = 'We could not reach account services. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your account')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'A place for your study days.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              widget.service is UnconfiguredAccountService
                  ? 'Account setup preview. Firebase sign-in, Google sign-in and registration are not connected yet.'
                  : creatingAccount
                  ? 'Create an email account for your study days.'
                  : 'Sign in with your email account. Google sign-in is coming next.',
            ),
            const SizedBox(height: 24),
            if (message != null) ...[
              Semantics(liveRegion: true, child: Text(message!)),
              const SizedBox(height: 16),
            ],
            Form(
              key: form,
              child: AutofillGroup(
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('account-email'),
                      controller: email,
                      enabled: !busy,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('account-password'),
                      controller: password,
                      enabled: !busy,
                      obscureText: hidePassword,
                      autofillHints: [
                        creatingAccount
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      enableSuggestions: false,
                      autocorrect: false,
                      onFieldSubmitted: (_) => submit(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          tooltip: hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: busy
                              ? null
                              : () => setState(
                                  () => hidePassword = !hidePassword,
                                ),
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: creatingAccount
                          ? validateNewPassword
                          : validateSignInPassword,
                    ),
                    if (creatingAccount) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('account-confirmation'),
                        controller: confirmation,
                        enabled: !busy,
                        obscureText: hidePassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                        validator: (value) =>
                            value != password.text ||
                                value == null ||
                                value.isEmpty
                            ? 'Passwords must match.'
                            : null,
                        onFieldSubmitted: (_) => submit(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: busy ? null : () => submit(),
                      child: Text(
                        busy
                            ? 'Please wait…'
                            : creatingAccount
                            ? 'Create account'
                            : 'Sign in',
                      ),
                    ),
                    TextButton(
                      onPressed: busy ? null : () => submit(reset: true),
                      child: const Text('Reset password'),
                    ),
                    if (widget.service is RegistrationService)
                      TextButton(
                        key: const Key('account-mode'),
                        onPressed: busy
                            ? null
                            : () {
                                form.currentState?.reset();
                                password.clear();
                                confirmation.clear();
                                setState(() {
                                  creatingAccount = !creatingAccount;
                                  message = null;
                                });
                              },
                        child: Text(
                          creatingAccount
                              ? 'Use an existing account'
                              : 'Create an email account',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
