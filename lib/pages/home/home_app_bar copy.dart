// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_douban/pages/home/my_home_tab_bar.dart';

// Examples can assume:
// late String _logoAsset;
// double _myToolbarHeight = 250.0;

const double _kLeadingWidth = 0.1; // So the leading button is square.
double kToolbarHeight = 0.1;

// Bottom justify the toolbarHeight child which may overflow the top.
class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout();

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: kToolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, kToolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => false;
}

/// A Material Design app bar.
///
/// An app bar consists of a toolbar and potentially other widgets, such as a
/// [TabBar] and a [FlexibleSpaceBar]. App bars typically expose one or more
/// common [actions] with [IconButton]s which are optionally followed by a
/// [PopupMenuButton] for less common operations (sometimes called the "overflow
/// menu").
///
/// App bars are typically used in the [Scaffold.appBar] property, which places
/// the app bar as a fixed-height widget at the top of the screen. For a scrollable
/// app bar, see [SliverAppBar], which embeds an [AppBar] in a sliver for use in
/// a [CustomScrollView].
///
/// The AppBar displays the toolbar widgets, [leading], [title], and [actions],
/// above the [bottom] (if any). The [bottom] is usually used for a [TabBar]. If
/// a [flexibleSpace] widget is specified then it is stacked behind the toolbar
/// and the bottom widget. The following diagram shows where each of these slots
/// appears in the toolbar when the writing language is left-to-right (e.g.
/// English):
///
/// The [AppBar] insets its content based on the ambient [MediaQuery]'s padding,
/// to avoid system UI intrusions. It's taken care of by [Scaffold] when used in
/// the [Scaffold.appBar] property. When animating an [AppBar], unexpected
/// [MediaQuery] changes (as is common in [Hero] animations) may cause the content
/// to suddenly jump. Wrap the [AppBar] in a [MediaQuery] widget, and adjust its
/// padding such that the animation is smooth.
///
/// ![The leading widget is in the top left, the actions are in the top right,
/// the title is between them. The bottom is, naturally, at the bottom, and the
/// flexibleSpace is behind all of them.](https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.png)
///
/// If the [leading] widget is omitted, but the [AppBar] is in a [Scaffold] with
/// a [Drawer], then a button will be inserted to open the drawer. Otherwise, if
/// the nearest [Navigator] has any previous routes, a [BackButton] is inserted
/// instead. This behavior can be turned off by setting the [automaticallyImplyLeading]
/// to false. In that case a null leading widget will result in the middle/title widget
/// stretching to start.
///
/// {@tool dartpad}
/// This sample shows an [AppBar] with two simple actions. The first action
/// opens a [SnackBar], while the second action navigates to a new page.
///
/// ** See code in examples/api/lib/material/app_bar/app_bar.0.dart **
/// {@end-tool}
///
/// Material Design 3 introduced new types of app bar.
/// {@tool dartpad}
/// This sample shows the creation of an [AppBar] widget with the [shadowColor] and
/// [scrolledUnderElevation] properties set, as described in:
/// https://m3.material.io/components/top-app-bar/overview
///
/// ** See code in examples/api/lib/material/app_bar/app_bar.1.dart **
/// {@end-tool}
///
/// ## Troubleshooting
///
/// ### Why don't my TextButton actions appear?
///
/// If the app bar's [actions] contains [TextButton]s, they will not
/// be visible if their foreground (text) color is the same as the
/// app bar's background color.
///
/// In Material v2 (i.e., when [ThemeData.useMaterial3] is false),
/// the default app bar [backgroundColor] is the overall theme's
/// [ColorScheme.primary] if the overall theme's is
/// [Brightness.light]. Unfortunately this is the same as the default
/// [ButtonStyle.foregroundColor] for [TextButton] for light themes.
/// In this case a preferable text button foreground color is
/// [ColorScheme.onPrimary], a color that contrasts nicely with
/// [ColorScheme.primary]. To remedy the problem, override
/// [TextButton.style]:
///
/// {@tool dartpad}
/// This sample shows an [AppBar] with two action buttons with their primary
/// color set to [ColorScheme.onPrimary].
///
/// ** See code in examples/api/lib/material/app_bar/app_bar.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to listen to a nested Scrollable's scroll notification
/// in a nested scroll view using the [notificationPredicate] property and use it
/// to make [scrolledUnderElevation] take effect.
///
/// ** See code in examples/api/lib/material/app_bar/app_bar.3.dart **
/// {@end-tool}
///
/// See also:
///
///  * [Scaffold], which displays the [AppBar] in its [Scaffold.appBar] slot.
///  * [SliverAppBar], which uses [AppBar] to provide a flexible app bar that
///    can be used in a [CustomScrollView].
///  * [TabBar], which is typically placed in the [bottom] slot of the [AppBar]
///    if the screen has multiple pages arranged in tabs.
///  * [IconButton], which is used with [actions] to show buttons on the app bar.
///  * [PopupMenuButton], to show a popup menu on the app bar, via [actions].
///  * [FlexibleSpaceBar], which is used with [flexibleSpace] when the app bar
///    can expand and collapse.
///  * <https://material.io/design/components/app-bars-top.html>
///  * <https://m3.material.io/components/top-app-bar>
///  * Cookbook: [Place a floating app bar above a list](https://docs.flutter.dev/cookbook/lists/floating-app-bar)
class AppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a Material Design app bar.
  ///
  /// If [elevation] is specified, it must be non-negative.
  ///
  /// Typically used in the [Scaffold.appBar] property.
  AppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.backgroundColor,
    this.iconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.foregroundColor,
    this.actionsIconTheme,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.clipBehavior,
  })  : assert(elevation == null || elevation >= 0.0),
        assert(automaticallyImplyLeading != null),
        assert(elevation == null || elevation >= 0.0),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(toolbarOpacity != null),
        preferredSize =
            Size.fromHeight(1.0 + (bottom?.preferredSize?.height ?? 0.0));

  /// Used by [Scaffold] to compute its [AppBar]'s overall height. The returned value is
  /// the same `preferredSize.height` unless [AppBar.toolbarHeight] was null and
  /// `AppBarTheme.of(context).toolbarHeight` is non-null. In that case the
  /// return value is the sum of the theme's toolbar height and the height of
  /// the app bar's [AppBar.bottom] widget.

  /// {@template flutter.material.appbar.leading}
  /// A widget to display before the toolbar's [title].
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  ///
  /// Becomes the leading component of the [NavigationToolbar] built
  /// by this widget. The [leading] widget's width and height are constrained to
  /// be no bigger than [leadingWidth] and [toolbarHeight] respectively.
  ///
  /// If this is null and [automaticallyImplyLeading] is set to true, the
  /// [AppBar] will imply an appropriate widget. For example, if the [AppBar] is
  /// in a [Scaffold] that also has a [Drawer], the [Scaffold] will fill this
  /// widget with an [IconButton] that opens the drawer (using [Icons.menu]). If
  /// there's no [Drawer] and the parent [Navigator] can go back, the [AppBar]
  /// will use a [BackButton] that calls [Navigator.maybePop].
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// The following code shows how the drawer button could be manually specified
  /// instead of relying on [automaticallyImplyLeading]:
  ///
  /// ```dart
  /// AppBar(
  ///   leading: Builder(
  ///     builder: (BuildContext context) {
  ///       return IconButton(
  ///         icon: const Icon(Icons.menu),
  ///         onPressed: () { Scaffold.of(context).openDrawer(); },
  ///         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  ///       );
  ///     },
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// The [Builder] is used in this example to ensure that the `context` refers
  /// to that part of the subtree. That way this code snippet can be used even
  /// inside the very code that is creating the [Scaffold] (in which case,
  /// without the [Builder], the `context` wouldn't be able to see the
  /// [Scaffold], since it would refer to an ancestor of that widget).
  ///
  /// See also:
  ///
  ///  * [Scaffold.appBar], in which an [AppBar] is usually placed.
  ///  * [Scaffold.drawer], in which the [Drawer] is usually placed.
  final Widget? leading;

  /// {@template flutter.material.appbar.automaticallyImplyLeading}
  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [AppBar.leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [AppBar.leading] is null, leading space is given to [AppBar.title].
  /// If leading widget is not null, this parameter has no effect.
  /// {@endtemplate}
  final bool automaticallyImplyLeading;

  /// {@template flutter.material.appbar.title}
  /// The primary widget displayed in the app bar.
  ///
  /// Becomes the middle component of the [NavigationToolbar] built by this widget.
  ///
  /// Typically a [Text] widget that contains a description of the current
  /// contents of the app.
  /// {@endtemplate}
  ///
  /// The [title]'s width is constrained to fit within the remaining space
  /// between the toolbar's [leading] and [actions] widgets. Its height is
  /// _not_ constrained. The [title] is vertically centered and clipped to fit
  /// within the toolbar, whose height is [toolbarHeight]. Typically this
  /// isn't noticeable because a simple [Text] [title] will fit within the
  /// toolbar by default. On the other hand, it is noticeable when a
  /// widget with an intrinsic height that is greater than [toolbarHeight]
  /// is used as the [title]. For example, when the height of an Image used
  /// as the [title] exceeds [toolbarHeight], it will be centered and
  /// clipped (top and bottom), which may be undesirable. In cases like this
  /// the height of the [title] widget can be constrained. For example:
  ///
  /// ```dart
  /// MaterialApp(
  ///   home: Scaffold(
  ///     appBar: AppBar(
  ///       title: SizedBox(
  ///         height: _myToolbarHeight,
  ///         child: Image.asset(_logoAsset),
  ///       ),
  ///       toolbarHeight: _myToolbarHeight,
  ///     ),
  ///   ),
  /// )
  /// ```
  final Widget? title;

  /// {@template flutter.material.appbar.actions}
  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built
  /// by this widget. The height of each action is constrained to be no bigger
  /// than the [toolbarHeight].
  ///
  /// To avoid having the last action covered by the debug banner, you may want
  /// to set the [MaterialApp.debugShowCheckedModeBanner] to false.
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// Scaffold(
  ///   body: CustomScrollView(
  ///     primary: true,
  ///     slivers: <Widget>[
  ///       SliverAppBar(
  ///         title: const Text('Hello World'),
  ///         actions: <Widget>[
  ///           IconButton(
  ///             icon: const Icon(Icons.shopping_cart),
  ///             tooltip: 'Open shopping cart',
  ///             onPressed: () {
  ///               // handle the press
  ///             },
  ///           ),
  ///         ],
  ///       ),
  ///       // ...rest of body...
  ///     ],
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  final List<Widget>? actions;

  /// {@template flutter.material.appbar.flexibleSpace}
  /// This widget is stacked behind the toolbar and the tab bar. Its height will
  /// be the same as the app bar's overall height.
  ///
  /// A flexible space isn't actually flexible unless the [AppBar]'s container
  /// changes the [AppBar]'s size. A [SliverAppBar] in a [CustomScrollView]
  /// changes the [AppBar]'s height when scrolled.
  ///
  /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
  /// {@endtemplate}
  final Widget? flexibleSpace;

  /// {@template flutter.material.appbar.bottom}
  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  /// {@template flutter.material.appbar.elevation}
  /// The z-coordinate at which to place this app bar relative to its parent.
  ///
  /// This property controls the size of the shadow below the app bar if
  /// [shadowColor] is not null.
  ///
  /// If [surfaceTintColor] is not null then it will apply a surface tint overlay
  /// to the background color (see [Material.surfaceTintColor] for more
  /// detail).
  ///
  /// The value must be non-negative.
  ///
  /// If this property is null, then [AppBarTheme.elevation] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the
  /// default value is 4.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [scrolledUnderElevation], which will be used when the app bar has
  ///    something scrolled underneath it.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  ///  * [surfaceTintColor], which determines the elevation overlay that will
  ///    be applied to the background of the app bar.
  ///  * [shape], which defines the shape of the app bar's [Material] and its
  ///    shadow.
  final double? elevation;

  /// {@template flutter.material.appbar.scrolledUnderElevation}
  /// The elevation that will be used if this app bar has something
  /// scrolled underneath it.
  ///
  /// If non-null then it [AppBarTheme.scrolledUnderElevation] of
  /// [ThemeData.appBarTheme] will be used. If that is also null then [elevation]
  /// will be used.
  ///
  /// The value must be non-negative.
  ///
  /// {@endtemplate}
  ///
  /// See also:
  ///  * [elevation], which will be used if there is no content scrolled under
  ///    the app bar.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  ///  * [surfaceTintColor], which determines the elevation overlay that will
  ///    be applied to the background of the app bar.
  ///  * [shape], which defines the shape of the app bar's [Material] and its
  ///    shadow.
  final double? scrolledUnderElevation;

  /// A check that specifies which child's [ScrollNotification]s should be
  /// listened to.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.

  /// {@template flutter.material.appbar.shadowColor}
  /// The color of the shadow below the app bar.
  ///
  /// If this property is null, then [AppBarTheme.shadowColor] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is fully opaque black.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [elevation], which defines the size of the shadow below the app bar.
  ///  * [shape], which defines the shape of the app bar and its shadow.
  final Color? shadowColor;

  /// {@template flutter.material.appbar.surfaceTintColor}
  /// The color of the surface tint overlay applied to the app bar's
  /// background color to indicate elevation.
  ///
  /// If null no overlay will be applied.
  /// {@endtemplate}
  ///
  /// See also:
  ///   * [Material.surfaceTintColor], which described this feature in more detail.
  final Color? surfaceTintColor;

  /// {@template flutter.material.appbar.shape}
  /// The shape of the app bar's [Material] as well as its shadow.
  ///
  /// If this property is null, then [AppBarTheme.shape] of
  /// [ThemeData.appBarTheme] is used. Both properties default to null.
  /// If both properties are null then the shape of the app bar's [Material]
  /// is just a simple rectangle.
  ///
  /// A shadow is only displayed if the [elevation] is greater than
  /// zero.
  /// {@endtemplate}
  ///
  /// {@tool dartpad}
  /// This sample demonstrates how to implement a custom app bar shape for the
  /// [shape] property.
  ///
  /// ** See code in examples/api/lib/material/app_bar/app_bar.4.dart **
  /// {@end-tool}
  /// See also:
  ///
  ///  * [elevation], which defines the size of the shadow below the app bar.
  ///  * [shadowColor], which is the color of the shadow below the app bar.
  final ShapeBorder? shape;

  /// {@template flutter.material.appbar.backgroundColor}
  /// The fill color to use for an app bar's [Material].
  ///
  /// If null, then the [AppBarTheme.backgroundColor] is used. If that value is also
  /// null:
  /// In Material v2 (i.e., when [ThemeData.useMaterial3] is false),
  /// then [AppBar] uses the overall theme's [ColorScheme.primary] if the
  /// In Material v3 (i.e., when [ThemeData.useMaterial3] is true),
  /// then [AppBar] uses the overall theme's [ColorScheme.surface]
  ///
  /// If this color is a [MaterialStateColor] it will be resolved against
  /// [MaterialState.scrolledUnder] when the content of the app's
  /// primary scrollable overlaps the app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [foregroundColor], which specifies the color for icons and text within
  ///    the app bar.
  ///  * [Theme.of], which returns the current overall Material theme as
  ///    a [ThemeData].
  ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
  ///    default colors are based on.
  ///  * , which indicates if the overall [Theme]
  ///    is light or dark.
  final Color? backgroundColor;


  /// {@template flutter.material.appbar.foregroundColor}
  /// The default color for [Text] and [Icon]s within the app bar.
  ///
  /// If null, then [AppBarTheme.foregroundColor] is used. If that
  /// value is also null:
  /// In Material v2 (i.e., when [ThemeData.useMaterial3] is false),
  /// then [AppBar] uses the overall theme's [ColorScheme.onPrimary] if the
  /// overall theme's is [Brightness.light], and [ColorScheme.onSurface]
  /// if the overall theme's is [Brightness.dark].
  /// In Material v3 (i.e., when [ThemeData.useMaterial3] is true),
  /// then [AppBar] uses the overall theme's [ColorScheme.onSurface].
  ///
  /// This color is used to configure [DefaultTextStyle] that contains
  /// the toolbar's children, and the default [IconTheme] widgets that
  /// are created if [iconTheme] and [actionsIconTheme] are null.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [backgroundColor], which specifies the app bar's background color.
  ///  * [Theme.of], which returns the current overall Material theme as
  ///    a [ThemeData].
  ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
  ///    default colors are based on.
  ///  * which indicates if the overall [Theme]
  ///    is light or dark.
  final Color? foregroundColor;

  /// {@template flutter.material.appbar.iconTheme}
  /// The color, opacity, and size to use for toolbar icons.
  ///
  /// If this property is null, then a copy of [ThemeData.iconTheme]
  /// is used, with the [IconThemeData.color] set to the
  /// app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [actionsIconTheme], which defines the appearance of icons in
  ///    the [actions] list.
  final IconThemeData? iconTheme;

  final TextTheme? textTheme;

  /// {@template flutter.material.appbar.actionsIconTheme}
  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's [actions].
  ///
  /// This property should only be used when the [actions] should be
  /// themed differently than the icon that appears in the app bar's [leading]
  /// widget.
  ///
  /// If this property is null, then [AppBarTheme.actionsIconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then the value of
  /// [iconTheme] is used.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [iconTheme], which defines the appearance of all of the toolbar icons.
  final IconThemeData? actionsIconTheme;

  /// {@template flutter.material.appbar.primary}
  /// Whether this app bar is being displayed at the top of the screen.
  ///
  /// If true, the app bar's toolbar elements and [bottom] widget will be
  /// padded on top by the height of the system status bar. The layout
  /// of the [flexibleSpace] is not affected by the [primary] property.
  /// {@endtemplate}
  final bool primary;

  /// {@template flutter.material.appbar.centerTitle}
  /// Whether the title should be centered.
  ///
  /// If this property is null, then [AppBarTheme.centerTitle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then value is
  /// adapted to the current [TargetPlatform].
  /// {@endtemplate}
  final bool? centerTitle;

  /// {@template flutter.material.appbar.excludeHeaderSemantics}
  /// Whether the title should be wrapped with header [Semantics].
  ///
  /// Defaults to false.
  /// {@endtemplate}

  /// {@template flutter.material.appbar.titleSpacing}
  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// If this property is null, then [AppBarTheme.titleSpacing] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then the
  /// default value is [NavigationToolbar.kMiddleSpacing].
  /// {@endtemplate}
  final double? titleSpacing;

  /// {@template flutter.material.appbar.toolbarOpacity}
  /// How opaque the toolbar part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  /// {@endtemplate}
  final double toolbarOpacity;

  /// {@template flutter.material.appbar.bottomOpacity}
  /// How opaque the bottom part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  /// {@endtemplate}
  final double bottomOpacity;

  /// {@template flutter.material.appbar.preferredSize}
  /// A size whose height is the sum of [toolbarHeight] and the [bottom] widget's
  /// preferred height.
  ///
  /// [Scaffold] uses this size to set its app bar's height.
  /// {@endtemplate}
  @override
  final Size preferredSize;

  /// {@template flutter.material.appbar.toolbarHeight}
  /// Defines the height of the toolbar component of an [AppBar].
  ///
  /// By default, the value of [toolbarHeight] is [kToolbarHeight].
  /// {@endtemplate}
  final double? toolbarHeight;

  /// {@template flutter.material.appbar.leadingWidth}
  /// Defines the width of [AppBar.leading] widget.
  ///
  /// By default, the value of [AppBar.leadingWidth] is 56.0.
  /// {@endtemplate}
  final double? leadingWidth;

  /// {@template flutter.material.appbar.toolbarTextStyle}
  /// The default text style for the AppBar's [leading], and
  /// [actions] widgets, but not its [title].
  ///
  /// If this property is null, then [AppBarTheme.toolbarTextStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default
  /// value is a copy of the overall theme's [TextTheme.bodyMedium]
  /// [TextStyle], with color set to the app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [titleTextStyle], which overrides the default text style for the [title].
  ///  * [DefaultTextStyle], which overrides the default text style for all of the
  ///    widgets in a subtree.
  final TextStyle? toolbarTextStyle;

  /// {@template flutter.material.appbar.titleTextStyle}
  /// The default text style for the AppBar's [title] widget.
  ///
  /// If this property is null, then [AppBarTheme.titleTextStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default
  /// value is a copy of the overall theme's [TextTheme.titleLarge]
  /// [TextStyle], with color set to the app bar's [foregroundColor].
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [toolbarTextStyle], which is the default text style for the AppBar's
  ///    [title], [leading], and [actions] widgets, also known as the
  ///    AppBar's "toolbar".
  ///  * [DefaultTextStyle], which overrides the default text style for all of the
  ///    widgets in a subtree.
  final TextStyle? titleTextStyle;

  /// {@template flutter.material.appbar.systemOverlayStyle}
  /// Specifies the style to use for the system overlays (e.g. the status bar on
  /// Android or iOS, the system navigation bar on Android).
  ///
  /// If this property is null, then [AppBarTheme.systemOverlayStyle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, an appropriate
  /// [SystemUiOverlayStyle] is calculated based on the [backgroundColor].
  ///
  /// The AppBar's descendants are built within a
  /// `AnnotatedRegion<SystemUiOverlayStyle>` widget, which causes
  /// [SystemChrome.setSystemUIOverlayStyle] to be called
  /// automatically. Apps should not enclose an AppBar with their
  /// own [AnnotatedRegion].
  /// {@endtemplate}
  //
  /// See also:
  ///
  ///  * [AnnotatedRegion], for placing [SystemUiOverlayStyle] in the layer tree.
  ///  * [SystemChrome.setSystemUIOverlayStyle], the imperative API for setting
  ///    system overlays style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// {@macro flutter.material.Material.clipBehavior}
  final Clip? clipBehavior;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  static const double _defaultElevation = 4.0;

  void _handleDrawerButton() {
    Scaffold.of(context).openDrawer();
  }

  void _handleDrawerButtonEnd() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final ThemeData themeData = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ScaffoldState scaffold = Scaffold.of(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    IconThemeData appBarIconTheme =
        widget.iconTheme ?? appBarTheme.iconTheme ?? themeData.primaryIconTheme;
    TextStyle? centerStyle =
        widget.textTheme?.bodyMedium ?? themeData.primaryTextTheme.bodyMedium;
    TextStyle? sideStyle =
        widget.textTheme?.bodyMedium ?? themeData.primaryTextTheme.bodyMedium;

    if (widget.toolbarOpacity != 1.0) {
      final double opacity =
          const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn)
              .transform(widget.toolbarOpacity);
      if (centerStyle?.color != null)
        centerStyle = centerStyle?.copyWith(
            color: centerStyle?.color?.withOpacity(opacity));
      if (sideStyle?.color != null)
        sideStyle =
            sideStyle?.copyWith(color: sideStyle?.color?.withOpacity(opacity));
      appBarIconTheme = appBarIconTheme.copyWith(
          opacity: opacity * (appBarIconTheme.opacity ?? 1.0));
    }

    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _handleDrawerButton,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (canPop)
          leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: _kLeadingWidth),
        child: leading,
      );
    }

    Widget? title = widget.title;
    if (title != null) {
      title = DefaultTextStyle(
        style: centerStyle!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Semantics(
          namesRoute: switch (theme.platform) {
            TargetPlatform.android ||
            TargetPlatform.fuchsia ||
            TargetPlatform.linux ||
            TargetPlatform.windows =>
              true,
            TargetPlatform.iOS || TargetPlatform.macOS => null,
          },
          header: true,
          child: title,
        ),
      );
    }

    Widget appBar = Container();
    appBar = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 0.0),
            child: appBar,
          ),
        ),
        // widget.bottomOpacity == 1.0 ? Container(height: 46.0) : Container(height: 46.0)
        widget.bottomOpacity == 1.0
            ? Container(height: 46.0)
            : Opacity(
                opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn)
                    .transform(widget.bottomOpacity),
                child: Container(
                  height: 46.0,
                ),
              ),
      ],
    );

    if (widget.primary) {
      appBar = SafeArea(
        top: true,
        child: appBar,
      );
    }

    if (widget.flexibleSpace != null) {
      var widgets = [];
      widgets.add(widget.flexibleSpace);
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ...widgets,
          appBar,
        ],
      );
    }
    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.light ?? SystemUiOverlayStyle.dark;

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: Material(
            color: widget.backgroundColor ??
                appBarTheme.backgroundColor ??
                themeData.primaryColor,
            elevation:
                widget.elevation ?? appBarTheme.elevation ?? _defaultElevation,
            child: Semantics(
              explicitChildNodes: true,
              child: appBar,
            ),
          )),
    );
  }
}

