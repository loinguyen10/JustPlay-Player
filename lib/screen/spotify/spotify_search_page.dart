import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/helper/navigator_helper.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/screen/spotify/spotify_result_page.dart';
import 'package:flutter_justplay_player/screen/spotify/spotify_vm.dart';
import 'package:flutter_justplay_player/style/color.dart';
import 'package:flutter_justplay_player/widget/app_bar.dart';
import 'package:provider/provider.dart';

class SpotifySearchPage extends StatefulWidget {
  const SpotifySearchPage({super.key});

  @override
  State<SpotifySearchPage> createState() => _SpotifySearchPageState();
}

class _SpotifySearchPageState extends State<SpotifySearchPage> {
  final vm = SpotifyViewModel();

  @override
  void initState() {
    vm.focusNode.addListener(() => stateChange());
    super.initState();
  }

  @override
  void dispose() {
    if (vm.focusNode.hasFocus) {
      if (vm.resultLength > 0) {
        vm.searchTextController.text = vm.lastSearch;
      }
      vm.focusNode.unfocus();
    }

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
            backgroundColor: spPrimaryColor,
            foregroundColor: Colors.black,
            leading: InkWell(
              onTap: () {
                if (vm.resultLength > 0) {
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
                  // await vm.autoCompleteSuggestions();
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
              SpotifyResultPage(vm: vm),
              ItemCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                cardColor: Colors.red,
                child: Row(
                  children: [
                    buildTabBar(vm.trackResult, 'Track'),
                    buildTabBar(vm.artistResult, 'Artist'),
                    buildTabBar(vm.playlistResult, 'Playlist'),
                    buildTabBar(vm.albumResult, 'Album'),
                  ],
                ),
              ),
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
              // await vm.autoCompleteSuggestions();
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

  buildTabBar(List list, String title) {
    return ItemCard(
      onTap: () {
        vm.result = list;
        stateChange();
      },
      borderColor: Colors.black,
      child: Text(title),
    );
  }
}
