/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

/* Contains routes to your endpoint API */

class AppRoutes {
  static const String takeOrder = "app/driver/take";
  static const String untakeOrder = "app/driver/untake";
  static const String setStatus = "app/driver/setstatus";
  static const String driverStats = "app/driver/orders/stats";
  static const String deliverOK = "app/driver/deliverok";
  static const String paymentFailed = "app/driver/paymentfailed";
  static const String deliverpending = "app/driver/deliverpending";

  /* Address */

  static const String addressAdd = "app/address/add";
  static const String addressUpdate = "app/address/update";
  static const String addressGet = "app/address/get";
  static const String addressInfo = "app/address/info";
  static const String addressgetDefault = "app/address/getdefault";

  /* Preferences */

  static const String preferencesSet = "app/preferences/set";
  static const String preferencesGetAll = "app/preferences/getall";

  /* User */

  static const String whoami = "app/user/whoami";
  static const String holdsGet = "app/user/holds/get";
  static const String userLogout = "app/user/logout";
  static const String userClose = "app/user/close";
  static const String userLast = "app/user/last";

  /* Session */

  static const String login = "app/noauth/driver_login";
  static const String forgot = "app/noauth/forgot";
  static const String forgotAhead = "app/noauth/forgot_ahead";
  static const String tokenLogin = "app/noauth/token_login";

  /* Settings */

  static const String settingsGetAll = "app/unmanaged/settings/getall";

  /* Initial */

  static const String initPing = "app/startup/ping";

  /* Favorites */

  static const String favoritesGetJoin = "app/favorites/getjoin";
  static const String favoritesSmart = "app/favorites/smart";

  static const String appDelete = "app/address/delete";
  static const String variantsGet = "app/variants/get";
  static const String searchQuery = "app/search/query";
  static const String collectionsGet = "app/collections/get";
  static const String homeGet = "app/home/get";
  static const String productsInfo = "app/products/info";
  static const String variantImages = "app/variants/images";

  static const String passwd = "app/noauth/passwd";
  static const String extend = "app/noauth/token_login";
  static const String signup = "app/noauth/signup";

  /* Orders */

  static const String orderGet = "app/orders/get";
  static const String orderGetBy = "app/orders/getby";
  static const String preOrder = "app/orders/preorder";
  static const String addOrder = "app/orders/add";
  static const String orderInfo = "app/orders/info";
  static const String historicInfo = "app/orders/historic/info";
  static const String orderCancel = "app/orders/cancel";
  static const String getItems = "app/orders/items";

  /* Orders */

  static const String orderGetAllMine = "app/driver/orders/getmine";

  static const String orderGetAllBy = "app/driver/orders/get";
  static const String orderSearchAllBy = "app/driver/orders/search";

  /* Products */

  static const String collectionsProducts = "app/collections/products";
}