extension on ThemeData {
  get primaryColorBrightness => null;
}

class _FloatingAppBar extends StatefulWidget {
  final Widget child;
  const _FloatingAppBar({super.key, required this.child});

  @override
  State<_FloatingAppBar> createState() => __FloatingAppBarState();
}

class __FloatingAppBarState extends State<_FloatingAppBar> {
  late ScrollPosition _position;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    _position = Scrollable.of(context).position;
    if (_position != null) {
      _position.isScrollingNotifier.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  RenderSliverFloatingPersistentHeader? _headerRenderer() {
    return context
        .findAncestorRenderObjectOfType<RenderSliverFloatingPersistentHeader>();
  }

  void _isScrollingListener() {
    // ignore: unnecessary_null_comparison
    if (_position == null) return;

    // When a scroll stops, then maybe snap the appbar into view.
    // Similarly, when a scroll starts, then maybe stop the snap animation.
    final RenderSliverFloatingPersistentHeader? header = _headerRenderer();
    if (_position.isScrollingNotifier.value) {
      header?.maybeStopSnapAnimation(_position.userScrollDirection);
    } else {
      header?.maybeStartSnapAnimation(_position.userScrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    this.leading,
    required this.automaticallyImplyLeading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.forceElevated,
    this.backgroundColor,
    this.iconTheme,
    this.textTheme,
    this.primary,
    this.centerTitle,
    this.titleSpacing,
    this.expandedHeight,
    this.collapsedHeight,
    this.topPadding,
    this.floating,
    this.pinned,
    this.snapConfiguration,
    this.bottomList,
  })  : assert(primary! || topPadding == 0.0),
        _bottomHeight = bottom?.preferredSize.height ?? 0.0;

  final List<String>? bottomList;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  PreferredSizeWidget? bottom;
  final double? elevation;
  final bool? forceElevated;
  final Color? backgroundColor;
  final IconThemeData? iconTheme;
  final TextTheme? textTheme;
  final bool? primary;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? expandedHeight;
  final double? collapsedHeight;
  final double? topPadding;
  final bool? floating;
  final bool? pinned;

  final double? _bottomHeight;

  @override
  double get minExtent =>
      collapsedHeight ?? (topPadding! + kToolbarHeight + _bottomHeight!);

  @override
  double get maxExtent => math.max(
      topPadding! + (expandedHeight ?? kToolbarHeight + _bottomHeight!),
      minExtent);

  @override
  final FloatingHeaderSnapConfiguration? snapConfiguration;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double visibleMainHeight = maxExtent - shrinkOffset - topPadding!;
    // Truth table for `toolbarOpacity`:
    // pinned | floating | bottom != null || opacity
    // ----------------------------------------------
    //    0   |    0     |        0       ||  fade
    //    0   |    0     |        1       ||  fade
    //    0   |    1     |        0       ||  fade
    //    0   |    1     |        1       ||  fade
    //    1   |    0     |        0       ||  1.0
    //    1   |    0     |        1       ||  1.0
    //    1   |    1     |        0       ||  1.0
    //    1   |    1     |        1       ||  fade
    final double toolbarOpacity = !pinned! || (floating! && bottom != null)
        ? ((visibleMainHeight - _bottomHeight!) / kToolbarHeight).clamp(0.0, 1.0)
        : 1.0;

    final double deltaExtent = maxExtent - minExtent;

    final double t = (1.0 -
            (math.max(minExtent, maxExtent - shrinkOffset) - minExtent) /
                deltaExtent)
        .clamp(0.0, 1.0);

    Color? color = Color.lerp(Colors.white, Colors.green, t);
    bottom = HomeTabBar(
      translate: t,
      tabBar: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.0,
        indicatorColor: color,
        tabs: bottomList
            !.map((String name) => Container(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                  child: Text(
                    name,
                    style: TextStyle(color: color, fontSize: 17.0),
                  ),
                ))
            .toList(),
      ),
    );
    print(bottom);
    print(bottomList);

    final Widget settings = FlexibleSpaceBar.createSettings(
        minExtent: minExtent,
        maxExtent: maxExtent,
        toolbarOpacity: toolbarOpacity,
        currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
        child: AppBar(
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          actions: actions,
          flexibleSpace: (title == null && flexibleSpace != null)
              ? Semantics(child: flexibleSpace, header: true)
              : flexibleSpace,
          bottom: bottom,
          elevation: forceElevated! ||
                  overlapsContent ||
                  (pinned! && shrinkOffset > maxExtent - minExtent)
              ? elevation ?? 4.0
              : 0.0,
          backgroundColor: backgroundColor,
          iconTheme: iconTheme,
          textTheme: textTheme,
          primary: primary!,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: pinned!
              ? 1.0
              : (visibleMainHeight / _bottomHeight!).clamp(0.0, 1.0),
        ));

    return floating! ? _FloatingAppBar(child: settings) : settings;
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return leading != oldDelegate.leading ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        title != oldDelegate.title ||
        actions != oldDelegate.actions ||
        flexibleSpace != oldDelegate.flexibleSpace ||
        bottom != oldDelegate.bottom ||
        _bottomHeight != oldDelegate._bottomHeight ||
        elevation != oldDelegate.elevation ||
        backgroundColor != oldDelegate.backgroundColor ||
        iconTheme != oldDelegate.iconTheme ||
        textTheme != oldDelegate.textTheme ||
        primary != oldDelegate.primary ||
        centerTitle != oldDelegate.centerTitle ||
        titleSpacing != oldDelegate.titleSpacing ||
        expandedHeight != oldDelegate.expandedHeight ||
        topPadding != oldDelegate.topPadding ||
        pinned != oldDelegate.pinned ||
        floating != oldDelegate.floating ||
        snapConfiguration != oldDelegate.snapConfiguration;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}(topPadding: ${topPadding?.toStringAsFixed(1)}, bottomHeight: ${_bottomHeight?.toStringAsFixed(1)}, ...)';
  }
}

