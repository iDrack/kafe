import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/*    final _searchController = useTextEditingController();
    final chosenPollType = useState(PollType.pollActive);*/
    final searchValue = useState("");
    final isNotEmpty = useState(false);
/*

    useEffect(() {
      _searchController.text = searchValue.value;
      _searchController.addListener(() {
        isNotEmpty.value = _searchController.text.isNotEmpty;
      });
      return _searchController.dispose;
    }, [_searchController]);
*/

    return Column(
      children: [
        //Ajouter une search bar ici
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("wip")
          ],
        ),
      ],
    );
  }
}

