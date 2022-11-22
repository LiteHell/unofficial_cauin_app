import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:unofficial_cauin_app/cauin/cauin.dart';
import 'package:unofficial_cauin_app/pages/cauinPopularArticles.dart';

class FirstLoading extends StatelessWidget {
  const FirstLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CauinPopularArticle();
  }
}
