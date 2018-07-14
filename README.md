# UIKit Notes

Apple's UIKit documentation should be referenced whenever something's not clear, since it's the most up to date source of truth regarding UIKit. Google is your friend only if Apple's doc doesn't help. On a side note, if one or both of your parents have higher education degree, you should admire them for the fact that they finished (ie. survived) university without Google.

What is this document then? It's merely my notes taken when I was reading Apple's doc (along with some other online material), and it's not a detailed summary of UIKit, but only the things that I think are important to note.  

## App Launches

> In C, the "main" function is treated the same as every function, it has a return type (and in some cases accepts inputs via parameters). The only difference is that the main function is "called" by the operating system when the user runs the program. Thus the main function is always the first code executed when a program starts.

reference: <https://www.cs.utah.edu/~germain/PPS/Topics/C_Language/c_functions.html>

Some evidence of C could be found in iOS project template using Objective-C:

```
// iOS project in Objective-C

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```

An entry point is needed for many procedural-oriented languages in order to execute the program, having a connection with Objective C (and ultimately, C), an iOS app in Swift also has this characteristic, the entry point is `UIApplicationMain`, which:

1. instantiates `UIApplication`, the instance is referred to as `UIApplicaiton.shared`
2. instantiates app delegate, which is the classed marked `@UIApplicationMain`, saves it as application instance's `delegate`
3. if app delegate's `window` is `nil`, instantiates `UIWindow` and assign it to app delegate's `window` property, the window's frame is set to the screen's bounds in order to fill the device's screen 
4. looks at the value of field named `UIMainStoryboardFile` in Info.plist (note: the file may not have the same name, depending on the value of "Info.plist File" in Build Settings), by default the storyboard is "Main.storyboard"
5. instantiates the storyboard's initial view controller, assigns it to `window`'s `rootViewController`
6. as a result, the `view` of `rootViewController` becomes subview of the (main) window 
7. notifies app delegate that the app has been launched via `application(_:didFinishLaunchingWithOptions:)`
8. calls window's instance method `makeKeyAndVisible` to make the window visible

TODO: diagram needed here
TODO: launching an app without storyboard

