import 'package:chatter/core/helper/show_snack_bar.dart';
import 'package:chatter/core/widgets/loading_indicator.dart';
import 'package:chatter/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:chatter/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage("https://www.gravatar.com/avatar/placeholder"),
          ),
          const SizedBox(height: 16),
          Text(
            "John Doe",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "john.doe@example.com",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.routeName,
                  (route) => false,
                );
              } else if (state is AuthFailure) {
                showSnackBar(context, state.errMessage);
              }
            },
            builder: (context, state) {
              return state is AuthLoading
                  ? LoadingIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logOut();
                      },
                      child: const Text('Logout'),
                    );
            },
          ),
        ],
      ),
    );
  }
}
