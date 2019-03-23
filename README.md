# InstallScript-of-Pan
YouGuan网盘的一键部署脚本

# 起因
YouGuan网盘作为我本科的毕设项目。其主要目的是，希望做一个非营利性的个人网盘。尽管暂时不能预料它的发展方向，以及存活周期——但事实上，这些并不重要。正如《黑客与画家》的作者所说：“程序员并不知道他将会做出什么。”

# 仓库说明
InstallScript-of-Pan为YouGuan网盘提供一键部署脚本。

- yun_install.sh 负责一键安装
- uninstall.sh 负责一键卸载

# 更新日志

**019.3.23**
1. 增加 uninstall.sh 脚本，负责卸载响应环境
2. 对 yun_install.sh 脚本中，增加 gcc 安装，增加对安装环境判断。如果所需程序已在环境中，则不再重复安装。

**019.3.18**
1. GitHub上创建仓库
2. 添加 yun_install.sh 脚本，负责安装 libfastcommon fastdfs (安装成功后，可以通过`fdfs_test`命令查看)
