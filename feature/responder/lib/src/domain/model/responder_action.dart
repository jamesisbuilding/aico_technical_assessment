
enum ResponderAction {
  aOk(label: 'Everything\'s OK'),
  goProperty(label: 'Going to property now'),
  callDr(label: 'Call Doctor'),
  callPlumber(label: 'Call Plumber'),
  callFireServices(label: 'Call Fire Services'),
  noVisit(label: 'I cannot visit');

  const ResponderAction({required this.label});

  final String label;
}