- sometimes it can be useful to give window a `backgroundColor` just in case user could see it
- earlier version of new project templates in Objective-C has `makeKeyAndVisible` inside `applicationDidFinishLaunching` so I assume the order of steps 7 and 8 are correct
- there's an article describing app launching sequence with a diagram, the article is quite dated from 2012, even before the end of the world, thus the diagram might be outdated but it's nevertheless good to see what it was back then, [here's the article](https://oleb.net/blog/2012/02/app-launch-sequence-ios-revisited/) 

## UIWindow

> computer is like air conditioner, they both stop working when you open Windows.

- view (ie. `UIView`) of window's `rootViewController` is the super view of other views in the app, thus,
- any view added to a window has a reference to the window, ie. `view.window`: "This property is nil if the view has not yet been added to a window." (Apple Doc)
- this might be a good way to test whether a view has been added to window (ie. visible), rather than checking whether the view has a superview (ie. `view.superview != nil`)
- `UIWindow` has some responsibilities like hit-testing (ie. user touching screen), so it might be useful to use subclass of `UIWindow` instead of vanilla `UIWindow`
- a use case of subclassing `UIWindow` is to have an idle timer, which resets for any hit-testing event, and after 30 seconds without user action, app would be locked and require user to login
- to provide a `UIWindow` subclass, notice step 3 of app launching procedure above, if we assign an instance of `UIWindow` subclass to `window` property in app delegate, system would not create a new one
- apart from `window` property of views and app delegate, `UIApplication.shared` also has a `keyWindow` property, which is _usually_ the same window instance, but sometimes it can be swapped to other window instances temporarily

## UIScreen

> "An object that defines the properties associated with a hardware-based display."

- iOS devices have a main screen and zero or more attached screens (e.g. AirPlay onto another screen).
- screen and window share the same coordinate system
- prior to iOS 8, screen/window coordinate system doesn't change for landscape or portrait orientation
- since iOS 8, screen/window rotates as the device rotates

`UIScreen` has properties `coordinateSpace` and `fixedCoordinateSpace`, of type `UICoordinateSpace`:

- `coordinateSpace` has origin at top left of the app
- `fixedCoordinateSpace` has origin at top left of the device and bottom above the Home button

## View

> Perhaps our eyes need to be washed by our tears once in a while, so that we can see Life with a clearer __view__ again.
> -- Alex Tan

### Visibility

- there are several ways to make a view invisible:
  1. set its `isHidden` to true
  2. set its `alpha` to 0
  3. set its `backgroundColor` to a color with `alpha` equal to 0
  4. use a combination of 2 and/or 3 with `alpha` approximating 0 so that human eyes can't see it
  5. mentally ignore it and visually do not look at it

While the 5th point is joking, the 4th point above isn't, setting a view's `alpha` to nearly zero can be useful in situation where a view cannot be hidden for receiving touch event (hidden view _usually_ won't receive touch events) but user isn't supposed to see it and you want it to avoid certain iOS optimisation behaviour for fully transparent view.

TODO: find an example use case

### `isOpaque`

> Honesty and transparency make you vulnerable. Be honest and transparent anyway.
> -- Mother Teresa

- `isOpaque` is a boolean which hints the system whether a view has transparency or not, if not, system could optimise the rendering performance
- its default value is `true` (no transparency), which is a valid assumption for non-game apps where features have higher priority than visual effects. How about games with lots of transparency effects? Games, especially games with fancy graphics, could be implemented with other libraries rather than UIKit.

From [Apple Doc](https://developer.apple.com/documentation/uikit/uiview/1622622-opaque):
> You only need to set a value for the opaque property in subclasses of UIView that draw their own content using the drawRect: method. The opaque property has no effect in system-provided classes such as UIButton, UILabel, UITableViewCell, and so on.

TODO: when setting view's alpha to less than 1, does it affect `isOpaque` at all? I guess not, but then do you need to set `isOpaque` explicitly to prevent unexpected behaviours (since system would think the view has no transparency)?

### Frame and Bounds

> Some people like my advice so much that they frame it upon the wall instead of using it.
> -- Gordon R. Dickson

- `frame` is a CGRect property, indicating the position of a `UIView` in its superview's coordinate system
- a view created in code without frame specified has default frame of `CGRect.zero`
- `bounds` rectangle describes a view’s location and size in its own coordinate system
- default bounds origin is (0,0) and the size is the same as the size of the rectangle in the frame property
- changing the size portion of `bounds` rectangle grows or shrinks the view __relative to its center point__
- sometimes due to non-even frame size or auto-layout constraints, view frames can be mis-aligned which leads to blurry image or text being displayed, this can be detected by turnning on Simulator's Debug -> Color Misaligned Images, a quick solution is to use frame's `integral`

Note: do not assume `bounds` is just `frame.size` with origin `(0, 0)`, a view is rendered with respect to its superview in such a way:

```
View Position = View Frame - Superview Bounds
```

Typically a view's `bounds` has `origin` zero, however for views like `UIScrollView` who has a `contentOffset`, the position of its subviews could be calculated using scroll view's `bounds.origin` set to the same of `contentOffset`, [this article](https://oleb.net/blog/2014/04/understanding-uiscrollview/) well explains `UIScrollView` with an animated GIF illustrating how it works.

## View Controller

UIKit provides a mechanism of managing user interface, in terms of displaying information to user via UI components (`UIView` subclasses), as well as replacing one screen with another screen of information with intuitive animation as needed. One of the key elements for information presentation as well as screen transition is view controller.

- a view controller manages a single view
- a view controller is a `UIResponder`, as well as its `view`'s `next` responder
- top level view controller is responsible for screen rotation permission and status bar appearance (status bar belongs to a secondary window)

### Hierarchy

View controllers can have hierarchy with two possible relationships:

1. Containment: VC1 contains VC2
 - VC1 is _parent_ view controller while VC2 is _child_ view controller
 - VC2's `view` is subview of VC1's `view`
2. Presentation: VC1 presents VC2
 - VC1 is the `presentingViewController` of VC2 while VC2 is the `presentedViewController` of VC1
 - VC2's `view` partially or fully covers VC1's `view`

### Transition / Navigation

The general idea of view controller, view, and even the UIKit itself, is all about data presentation and navigation based on user interaction, keeping this in mind can make it easier, well, less difficult, to understand the two _built-in_ concepts of transition:
 
**navigation**

Implemented by `UINavigationController` with a stack, view controllers can be pushed onto the stack, the stack can also pop back one or more view controllers that are already on the stack. There are animations associated with push and pop, pushing a view controller will make it sliding in from right of the screen, whereas popping would slide current view controller to the right of the screen.
 
**(modal) presentation**

> They're too big to render as tooltips, and they're too separate from the rest of the application to make sense in a modal dialog.
> -- ibm

The origin of the term "modal" isn't very clear, it's something that:
1. can't exist on its own, has to be presented by something else, but,
2. once appears, has to be made disappear before doing anything else 

In the sense of view, a modal view controller blocks access to the view who presents it, until the modal view controller is dismissed; A modal view controller often has UI elements for itself to be dismissed, such like buttons with Done or Cancel title.

Imagine we have a navigation controller (say `baseNav`) as `rootViewController` of the main `window`, and the view controller (say `baseVC`) on the navigation stack presents a modal view controller (say `modalVC`), it is observed that:

1. both `baseNav` and `baseVC` has `modalVC` as their `presentedViewController`
2. `modalVC`'s `presentingViewController` is `baseNav` instead of `baseVC`

So it can be said that the original presenter who is sent `self.present(_:animated:completion:)` may not be the `presentingViewController` of its `presentedViewController`. An analog of this (for the sake of easy understanding) is parents arranged marriage:

1. you married someone (`self.present(someOne, animated:true, completion:nil`), so you two are couple, as written on law document
2. however, the person you married was chosen by your parents on your behalf, so `someOne.presentingViewController` is your parents but not you
3. in this regard, both you and your parents have `self.presentedViewController` be the same `someOne`

All in all, this can be summarised as follows:

- __presented view controller__: the view controller being presented, that is, the first argument passed to `present(_:animated:completion:)`
- __presenter__: the view controller that the method `present(_:animated:completion:)` was sent to, in Apple's term, it's the _source_
- __presenting view controller__: the view controller whose view is covered (fully or partially) by presented view controller's view
- in certain cases, the source __presenter__ and __presenting view controller__ may not be the same, but they would both have __presented view controller__ as their `presentedViewController` 

Dismissing a presented view controller would break the modal relation between presenting view controller and presented view controller. A view controller whose `presentedViewController` isn't `nil` can't present another view controller. An analogy of this is single partner marriage: once you married someone, you have to break up with him/her before you can marry someone else.

There are a few customization options for presenting a (modal) view controller:

#### transition animation

You can create your own animation for presenting a modal view controller, and UIKit provides a few built-in options, which can be set to the view controller's (which will be presented) `modalTransitionStyle`:

- `.coverVertical`: When the view controller is presented, its view slides up from the bottom of the screen. On dismissal, the view slides back down. This is the default transition style.
- `.flipHorizontal`: When the view controller is presented, the current view initiates a horizontal 3D flip from right-to-left, as if the two views are two sides of a piece of paper. On dismissal, the flip occurs from left-to-right, returning to the original view. **Note**, by presenting a modal view controller this way, there is a chance that the main `window` is exposed (ie. visible) to the user, you might want to give a `backgroundColor` to the `window`.
- `.crossDissolve`: When the view controller is presented, the current view fades out while the new view fades in at the same time. On dismissal, a similar type of cross-fade is used to return to the original view.
- `.partialCurl`: When the view controller is presented, one corner of the current view curls up to reveal the presented view underneath. On dismissal, the curled up page unfurls itself back on top of the presented view. **Note**, a view controller presented using this transition is itself prevented from presenting any additional view controllers. This transition style only works for presenting full-screen view (`modalPresentationStyle`).

#### presentation style

`modalPresentationStyle` lets you choose how modal view controller should cover the screen:

- `.fullScreen`: as its name suggests, the presented view covers the screen. **Note**: the views belonging to the presenting view controller are removed after the presentation completes.
- `.overFullScreen`: similar to `.fullScreen`, but the views beneath the presented content are not removed from the view hierarchy when the presentation finishes. So if the presented view controller does not fill the screen with opaque content, the underlying content shows through.
- `.pageSheet`: similar to `.fullScreen`, except that in portrait orientation on iPad it has gap on top, and in landscape orientation on iPad and iPhone Pluses it has gap on left and right sides. The presenting view controller's view is dimmed and visible; **Note**, this style on non-Plus iPhones and iPhone Pluses in portraite orientation is treated as `.fullScreen`.
- `.formSheet`: similar to `.pageSheet` except that on iPad the presented view controller is even smaller. **Note**, the view controller presented as `.formSheet` has a `.compact` horizontal size class even on iPad.
- `.currentContext`: Using this presentation style, the current view controller's content is displayed over the view controller whose `definesPresentationContext` property is true. The views belonging to the presenting view controller are removed after the presentation completes. **Note**, when presenting a view controller in a popover, this presentation style is supported only if the transition style is coverVertical. Attempting to use a different transition style triggers an exception. However, you may use other transition styles (except the partial curl transition) if the parent view controller is not in a popover.
- `.overCurrentContext`: similar to `.currentContext`, but the views belonging to the presenting view controller are NOT removed, this is usually preferred than `.currentContext` to avoid unexepcted behaviour for views (of presenting view controller) that are removed and restored.

#### current context

If `currentContext` or `.overCurrentContext` is set as a view controller's `modalPresentationStyle`:

1. Starting from the source presenter view controller, UIKit walks up its view hierarchy until a view controller's `definesPresentationContext` is `true`, who will be the `presentingViewController`, its view will be replaced (`.currentContext`) or covered (`.overCurrentContext`) by presented view controller's view.
2. If there isn't a view controller in the hierarchy whose `definesPresentationContext` is `true`, it still works as if presented view controller's `modalPresentationStyle` is `.fullScreen`.
3. If the view controller in the hierarchy whose `definesPresentationContext` is `true`, its `providesPresentationContextTransitionStyle` is also consulted, if it's `true`, then its `modalTransitionStyle` is used for animation, the presented view controller's `modalTransitionStyle` is thus ignored.  

### View Creation

As described in [https://developer.apple.com/documentation/uikit/uiviewcontroller](https://developer.apple.com/documentation/uikit/uiviewcontroller), a view controller can load its view in several ways:
 
1. Storyboard can organize different scenes / view controllers with relations
2. Nib file
3. programatically using `loadView()`, actually, without implementing `loadView()` and no view instance assigned to view controller's `view`, by default a generic `UIView` instance is created and assigned to `self.view`
 
Note: view controller's `view` is lazily loaded, referring to UIViewController's `view` property before `view` is loaded can cause `view` creation with unexpected behaviour. `UIViewController` provides a few ways to workaround this:

- `isViewLoaded` can be used to check whether the `view` has been loaded
- `viewIfLoaded` is an optional and is non-nil only if the `view` has been loaded
- `loadViewIfNeeded` can be called to explicitly load the view, this is preferred rather than calling `view`

After view controller loads its `view`, the method `viewDidLoad` is called, where certain initialization task can be performed; __However__, at this point the view may not be added to the interface (ie. `view.superview` is `nil`), so any logic depending on `view`'s position and size should not be performed here.

### Life Cycle Events

`viewDidLoad`

As name suggests, the view controller has loaded its views, outlets have been connected, do not assume the views have correct positions and sizes.

`willTransition(to:with:)`
`viewWillTransition(to:with:)`
`traitCollectionDidChange(_:)`

Changes of the view controller's view, and/or trait collection. The first two methods require calling `super`

`updateViewConstraints`
`viewWillLayoutSubviews`
`viewDidLayoutSubviews`

Corresponding events for `view` are `updateConstraints` and `layoutSubviews`

`willMove(toParentViewController:)`
`didMove(toParentViewController:)`

Events sent during view controller containment: [https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html)

`viewWillAppear(_:)`
`viewDidAppear(_:)`
`viewWillDisappear(_:)`
`viewDidDisappear(_:)`

When `view` is being added to or removed from the interface, they all need to call `super` when overriding. To examine the reason for a view's appearing/disappearing, consult the following properties:

`isBeingPresented`
`isBeingDismissed`
`isMovingToParentViewController`
`isMovingFromParentViewController`

Use the Demo app (ie. build and run this project) and check Life Cycle Test for detailed life cycle events.

## View Layout

View layout can be done in three ways:

1. manual layout
2. autoresizing
3. autolayout

From what I've seen, there's only one trigger for laying out views, that is, whenver a view is resized, its `layoutSubviews` is invoked, the difference between the three ways of layout is as follows:

- manual layout: perform your own layout in `layoutSubviews`, this isn't usually done, but it offers the most freedom of laying out views, you can even implement your own system of auto layout
- autoresizing: done via autoresizing masks, in recent iOS versions it's observed that autoresizing masks are translated into layout constraints __before__ `layoutSubviews`, and `layoutSubviews` will just work as autolayout:
- autolayout: implemented by the SDK as part of `layoutSubviews`, you specify layout constraints which are then evaluated to work out each view's position and size

### Layout Constraint

Each constraint is a linear equation with the following format:

```
item1.attribute1 (relation to) multiplier x item2.attribute2 + constant
```

It can describe the width or height of a view, or a relationship between an attribute of one view and an attribute of another view, the two attributes don't have to be the same attribute, and the two views should have a common ancestor view.

Items:

- `firstItem`, `secondItem`, in case if constraint describes a views width or height, `secondItem` would be `nil` and `secondAttribute` would be `.notAnAttribute`

Attributes:

- `.width`, `.height`
- `.top`, `.bottom`, `.left`, `.right`, `.leading`, `.trailing`
- `.firstBaseline`, `.lastBsaeline`

Note: `.leading` / `.trailing` could be either `.left` / `.right` or `.right` / `.left` depends on system locale, some locals have text written from right to left.

Side note:

A few ancient scripts were written in the order of top to bottm, right to left, the wisdom is that, readers of the scripts naturally blink eyes after finishing a (vertical) line and starting a new line from the top, which is good for reliefing dry eyes; English text is nearly impossible to be written in such a way.

Relation:

`.equal`, `.lessThanOrEqual`, `.greaterThanOrEqual`

Priority:

Constraint has a priority from 1000 (high) down to 1 (low), this is used to determine the order of which constraints are applied. It can be useful in certain cases where you want a seconary constraint when the primary constraint can't be satisfied (TODO: example needed). In iOS 11, `UILayoutPriority` structure is used instead of a number for priority, priority values are still numbers wrapped as the struct's `rawValue`.

`UIView` has a property `constraints`, along with methods for adding and removing constraints; Constraints should be added to the view who's closest up the view hierarchy from views involved in the constraint:

- constraint specifying a view's width or height is added to the view itself
- constraint specifying a relation between a view and its superview is added to the superview
- constraint specifying a relation between two sibling views is added to their common superview

Since these could be determined without human brain, iOS 8 introduced a method in `NSLayoutConstraint` to `activate` an array of constraints, which adds constraints to correct views; Correspondingly there is also the method `deactivate(_:)` to remove constraints. A single constraint can be activated / deactivated by setting its `isActive` property.

Since auto-layout is a system way of laying out view in `layoutSubviews`, technically you can change views' frames in `layoutSubviews` even when using auto-layout, but this is usually not a good practice.

### Anchor

The way `NSLayoutConstraint` creates constraint can be capable for creating all kinds of constraints, however it's not very straight forward. A short path is to use anchor properties of `UIView`. For more details please see [Programatically Creating Constraints](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/ProgrammaticallyCreatingConstraints.html).

Apple keeps refining its SDK in new iOS versions, it's good to keep an eye on these updates in order to not feel outdated. iOS 10 added a method to create "layout dimension object" from two anchors:

```
anchorWithOffset(to:)
```

iOS 11 provided meethods for creating constraints with constant based on system spacing, this can be useful since the system spacing can change in certain circumstances.

### Visual format

Visual format can represent multiple constraints in one go, for details please read [Visual Format Language](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html).

### Layout Events

**`updateConstraints`**

Propagated from the deepest subview up the hierarchy, invoked when the runtime determines that the view might need to configure its constraints - so you can alter the constraints if needed, but don't forget to call `super`, and don't call this method directly, use `setNeedsUpdateConstraints` and `updateConstraintsIfNeeded`.

**`traitCollectionDidChange(_:)`**

Invoked at launch time as well as when trait collection did change, as its name suggests. Note, trait collection change doesn't only happen when device is rotated, but also in certain other circumstances, like multitasking split on iPad. If UI has size-class dependent behaviour, this is a place to do it, such like updating constraints, adding or removing views.

**`layoutSubviews`**

Invoked from top and propogated down the view hierarchy, when change happens for example, constraint change, view content change (e.g. text of label changes), and superview size change. It's an opportunity to perform manual layout after autoresizing is done, don't forget to call `super` if using autolayout. Again, do not call this method directly, use `setNeedsLayout` and `layoutIfNeeded`.

It's fine to tweak layout outcome by overriding this method, first call `super` to evaluate autolayout, then change the things that are not quite right, in the end, call `super` again. Make sure any change should only involve subviews of the view, because this event is propogated down the view hierarchy. Do not think about `setNeedsUpdateConstraints`, that is propogated up the view hierarchy and should have finished at this point.

## Margins, Guides and Safe Area

UIKit has a concept of "edge insets" for optimal user friendliness as well as preventing content from underlapping system components such like status bar, navigation bar, toolbar and tab bar. There has been quite a few changes in term of how margins work over the last few iOS versions, it's not straight forward to understand every single bit of it, documentation on each bit explains only that bit, and always leaves you with the sentence below:

> Thank you Mario! But our princess is in another castle!

### `UIEdgeInsets`
A struct consisting of four floats for edge inset values.

### `UILayoutGuide`
A placeholder inserted in view hierarchy that has all kinds of anchors just like a `UIView`. The benefit of layout guide compared to placeholder views are reduced cost for maintaining placeholder views as well as prevent invisible placeholder views intercepting messages intended for other views.

### `topLayoutGuide` and `bottomLayoutGuide` (deprecated in iOS 11)
Introduced in iOS 9 as a placeholder for possible top and bottom bars (e.g. navigation bar, tab bar ,etc), so that views constrained with respect to the layout guides won't underlap with system components.

### `safeAreaLayoutGuide`
Introduced in iOS 11 to replace `topLayoutGuide` and `bottomLayoutGuide`.

### `safeAreaInsets`
Same as `safeAreaLayoutGuide` but as edge inset values.

### `safeAreaInsetsDidChange`
A method of `UIView` which is invoked when the view's safe area has changed.

### `viewSafeAreaInsetsDidChange`
A method of `UIViewController`, invoked when safe area of the view controller's main views has changed.

### `additionalSafeAreaInsets`
Insets further on top of the automatic safe area.

### `layoutMargins`
A visual buffer between a view’s content and any content outside of the view’s bounds. To set up constraints that respect the layout margins, enable the _Constrain to margins_ option in Xcode

### `layoutMarginsGuide`
`layoutMargins` as a `UILayoutGuide`

### `directionalLayoutMargins`
Introduced in iOS 11, this is usually preferred over `layoutMargins`, it takes into account the language direction for device locale, some languages have right-to-left text

### `preservesSuperviewLayoutMargins`
A subview overlapping its superview's margin may have the amount of overlap as its own minimum margin. For example, `containerView` has `directionalLayoutMargins` with top inset of 50, its subview `childView` is pinned 20 points to the top edge of the `containerView`, and `childView` has `preservesSuperviewLayoutMargins` set to `true`, thus `childView` would have a top margin of 30.

### `insetsLayoutMarginsFromSafeArea`
Default is `true`, a view's effective margin is calculated with safe area taken into account. For example, a view with a top margin of 12 underlaps status bar who's height is 20, then subviews pinned to top margin of the view would appear 32 points below the top of the view.

### `systemMinimumLayoutMargins`
Introduced in iOS 11, `UIViewController`'s `systemMinimumLayoutMargins` specifies margins on the view controller's view as a minimum, below which the layout margins for the main view would not be effective. By default it has 0 for top and bottom and 16 on each sides for small devices, and 20 for larger devices.

### `viewRespectsSystemMinimumLayoutMargins`
A boolean whose value is `true` by default, setting it to `false` will ignore `systemMinimumLayoutMargins` as its name says.

## Traits

Due to the variation of devices, such like iPhones with different screen sizes, as well as iPad with bigger display realestate, sometimes constraints alone are not enough to manage layout, thus traits are introduced.  

> All wise men share one __trait__ in common: the ability to listen.

Traits in UIKit specify the current environment associated with certain objects, like views and view controllers.

- `horizontalSizeClass`, `verticalSizeClass`: general width and height of the interface, possible valuess:
 - `compact`, `regular` and `unspecified`
- `displayScale`: whether the content is displayed on a Retina display or a standard-resolution display. Use it (as needed) to make pixel-level layout decisions or to choose which version of an image to display.
- `userInterfaceIdiom`: type of the device, iPad or iPhone

**Note**, Apple suggests that the use of `userInterfaceIdiom` should be avoided as much as possible, unlike Android where developers may not have a definite list of devices to support, they have no choice but have to think in a more generic way; However, in early days there were only two types of screen sizes in the mind of developers: iPhone and iPad. Now the mindset should be adapted to size classes - how the interface should look like on a screen with `.regular` width and/or `.compact` height? How it works if the device has both width and height be `.compact`? These questions should be asked and thought about, instead of thinking iPad or iPhone. _this is a common mistake that not only developers, but also designers make when designing UI._

### Event Cycle

On a typical device rotation, size classes changes are propogated from main `window` to all view controllers in its hierarchy:

1. `willTransitionToTraitCollection:withTransitionCoordinator:` - tells each relevant view controller that its traits are about to change.
2. `viewWillTransitionToSize:withTransitionCoordinator:` - tells each relevant view controller that its size is about to change.
3. `traitCollectionDidChange:` - tells each relevant view controller that its traits have now changed.

## Layers

> Life is like an onion: you peel off layer after layer, then you find there is nothing in it.

Some people may think that eye is the tool for seeing, strictly speaking, eye is merely a tool that allows light to pass through onto retina behind the eye ball, and retina would then convert the light it receives into something that the optic nerve could understand, which then forms the image **in the brain**. Analog to this, a `UIView` instance has a `CALayer` instance, their relationship is similar to eye ball, retina and optic nerve, that a view is a delegate of its layer, and the layer does the actual drawing.

- Custom `CALayer` subclass for `UIView` can be implemented by subclassing `UIView` and implementing its `layerClass` property to return the class of the custom `CALayer` class
- View hierarchy is layer hierarchy: if view A has a subview B, then view A's layer is also the superlayer of B's layer
- Changing a view's properties is merely a convenient way of changing properties of its underlying layer, e.g. a view's `clipsToBounds` vs its layer's `masksToBounds`
- Layer can have multiple sub-layers
- The order of a layer's `sublayers` doesn't only depend on their index in the `sublayers` array, but also each layer's `zPosition`: sublayers with the same `zPosition` value are drawn in the order of the index in the `sublayers` array, layers with lower `zPosition` are drawn before layers with higher `zPosition` value
- a layer created in code has `frame` and `bounds` all equal to `CGRect.zero` (ie. not visibule).

**Note**, since layer's `zPosition` has a default value of 0.0, by default, they behave as if they are ordered by the order in the sublayers array, and because view hierarchy is the same as layer hierarchy, changing the `zPosition` of a layer which is a subview's underlying layer, could change the order of which the subviews are drawn.

A layer's position within its superlayer is determined by `position` and `anchorPoint`

`position`: a point in the superlayer's coordinate system
`anchorPoint`: where the `position` is located within the layer itself, from top-left (0.0, 0.0) to bottom-right (1.0, 1.0), by default, `anchorPoint` is (0.5, 0.5), which means the layer's `position` is the layer's center



