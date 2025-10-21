import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({Key? key, this.userId = 1}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();
  User? user;
  bool loading = false;
  String? error;
  bool? lastLoginStatus; // 追踪登录状态变化
  int? lastUserId; // 追踪用户ID变化

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userService = Provider.of<UserService>(context, listen: false);
      // 只有已登录时才加载用户数据
      if (userService.isLoggedIn) {
        _loadUser();
      } else {
        // 标记为已初始化但未登录
        userService.markInitialized();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userService = Provider.of<UserService>(context);
    final currentUserId = userService.currentUserId;
    final currentLoginStatus = userService.isLoggedIn;

    // 检查登录状态变化
    if (lastLoginStatus != currentLoginStatus) {
      lastLoginStatus = currentLoginStatus;

      if (currentLoginStatus) {
        // 刚登录，加载用户数据
        lastUserId = currentUserId;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadUser();
        });
      } else {
        // 刚退出，清除用户数据
        lastUserId = null;
        setState(() {
          user = null;
          loading = false;
          error = null;
        });
      }
    } else if (currentLoginStatus && lastUserId != currentUserId) {
      // 已登录状态下用户ID变化
      lastUserId = currentUserId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUser();
      });
    }
  }

  Future<void> _loadUser() async {
    if (!mounted) return;

    final userService = Provider.of<UserService>(context, listen: false);
    if (!userService.isLoggedIn) return; // 未登录时不加载

    setState(() { loading = true; error = null; });

    try {
      final targetUserId = userService.currentUserId!;
      final u = await api.fetchUser(targetUserId);
      if (!mounted) return;
      setState(() {
        user = u;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Widget _avatar() {
    if (user == null) {
      return const CircleAvatar(radius: 36, child: Icon(Icons.person_outline, size: 40));
    }

    final url = user?.avatarUrl;
    if (url != null && url.isNotEmpty && (url.startsWith('http') || url.startsWith('https'))) {
      return CircleAvatar(radius: 36, backgroundImage: NetworkImage(url));
    }
    final label = (user?.nickName ?? user?.username ?? '?');
    return CircleAvatar(radius: 36, child: Text(label.isEmpty ? '?' : label[0].toUpperCase()));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        if (loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('主页')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('错误：$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadUser(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('主页'),
            actions: [
              if (userService.isLoggedIn)
                TextButton(
                  onPressed: () {
                    userService.logout();
                    // 登录状态变化会触发 didChangeDependencies
                  },
                  child: const Text('退出', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                _avatar(),
                const SizedBox(height: 16),
                Text(
                  userService.isLoggedIn
                      ? (user?.nickName ?? user?.username ?? '用户')
                      : '请登录账号',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (userService.isLoggedIn && user != null)
                  Text(
                    '总里程: ${user?.totalDistance ?? 0} · 跑步次数: ${user?.totalRuns ?? 0}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    '登录后查看您的跑步数据',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: userService.isLoggedIn ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: userService.isLoggedIn ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    userService.isLoggedIn ? '已登录' : '未登录',
                    style: TextStyle(
                      color: userService.isLoggedIn ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (userService.isLoggedIn) ...[
                  const SizedBox(height: 8),
                  Text(
                    '当前用户ID: ${userService.currentUserId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 40),
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildActionButton(
                        icon: Icons.directions_run,
                        label: '跑步页',
                        onPressed: () => Navigator.pushNamed(context, '/map'),
                      ),
                      if (userService.isLoggedIn) ...[
                        _buildActionButton(
                          icon: Icons.list,
                          label: '跑步记录',
                          onPressed: () => Navigator.pushNamed(context, '/runs', arguments: userService.currentUserId),
                        ),
                        _buildActionButton(
                          icon: Icons.emoji_events,
                          label: '成就',
                          onPressed: () => Navigator.pushNamed(context, '/achievements', arguments: userService.currentUserId),
                        ),
                      ],
                      _buildActionButton(
                        icon: Icons.group,
                        label: '圈子',
                        onPressed: () => Navigator.pushNamed(context, '/communities'),
                      ),
                      _buildActionButton(
                        icon: Icons.leaderboard,
                        label: '排行榜',
                        onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
                      ),
                      _buildActionButton(
                        icon: Icons.person,
                        label: '个人主页',
                        onPressed: () => Navigator.pushNamed(context, '/user', arguments: userService.currentUserId ?? widget.userId),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}