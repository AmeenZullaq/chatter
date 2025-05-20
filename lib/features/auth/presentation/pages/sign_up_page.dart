
import 'package:chatter/core/helper/show_snack_bar.dart';
import 'package:chatter/core/widgets/loading_indicator.dart';
import 'package:chatter/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:chatter/features/home/presentation/pages/home_page.dart';
import 'package:chatter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/Signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _usernameController;

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InjectionContainer.getIt.get<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Sign Up')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Username is required'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : null,
                ),
                SizedBox(height: 24),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushNamed(context, HomePage.routeName);
                    } else if (state is AuthFailure) {
                      showSnackBar(context, state.errMessage);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return LoadingIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                                username: _usernameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                      child: Text('Sign Up'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
