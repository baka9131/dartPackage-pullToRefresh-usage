import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = useState(["1", "2", "3", "4", "5", "6", "7", "8"]);
    // refresh 컨트롤러
    final refreshController = useState(RefreshController(initialRefresh: false)).value;

    // 위에서 스크롤
    void onRefresh() async {
      // 네트워크 모방 딜레이
      await Future.delayed(const Duration(milliseconds: 1000));
      refreshController.refreshCompleted();
    }

    // 아래에서 스크롤 (새로운 데이터 로딩)
    void onLoading() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      // items.value.add({items.value.length + 1}.toString());
      final newItems = List<String>.from(items.value)..add((items.value.length + 1).toString());
      items.value = newItems;
      refreshController.loadNoData();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pull to refresh'),
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: SmartRefresher(
        onRefresh: onRefresh,
        onLoading: onLoading,
        enablePullDown: true,
        enablePullUp: true,
        controller: refreshController,
        header: const WaterDropMaterialHeader(),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("위로 끌기");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("데이터 불러오기 실패!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("더 많은 내용 불러오기");
            } else {
              body = const Text("추가할 데이터 없음");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView.builder(
          itemExtent: 50.0,
          itemCount: items.value.length,
          itemBuilder: (context, index) => Card(
            child: Center(
              child: Text(
                items.value[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
