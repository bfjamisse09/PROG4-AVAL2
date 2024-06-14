enum AppRoute {
  home('/'),
  newItem('/item/new'),
  editItem('/item/edit');

  const AppRoute(this.route);

  final String route;
}