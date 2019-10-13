import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TaoCache {
  String _cacheSizeStr;
  static TaoCache instance;

  static shareInstance() {
    if (null == instance) {
      instance = TaoCache();
    }
    return instance;
  }

  ///加载缓存
  Future<String> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      _cacheSizeStr = _renderSize(value);
    } catch (err) {
      print(err);
    }
    return _cacheSizeStr;
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  //清理缓存
  Future<String> clearCache() async {
    //此处展示加载loading
    String temp = await loadCache();
    try {
      Directory tempDir = await getTemporaryDirectory();
      await delDir(tempDir);
      temp = await loadCache();
    } catch (e) {
      print(e);
    } finally {
      //此处隐藏加载loading
    }
    return temp;
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  ///格式化文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
