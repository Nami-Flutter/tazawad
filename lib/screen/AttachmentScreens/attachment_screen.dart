import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';

// import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tazawad/AppLocalizations.dart';
import 'package:tazawad/models/OrderModel.dart';
import 'package:tazawad/network/rest_apis.dart';
import 'package:tazawad/utils/AppBarWidget.dart';
import 'package:tazawad/utils/AppWidget.dart';
import 'package:tazawad/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/../models/ProductResponse2.dart' as p2;

class AttachmentScreen extends StatefulWidget {
  final OrderResponse? mOrderModel;
  final TargetPlatform? platform;

  const AttachmentScreen({Key? key, this.mOrderModel, this.platform})
      : super(key: key);

  @override
  _AttachmentScreenState createState() => _AttachmentScreenState();
}

class _AttachmentScreenState extends State<AttachmentScreen> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  late bool _loading;
  late bool _permissionReady;
  late String _localPath;
  final ReceivePort _port = ReceivePort();

  String mProfileImage = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  bool isChange = false;
  bool mIsLoggedIn = false;
  bool mIsGuest = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _unbindBackgroundIsolate();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    afterBuildCreated(() {
      init();
    });

    // _bindBackgroundIsolate();

    // FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _loading = true;
    _permissionReady = false;
  }

  List<p2.ProductResponse2> prods = [];

  Future productMetaData() async {
    // appStore.setLoading(true);
    // isLoading= true;
    setState(() {});
    await getProductMetaData(1).then((res) {
      if (!mounted) return;
      // setState(() {
      Iterable mInfo = res;
      var mPlainProducts = mInfo.map((model) {
        return p2.ProductResponse2.fromJson(model);
      }).toList();

      setState(() {
        prods.addAll(mPlainProducts);
      });

      // isLoading= false;
      setState(() {});
      // });
    }).catchError((error) {
      log('error:$error');
      // debugPrint('error:$error');
      //  isLoading= false;
      setState(() {});
      log(error.toString());
    });
  }

  init() async {
    log(widget.mOrderModel!.lineItems!.length.toString());
    mIsLoggedIn = getBoolAsync(IS_LOGGED_IN);
    mIsGuest = getBoolAsync(IS_GUEST_USER);
    userName = mIsLoggedIn
        ? '${getStringAsync(FIRST_NAME) + ' ' + getStringAsync(LAST_NAME)}'
        : '';
    userEmail = mIsLoggedIn ? getStringAsync(USER_EMAIL) : '';
    userPhone = mIsLoggedIn ? getStringAsync(USER_PHONE) : '';
    mProfileImage = getStringAsync(PROFILE_IMAGE);
    productMetaData();
    setState(() {});
  }

/*



  await _checkPermission();
  await _retryRequestPermission();
  await
_requestDownload(TaskInfo(
  name:
  widget.mOrderModel!.orderKey!  , link: getDownloadUrl()
));





*/

  String gettazawadCode({String? woo_vou_code}) {
    return "https://tazawad.com?woo_vou_code=$woo_vou_code";
  }

  String getDownloadUrl(
      {int? downloadfile,
      String? order,
      String? emailOrPhone,
      String? key,
      String? item_id}) {
    log('https://tazawad.com/?download_file=$downloadfile&order=$order&email=$emailOrPhone&key=woo_vou_pdf_1&item_id=$item_id');

    return
//  'https://tazawad.com/?download_file=2808&order=wc_order_hp79UwYP7wuLu&email=info%40tazawad.com&key=woo_vou_pdf_1&item_id=44';
        'https://tazawad.com/?download_file=$downloadfile&order=$order&email=$emailOrPhone&key=woo_vou_pdf_1&item_id=$item_id';

// 'https://tazawad.com/?download_file=$downloadfile&order=$order&email=$emailOrPhone&key=woo_vou_pdf_1&item_id=$item_id';
// 'https://tazawad.com/?download_file=2808&order=$order&email=$emailOrPhone&key=woo_vou_pdf_1&item_id=$item_id';
  }

/*
 void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      log(data.toString());
      final taskId = data[0] as String;
      final status =
      DownloadTaskStatus.fromInt(
         data[1] as int
      )


     ;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
*/
  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: mTop(
            context,
            appLocalization.translate('attachments_txt')

            //  'attachments'

            ,
            showBack: true) as PreferredSizeWidget?,
        body: BodyCornerWidget(
            child: ListView(
          children: widget.mOrderModel!.lineItems!.map((item) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white24,
                  // boxShadow: [

                  //   BoxShadow(
                  //     offset: Offset(28, 28),
                  //     blurRadius: 30 ,
                  //     color: Color(0xFFA7A9AF)
                  //   ) ,

                  //   BoxShadow(
                  //     offset: Offset(-28,-28),
                  //     blurRadius: 30 ,
                  //     color: Colors.white
                  //   )
                  // ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            item.name!,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton.icon(
                            onPressed: () async {
                              for (var item in item.metaData!) {
                                log("METADATA" + item.key.toString());
                              }
                              await _checkPermission();
                              await _retryRequestPermission();
                           /*   await _requestDownload(TaskInfo(
                                  name: item.name,
                                  link: getDownloadUrl(
                                      downloadfile: item.pId,
                                      order: widget.mOrderModel!.orderKey,
                                      emailOrPhone: userEmail,
                                      key: "woo_vou_pdf_1",
                                      item_id: item.productId.toString())));*/
                            },
                            icon: Icon(
                              Icons.download,
                              color: Colors.green,
                            ),
                            label: Text(
                              appLocalization.translate('download_copon')!
                              //  'تحميل الكوبون'

                              ,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    Expanded(
                        child: QrImageView(
                      data: gettazawadCode(woo_vou_code: 'sdf'
                          // prods.where((element) => element.id==item.pId).first
                          // .metaData!.where((element) =>
                          //  element.key=="_woo_vou_codes").first.value
                          //  item.metaData!.where((element) =>
                          //  element.key=="_woo_vou_codes").first.value

                          ),
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                    ).visible(item.metaData!.length > 0))
                  ],
                ),
              ),
            );
          }).toList(),
        )));
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

/*

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      saveInPublicStorage: true,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
    setState(() {});
  }
*/

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    // final deviceInfo = DeviceInfoPlugin();
    /*   final androidInfo = await deviceInfo.androidInfo;
    if (widget.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      */ /* final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }*/ /*
    } else {
      return true;
    }*/
    return false;
  }

/*

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks!.addAll(
      DownloadItems.documents.map(

        (document) => TaskInfo(name: document.name, link: document.url),
      ),
    );








    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _loading = false;
    });
  }
*/

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
/*
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;*/
}
