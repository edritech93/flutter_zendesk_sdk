class ZendeskMessagingObserver {
  ZendeskMessagingObserver(this.removeOnCall, this.func);

  final bool removeOnCall;
  final Function(Map? args) func;
}
