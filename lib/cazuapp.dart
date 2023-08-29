

  factory AppInstance() {
    return instance;
  }

  Future<void> pingServer() async {
    log('First ping');


    if (!result!.ok()) {
      await instance.auth.nointernet();
      return;
    }

}