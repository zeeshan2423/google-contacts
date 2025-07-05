import 'package:google_contacts/core/constants/imports.dart';

class ValueListenableBuilder3<A, B, C, D> extends StatelessWidget {
  const ValueListenableBuilder3({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.builder,
    super.key,
  });

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final ValueListenable<D> fourth;
  final Widget Function(BuildContext, A, B, C, D, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, c, _) {
                return ValueListenableBuilder<D>(
                  valueListenable: fourth,
                  builder: (context, d, child) =>
                      builder(context, a, b, c, d, child),
                );
              },
            );
          },
        );
      },
    );
  }
}