class SliverAppBar extends StatefulWidget {
  const SliverAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.bottomTextString,
    this.elevation,
    this.forceElevated = false,
    this.backgroundColor,
    this.iconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
  })  : assert(automaticallyImplyLeading != null),
        assert(forceElevated != null),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(floating != null),
        assert(pinned != null),
        assert(snap != null),
        assert(
          floating || !snap,
        );

  final Widget? leading;
  final List<String>? bottomTextString;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the appbar.
  ///
  /// Typically a [Text] widget containing a description of the current contents
  /// of the app.
  final Widget? title;

  /// Widgets to display after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// {@tool sample}
  ///
  /// ```dart
  /// Scaffold(
  ///   body: CustomScrollView(
  ///     primary: true,
  ///     slivers: <Widget>[
  ///       SliverAppBar(
  ///         title: Text('Hello World'),
  ///         actions: <Widget>[
  ///           IconButton(
  ///             icon: Icon(Icons.shopping_cart),
  ///             tooltip: 'Open shopping cart',
  ///             onPressed: () {
  ///               // handle the press
  ///             },
  ///           ),
  ///         ],
  ///       ),
  ///       // ...rest of body...
  ///     ],
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  final List<Widget>? actions;

  /// This widget is stacked behind the toolbar and the tabbar. It's height will
  /// be the same as the app bar's overall height.
  ///
  /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
  final Widget? flexibleSpace;

  /// This widget appears across the bottom of the appbar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  /// The z-coordinate at which to place this app bar when it is above other
  /// content. This controls the size of the shadow below the app bar.
  ///
  /// Defaults to 4, the appropriate elevation for app bars.
  ///
  /// If [forceElevated] is false, the elevation is ignored when the app bar has
  /// no content underneath it. For example, if the app bar is [pinned] but no
  /// content is scrolled under it, or if it scrolls with the content, then no
  /// shadow is drawn, regardless of the value of [elevation].
  final double? elevation;

  /// Whether to show the shadow appropriate for the [elevation] even if the
  /// content is not scrolled under the [AppBar].
  ///
  /// Defaults to false, meaning that the [elevation] is only applied when the
  /// [AppBar] is being displayed over content that is scrolled under it.
  ///
  /// When set to true, the [elevation] is applied regardless.
  ///
  /// Ignored when [elevation] is zero.
  final bool forceElevated;

  /// The color to use for the app bar's material. Typically this should be set
  /// along with, [iconTheme], [textTheme].
  ///
  /// Defaults to [ThemeData.primaryColor].
  final Color? backgroundColor;

  /// The color, opacity, and size to use for app bar icons. Typically this
  /// is set along with [backgroundColor], [textTheme].
  ///
  /// Defaults to [ThemeData.primaryIconTheme].
  final IconThemeData? iconTheme;

  /// The typographic styles to use for text in the app bar. Typically this is
  /// set along with [backgroundColor], [iconTheme].
  ///
  /// Defaults to [ThemeData.primaryTextTheme].
  final TextTheme? textTheme;

  /// Whether this app bar is being displayed at the top of the screen.
  ///
  /// If this is true, the top padding specified by the [MediaQuery] will be
  /// added to the top of the toolbar.
  final bool primary;

  /// Whether the title should be centered.
  ///
  /// Defaults to being adapted to the current [TargetPlatform].
  final bool? centerTitle;

  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// Defaults to [NavigationToolbar.kMiddleSpacing].
  final double? titleSpacing;

  /// The size of the app bar when it is fully expanded.
  ///
  /// By default, the total height of the toolbar and the bottom widget (if
  /// any). If a [flexibleSpace] widget is specified this height should be big
  /// enough to accommodate whatever that widget contains.
  ///
  /// This does not include the status bar height (which will be automatically
  /// included if [primary] is true).
  final double? expandedHeight;

  final bool floating;

  /// Whether the app bar should remain visible at the start of the scroll view.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// remain visible rather than being scrolled out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [pinned] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [pinned] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_pinned.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [floating].
  final bool pinned;

  /// If [snap] and [floating] are true then the floating app bar will "snap"
  /// into view.
  ///
  /// If [snap] is true then a scroll that exposes the floating app bar will
  /// trigger an animation that slides the entire app bar into view. Similarly if
  /// a scroll dismisses the app bar, the animation will slide the app bar
  /// completely out of view.
  ///
  /// Snapping only applies when the app bar is floating, not when the appbar
  /// appears at the top of its scroll view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [snap] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  /// * App bar with [snap] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating_snap.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [floating].
  final bool snap;

  @override
  State<SliverAppBar> createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<SliverAppBar> with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration? _snapConfiguration;


  void _updateSnapConfiguration() {
    if (widget.snap && widget.floating) {
      _snapConfiguration = FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _snapConfiguration = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSnapConfiguration();
  }

  @override
  void didUpdateWidget(SliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating)
      _updateSnapConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    final double topPadding = 0.0;
    final double collapsedHeight = widget.bottom!.preferredSize.height + 26.0;
    return MediaQuery.removePadding(
      context: context, 
      removeBottom: true,
      removeTop: true,
      child: SliverPersistentHeader(
        floating: widget.floating,
        pinned: widget.pinned,
        delegate: _SliverAppBarDelegate(
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: widget.actions,
          flexibleSpace: widget.flexibleSpace,
          bottom: widget.bottom,
          bottomList: widget.bottomTextString,
          elevation: widget.elevation,
          forceElevated: widget.forceElevated,
          backgroundColor: widget.backgroundColor,
          iconTheme: widget.iconTheme,
          textTheme: widget.textTheme,
          primary: widget.primary,
          centerTitle: widget.centerTitle,
          titleSpacing: widget.titleSpacing,
          expandedHeight: widget.expandedHeight,
          collapsedHeight: collapsedHeight,
          topPadding: topPadding,
          floating: widget.floating,
          pinned: widget.pinned,
          snapConfiguration: _snapConfiguration,
        ),
      ),
    );
  }
}
