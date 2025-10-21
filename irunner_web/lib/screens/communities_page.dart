import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../models/community.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({Key? key}) : super(key: key);

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  final ApiService api = ApiService();
  List<Community>? items;
  bool loading = true;
  String? error;
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userService = Provider.of<UserService>(context, listen: false);
    setState(() { loading = true; });

    try {
      if (userService.isLoggedIn) {
        final list = await api.fetchCommunities(userId: userService.currentUserId);
        setState(() {
          items = list.cast<Community>();
          loading = false;
        });
      } else {
        setState(() {
          items = [];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _search(String keyword) async {
    final userService = Provider.of<UserService>(context, listen: false);
    if (!userService.isLoggedIn) return;

    setState(() { loading = true; });
    try {
      final list = await api.searchCommunities(keyword, userId: userService.currentUserId);
      setState(() {
        items = list.cast<Community>();
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _createCommunity() async {
    final userService = Provider.of<UserService>(context, listen: false);
    if (!userService.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先登录')));
      return;
    }

    final nameController = TextEditingController();
    final descController = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('创建圈子'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: '圈子名称')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: '简介')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () async {
              try {
                await api.createCommunity(
                  name: nameController.text,
                  description: descController.text,
                  creatorId: userService.currentUserId!,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('创建成功')));
                _load();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('创建失败: $e')));
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (error != null) return Scaffold(body: Center(child: Text('错误：$error')));

        if (!userService.isLoggedIn) {
          return Scaffold(
            appBar: AppBar(title: const Text('圈子')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '请登录账号',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '登录后查看和管理您的圈子',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('圈子'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _createCommunity,
                tooltip: '创建圈子',
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '搜索圈子',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => searchKeyword = v,
                  onSubmitted: (v) => _search(v),
                ),
              ),
              Expanded(
                child: items?.isEmpty == true
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('暂无圈子', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
                    : ListView.separated(
                  itemCount: items?.length ?? 0,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final c = items![i];
                    return ListTile(
                      leading: c.imageUrl != null && c.imageUrl!.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(c.imageUrl!))
                          : const CircleAvatar(child: Icon(Icons.group)),
                      title: Text(c.name),
                      subtitle: Text('${c.memberCount ?? 0} 成员'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          c.isJoined == true
                              ? ElevatedButton(
                            onPressed: () async {
                              setState(() => loading = true);
                              try {
                                await api.leaveCommunity(c.id, userService.currentUserId!);
                                setState(() {
                                  c.isJoined = false;
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已退出圈子')));
                              } catch (e) {
                                setState(() => loading = false);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('退出失败: $e')));
                              }
                            },
                            child: const Text('退出'),
                          )
                              : ElevatedButton(
                            onPressed: () async {
                              setState(() => loading = true);
                              try {
                                await api.joinCommunity(c.id, userService.currentUserId!);
                                setState(() {
                                  c.isJoined = true;
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入圈子')));
                              } catch (e) {
                                setState(() => loading = false);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加入失败: $e')));
                              }
                            },
                            child: const Text('加入'),
                          ),
                          if (c.creatorId == userService.currentUserId)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: '删除圈子',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('确认删除'),
                                    content: const Text('确定要删除该圈子吗？此操作不可恢复。'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  setState(() => loading = true);
                                  try {
                                    await api.deleteCommunity(c.id);
                                    setState(() {
                                      items!.removeAt(i);
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('删除成功')));
                                  } catch (e) {
                                    setState(() => loading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('删除失败: $e')));
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}