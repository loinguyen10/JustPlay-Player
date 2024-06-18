import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/helper/navigator_helper.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/screen/youtube/search/youtube_result_page.dart';
import 'package:flutter_justplay_player/screen/youtube/search/youtube_search_vm.dart';
import 'package:flutter_justplay_player/widget/app_bar.dart';
import 'package:provider/provider.dart';

class YoutubeSearchPage extends StatefulWidget {
  const YoutubeSearchPage({super.key});

  @override
  State<YoutubeSearchPage> createState() => _YoutubeSearchPageState();
}

class _YoutubeSearchPageState extends State<YoutubeSearchPage> {
  final vm = YoutubeSearchViewModel();

  @override
  void initState() {
    vm.focusNode.addListener(() => stateChange());
    super.initState();
  }

  @override
  void dispose() {
    vm.focusNode.dispose();
    vm.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      builder: (context, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBarPlayer(
            leading: InkWell(
              onTap: () {
                if (vm.result.isNotEmpty) {
                  if (!vm.focusNode.hasFocus) {
                    NavigatorHelper().popBack();
                  } else {
                    vm.searchTextController.text = vm.lastSearch;
                  }
                } else {
                  NavigatorHelper().popBack();
                }
                vm.focusNode.unfocus();
              },
              child: const Icon(Icons.arrow_back),
            ),
            title: InputText(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              autoFocus: true,
              controller: vm.searchTextController,
              hintText: 'Tìm kiếm',
              textAlignVertical: TextAlignVertical.center,
              focusNode: vm.focusNode,
              suffixIcon: vm.searchTextController.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        if (!vm.focusNode.hasFocus) {
                          vm.focusNode.requestFocus();
                        }
                        vm.searchTextController.clear();
                        vm.autoComplete.clear();
                        stateChange();
                      },
                      child: const Icon(Icons.cancel_outlined),
                    )
                  : space0,
              onChanged: (value) async {
                stateChange();
                if (value.isNotEmpty) {
                  await vm.autoCompleteSuggestions();
                } else {
                  vm.autoComplete.clear();
                }
                stateChange();
              },
              onFieldSubmitted: (value) async {
                await vm.search();
                stateChange();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: !vm.focusNode.hasFocus
                    ? const Icon(
                        Icons.settings,
                      )
                    : space0,
              )
            ],
          ),
          body: Stack(
            children: [
              YoutubeResultPage(vm: vm),
              Visibility(
                visible: vm.focusNode.hasFocus,
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: vm.autoComplete.length,
                    itemBuilder: (context, index) => _buildItem(vm.autoComplete[index]),
                  ),
                ),
              )
            ],
          ),
        ));
      },
    );
  }

  _buildItem(String value) {
    final item = ItemCard(
      onTap: () async {
        vm.searchTextController.text = value;
        vm.focusNode.unfocus();
        await vm.search();
        stateChange();
      },
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.search),
          space12,
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          space12,
          InkWell(
            onTap: () async {
              vm.searchTextController.text = value;
              await vm.autoCompleteSuggestions();
            },
            child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_upward_outlined,
                )),
          ),
        ],
      ),
    );
    return item;
  }
}
