import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserPage extends StatefulWidget {
  final int userId;
  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService api = ApiService();
  User? user;
  bool loading = true;
  String? error;

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
        // 只有已登录时才加载用户数据
        final targetUserId = userService.currentUserId!;
        final u = await api.fetchUser(targetUserId);
        if (!mounted) return;
        setState(() {
          user = u;
          loading = false;
        });
      } else {
        // 未登录时不加载用户数据，直接设置为完成状态
        if (!mounted) return;
        setState(() {
          user = null;
          loading = false;
        });
        // 标记为已初始化但未登录
        if (!userService.initialized) {
          userService.markInitialized();
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
      // 即使出错也标记为已初始化
      if (!userService.initialized) {
        userService.markInitialized();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (error != null) return Scaffold(body: Center(child: Text('错误：$error')));

        final bool isLoggedIn = userService.isLoggedIn;

        return Scaffold(
          appBar: AppBar(title: Text(user?.nickName ?? user?.username ?? '用户')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLoggedIn && user?.avatarUrl != null)
                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(user!.avatarUrl!))
                else
                  const CircleAvatar(radius: 40, child: Icon(Icons.person_outline, size: 40)),
                const SizedBox(height: 16),
                Text(
                  isLoggedIn
                      ? (user?.nickName ?? user?.username ?? '用户')
                      : '请登录账号',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (isLoggedIn && user != null)
                  Text(
                    '总里程: ${user?.totalDistance ?? 0} · 跑步次数: ${user?.totalRuns ?? 0}',
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    '登录后查看您的个人信息',
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),
                Text(
                  isLoggedIn ? '已登录' : '未登录',
                  style: TextStyle(
                    color: isLoggedIn ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                if (isLoggedIn) ...[
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/runs', arguments: userService.currentUserId),
                    child: const Text('查看跑步记录'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/achievements', arguments: userService.currentUserId),
                    child: const Text('查看成就'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      userService.logout();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已退出')));
                      _load(); // 重新加载为未登录状态
                    },
                    child: const Text('退出/切换账号'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () async {
                      final usernameController = TextEditingController();
                      final passwordController = TextEditingController();
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('登录'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: usernameController, decoration: const InputDecoration(labelText: '用户名')),
                              TextField(controller: passwordController, decoration: const InputDecoration(labelText: '密码'), obscureText: true),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('登录')),
                          ],
                        ),
                      );
                      if (result == true) {
                        try {
                          final userData = await api.login(usernameController.text, passwordController.text);
                          final loginUser = User.fromJson(userData);
                          userService.setUser(loginUser);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('登录成功')));
                          _load();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('登录失败: $e')));
                        }
                      }
                    },
                    child: const Text('登录'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final usernameController = TextEditingController();
                      final passwordController = TextEditingController();
                      final emailController = TextEditingController();
                      final nickNameController = TextEditingController();
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('注册'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(controller: usernameController, decoration: const InputDecoration(labelText: '用户名')),
                                TextField(controller: passwordController, decoration: const InputDecoration(labelText: '密码'), obscureText: true),
                                TextField(controller: emailController, decoration: const InputDecoration(labelText: '邮箱')),
                                TextField(controller: nickNameController, decoration: const InputDecoration(labelText: '昵称')),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('注册')),
                          ],
                        ),
                      );
                      if (result == true) {
                        try {
                          final userData = await api.register(
                            usernameController.text,
                            passwordController.text,
                            emailController.text,
                            nickNameController.text,
                          );
                          final registerUser = User.fromJson(userData);
                          userService.setUser(registerUser);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('注册成功')));
                          _load();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('注册失败: $e')));
                        }
                      }
                    },
                    child: const Text('注册'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}