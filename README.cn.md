# UIKit笔记

UIKit是iOS开发的一个重要部件，任何对UI的疑问首先应该查阅的便是UIKit文档，因为这是第一手的资源，只有当UIKit文档解决不了问题时才应该去Google。顺便说一句，有大学文凭的父母是值得敬佩的，因为他们是在没有Google的时代完成了学业。

这个文档仅仅是我在学习UIKit时记下的笔记，并不能替代UIKit本身的文档，只是一些我觉得值得记下的东西。  

## App启动

（App的中文发音有许多种，常见的有三个字母分开读的A，P，P，以及完全中文发音的爱啪啪）

> In C, the "main" function is treated the same as every function, it has a return type (and in some cases accepts inputs via parameters). The only difference is that the main function is "called" by the operating system when the user runs the program. Thus the main function is always the first code executed when a program starts.  
> （C语言里"main"函数和其他函数相同，它有一个返回值，有时候还能接收输入参数。唯一的区别在于"main"函数是在用户运行程序时被操作系统调用，因此main函数总是程序开始时首先执行的入口。）

参考： <https://www.cs.utah.edu/~germain/PPS/Topics/C_Language/c_functions.html>

ObjectiveC和C语言联系紧密，从代码里就可以看出线索：

```
// Objective-C语言的iOS项目

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```

许多面向过程的编程语言都有一个起始函数，如C语言的`main`，对于iOS程序来说，入口函数则是`UIApplicationMain`，它做的事情是：

1. 初始化`UIApplication`对象，得到一个`UIApplication.shared`指向的实例
2. 初始化app的代理委托（delegate），并保存为`UIApplication`实例的`delegate`；用来初始化delegate的类就是代码里标注为`@UIApplicationMain`的类
3. 如果app委托delegate的`window`属性等于`nil`，则初始化一个`UIWindow`并赋值给app委托delegate的属性`window`，用屏幕的`bounds`来设置窗口的`frame`，使得窗口的大小刚好能覆盖硬件设备的屏幕
4. 看看Info.plist里`UIMainStoryboardFile`有没有指定Storyboard名字，如果有，则初始化Storyboard指定的起始`UIViewController`，并赋值给`window`的`rootViewController`（注意，项目里的Info.plist名字不一定非得是Info.plist，取决于项目Build Settings里指定的"Info.plist File"值）
5. `rootViewController`的`view`自然的成为了`window`的子视图（subview）
6. 调用`application(_:didFinishLaunchingWithOptions:)`来通知app delegate这个app已经启动了
7. 调用`window`的`makeKeyAndVisible`方法，将此`window`设为可见

TODO: 示意图
TODO: 不用storyboard启动app的过程步骤

- 有些情况下app用户会看到`window`窗口，可以适当的给`window`一个符合app主体格调的背景色`backgroundColor`
- 早期的Objective-C项目模版里，`makeKeyAndVisible`是放在`applicationDidFinishLaunching`里面的，所以我觉得上文中第6步和第7步的顺序是对的
- 我找到一篇2012年的文章，里面有一个程序启动步骤示意图，是一篇很老的文章，还在世界末日之前，所以内容应该会有些许过时，然而看看当年的程序启动步骤还是不无裨益的。[文章点这里](https://oleb.net/blog/2012/02/app-launch-sequence-ios-revisited/) 

## UIWindow

> computer is like air conditioner, they both stop working when you open Windows.  
> （计算机跟空调一样，当你打开窗户(windows)时就不工作了。）

- 程序的窗口`window`有自己的`rootViewController`，它的`view`是所有其他`view`的父视图(super view)，因此：
- 任何在此窗口`window`内的视图`view`都有这个窗口`window`的引用，`view.window`，UIKit文档里说：如果一个`view`的`window`属性是`nil`，那么可以判断这个`view`尚未加入到这个窗口`window`里
- 这也许是一个更好的判断`view`是否在视图结构（view hierarchy）里的办法，当`view.window`等于`nil`的时候，它肯定不在可见的view hierarchy里，即便`view.superview`不等于`nil`
- 除了可见视图外，窗口`UIWindow`还有些别的功能，比如hit-testing（触摸屏是否被触动），某些时候这个功能很有用，比如一个需要用户登陆，并且一定闲置时间后会自动锁屏的程序，可以用一个继承`UIWindow`的子类，利用一个计时器来得知是否用户一定时间没有操作了
- 要试用`UIWindow`的子类，看看前文的第3步，如果我们在它之前给app delegate的`window`赋一个值，那么系统就不会再创建一个新的`UIWindow`
- 除了app delegate有一个当前`window`的属性外，`UIApplication.shared`也有一个`keyWindow`属性，从名字不难看出，`keyWindow`_通常_是app delegate的`window`实例，然而有些情况下它会被临时赋予不同的`window`（TODO: 什么情况？）

## UIScreen

> "An object that defines the properties associated with a hardware-based display."  
> "一个定义了跟硬件显示屏相关属性的对象"

- iOS设备有一个主屏幕(screen)和零到若干个附加屏幕（比如AirPlay隔空播放的其他屏幕）
- 屏幕(screen)和视窗(window)共用同一个坐标系统
- iOS 8之前，屏幕和视窗的坐标系统不会因为设备的横屏(landscape)和竖屏(portrait)而改变
- 从iOS 8开始，屏幕和视窗的坐标系统会跟设备同时旋转

`UIScreen`有两个属性：`coordinateSpace`和`fixedCoordinateSpace`，两者的类型都是`UICoordinateSpace`，区别在于：

- `coordinateSpace`的原点是app当前显示的左上角
- `fixedCoordinateSpace`的原点始终是设备竖屏时的左上角，往Home按钮延伸

## View

> Perhaps our eyes need to be washed by our tears once in a while, so that we can see Life with a clearer __view__ again.  
> （也许我们的眼睛要时不时的被泪水清洗，才可能以更清晰的观点(view)来看待人生。）  
> -- Alex Tan

### Visibility/可见

- 要让一个`view`不可见，有如下几种方法：
  1. 将它的`isHidden`属性设为`true`
  2. 将它的`alpha`属性设为0
  3. 将它的`backgroundColor`设置成一个`alpha`等于0的颜色
  4. 将方法2跟方法3结合，两个`alpha`都接近于0，使得人眼基本看不到
  5. 心理上忽略它，视觉上不去看它

第五个方法是在开玩笑，然而第四个方法却不是，将一个`view`的alpha设为接近于0使得肉眼看不到这个`view`，在某些情况下是一个解决问题的方法，因为完全被隐藏的`view`（无论是通过`isHidden`还是`alpha`等于0）_通常_不会接收触碰事件，而你需要这个`view`仍然接收触碰事件且不能被用户看到，同时还要避免iOS针对完全透明的`view`采取的一些优化措施。

TODO: 举个栗子

### `isOpaque`

> Honesty and transparency make you vulnerable. Be honest and transparent anyway.  
> （诚实与透明(opaque)让你变的容易受伤，但无论如何还是得诚实透明。）  
> -- Mother Teresa

- `isOpaque`是一个布尔值，告诉系统这个`view`是否需要透明（包括全透明和半透明），如果没有任何透明，那么系统可以优化此`view`的渲染性能
- `isOpaque`的默认值为`true` (不透明)，对功能型程序来讲这个默认值是普遍适用的，因为功能型程序往往注重的是提供专业的功能而不是炫目的特效；如果是视觉炫酷的游戏呢？一般来讲，游戏，尤其是充满了各种视觉效果的游戏，有比UIKit更好的函数库来实现。

[UIKit文档](https://developer.apple.com/documentation/uikit/uiview/1622622-opaque)：
> You only need to set a value for the opaque property in subclasses of UIView that draw their own content using the drawRect: method. The opaque property has no effect in system-provided classes such as UIButton, UILabel, UITableViewCell, and so on.  
> （你只需要对重写`drawRect:`方法的`UIView`子类设置`isOpaque`，这个属性对于系统提供的类，如`UIButton`，`UILabel`，`UITableViewCell`没有作用。）

TODO: 将一个`view`的`alphas`设为小于1的值，会不会影响这个`view`的`isOpaque`属性？我猜不会，但这种情况下是否需要同时将`isOpaque`设为`false`来避免意外的行为，因为系统还以为此`view`并不透明？

### Frame and Bounds

> Some people like my advice so much that they frame it upon the wall instead of using it.  
> 有的人很喜欢我的建议，以至于他们把我说的话裱(frame)起来挂在墙上却不去采纳。  
> -- Gordon R. Dickson

- `frame`的类型是`CGRect`，表示一个`UIView`在其superview坐标系统里的位置和大小
- 用代码创建的view没有指定frame时，默认的frame为`CGRect.zero`
- `bounds`描述了一个view在其自身坐标系中的位置和大小
- 默认的`bounds`原点在(0, 0)，大小和`frame`的大小相等
- 改变`bounds`的大小会使view__以其中心点坐标为参照__而放大或缩小
- 由于`frame`的大小有时候不是偶数，或者因为自动布局的约束，计算view的`frame`时会导致模糊的图片或文字标签，这个问题可以通过模拟器的Simulator's Debug -> Color Misaligned Images来检测，一个快速的解决办法是用frame的`integral`属性

注意：不要认为`bounds`只是简单的把`frame.size`和原点`(0, 0)`放在一起，view位置的计算方法如下：

```
View的位置 = View的Frame - 父View的Bounds
```

虽然view的`bounds.origin`通常都等于0原点(ie. `(0, 0)`)，然而有些view如`UIScrollView`，有一个`contentOffset`，用上面的公式计算其子view位置时要用它的`contentOffset`来替代它的`bounds.origin`，[这篇文章](https://oleb.net/blog/2014/04/understanding-uiscrollview/)以图文并茂的方式很好的解释了`UIScrollView`的工作原理并且还是会动的图。

## View Controller

UIKit提供了一套管理用户界面的机制，用不同的UIKit控件(`UIView`的子类)来显示必要的信息，并且支持以动画的方式由一个屏幕界面切换到另一个屏幕界面，以相应用户的交互操作。这其中的一个重要组件就是视图控制器（View Controller）。

- 一个view controller管理一个单独的view
- view controller是一个（is-a）`UIResponder`，也是它的`view`的`next`（`UIResponder`属性）
- 最上层的view controller要负责屏幕旋转的许可以及状态条（status bar）的外观（状态条属于另外一个`UIWindow`）

### 结构

View Controller互相之间有两种可能的结构关系：

1. 容器关系（containment）：View Controller A包含了View Controller B，A则是容器类
 - A是B的`parent`，B是A的`children`之一
 - B的`view`是A的`view`的`subviews`之一
 - A的`view`是B的`view`的`superview`
2. 展示关系（presentation）: View Controller A 展示（present）View Controller B
 - A是B的`presentingViewController`而B是A的`presentedViewController`
 - B的`view`局部或全部的覆盖了A的`view`

### 界面过渡 / 导航 (Transition / Navigation)

View Controller，View以至于UIKit本身，基本的概念都是以导航(navigation)的方式显示信息并相应用户的操作，清楚了这一点，再去看UIKit会觉得容易许多，至少不会觉得那么难。UIKit自带两种形式界面的过渡：
 
**导航 (navigation)**

`UINavigationController`包含了一个存放View Controller的栈(Stack)，View Controller可以被推(push)到栈里，也可以从栈里弹出(pop)，push和pop有相应的动画效果。
 
**（模态）展示 (presentation)**

> They're too big to render as tooltips, and they're too separate from the rest of the application to make sense in a modal dialog.  
> （它们太大而无法呈现为工具提示，并且它们与应用程序的其余部分分开，以至于在__模态对话框__中也无意义。）
> -- ibm

“模态” (modal) 一词的来源不是很清楚，它用来表示一个东西：
1. 无法独立存在，必须通过其他东西来呈现 (present)
2. 一旦显示出来，必须移除之后才能做其他事情 

作为视图来说，一个模态的View Controller会阻止用户访问这个模态View Controller覆盖的视图，直到这个模态View Controller被移除；一个模态View Controller通常有一些控件来表示它可以被移除，比如一个标题为“确定”或“取消”的按钮。

假设有一个navigation controller名叫`baseNav`，它是程序`window`的`rootViewController`；`baseNav`的栈里有一个ViewController (`baseVC`)，`baseVC`又显示了一个模态View Controller (`modalVC`)，代码如下：

```
let baseVC = UIViewController()
let baseNav = UINavigationController(rootViewController: baseVC)
window.rootViewController = baseNav
let modalVC = UIViewController()
baseVC.present(modalVC, animated: true)
```

我们观察到：

1. `baseNav`和`baseVC`的`presentedViewController`属性都指向`modalVC`
2. 虽然是`baseVC`显示(present)的`modalVC`，可`modalVC`的`presentingViewController`是`baseNav`

结论是调用`self.present(_:animated:completion:)`的View Controller未必是它自己的`presentedViewController`的`presentingViewController`，一个可以类比的栗子是家长包办的婚姻：

1. 你娶了某人(`self.present(某人, animated:true)`)，因此法律文件上你和某人(`someOne`)是夫妻
2. 然而，你娶的这个人是你家长代表你来选择的，因此`某人.presentingViewController`是你的家长而不是你
3. 鉴于此，你和你家长的`self.presentedViewController`都是`某人`，法律上你娶了`某人`，实际上你的家长也娶了`某人`。

总而言之，可以概括如下：

- `presentedViewController`被以模态显示的View Controller，传入`present(_:animated:completion:)`的第一个参数
- __presenter__：调用`present(_:animated:completion:)`的View Controller，用苹果的话来讲，就是源(source)View Controller
- `presentingViewController`：自己的`view`被`presnetedViewController`局部或全部覆盖的View Controller
- 某些情况下，源__presenter__和`presentingViewController`不是同一View Controller，但它们有同一个`presentedViewController`

移除(dismiss)一个`presentedViewController`会解除它和显示它的`presnetingViewController`之间的模态关系，否则，一个`presentedViewController`不是`nil`的View Controller无法同时显示另一个模态View Controller，这就像一夫一妻制，一旦你嫁给了这个人，你必须先和他接触婚姻关系，才能在嫁给别人。

显示一个模态View Controller有许多可以定制的界面过渡行为。

#### 过渡动画

可以给View Controller自己的`modalTransitionStyle`设置一个内建的选项，来决定它以模态显示时所呈现的动画效果：

- `.coverVertical`: 模态View Controller从屏幕下面网上移入。当这个View Controller被移除的时候，它会动态的往屏幕下方移出。这是默认的过渡效果。
- `.flipHorizontal`：模态View Controller会进行一个水平方向从右向左的立体翻转，就好像它的`view`和当前的`view`是一张纸的两面。当这个View Controller被移除的时候，过渡动画则为从左向右翻转，回到源View Controller。**注意**，View Controller以这种效果显示的时候，程序的`window`有一定的几率会被用户看见，这时候，给`window`一个符合App格调的背景色(`backgroundColor`)就尤为重要
- `.crossDissolve`：当前View Controller的`view`会渐隐而模态View Controller的`view`会渐显；移除模态View Controller时，相反的渐隐渐显，返回到源View Controller
- `.partialCurl`：如同翻页一般，当前View的一角会翻起，显示出下面的模态View Controller；移除模态View Controller时，之前的源View Controller会被翻卷回来。**注意**，以此种方式显示的模态View Controller无法在其上显示额外的模态View Controller，而且这种显示方式只对全屏幕视图有效。

#### 显示方式

`modalPresentationStyle`可以用来定制模态View Controller显示后如何覆盖之前的屏幕内容。

- `.fullScreen`：模态View Controller覆盖整个屏幕。**注意**，模态View Controller显示完成后，它的`presentingViewController`的`view`将会被移除
- `.overFullScreen`：与`.fullScreen`类似，但模态View Controller下面的View不会被移除，因此，如果模态View Controller的`view`有透明的颜色，它下面的View的内容也会被看到
- `.pageSheet`：与`.fullScreen`相似，除了在以下两种情况时：
    1. iPad竖屏时界面的上方会留出空白
    2. iPad与iPhone Plus横屏时，界面最左和最右边都会留出空白
  模态View Controller显示之后，`presentingViewController`会变暗，**注意**，在非Plus的iPhone和竖屏iPhone Plus里，`pageSheet`的效果和`fullScreen`相当  
- `.formSheet`：和`.pageSheet`相当，区别是在iPad上，`presentedViewController`看起来更小，**注意**，即使在iPad上，以`formSheet`方式显示的View Controller依然有一个`.compact`的大小类型(size class)
- `.currentContext`：模态View Controller会覆盖视图结构中`definesPresentationContext`属性为`true`的View Controller，而`presentingViewController`的`view`会被移除。**注意**，如果在一个`popover`里以这种方式显示模态View Controller，则它的`modalTransitionStyle`必须是`.coverVertical`，否则抛出一个异常；如果不是在`popover`里显示模态View Controller，则可以用其他的`modalTransitionStyle`（除去`.partialCurl`）来显示这个View Controller。
- `.overCurrentContext`：类似于`.currentContext`，区别在于`presentingViewController`的`view`不会被移除，这种方式相比`.currentContext`的好处是不需要将移除的`presentingViewController`的`view`再放回去，因为有些自定义的`view`被从`superview`移除时会进行一些一次性的操作而无法再被放回`superview`里。

#### 当前内容 (Current Context)

当一个View Controller的`modalPresentationStyle`设置为`.currentContext`或`.overCurrentContext`时：

1. 从源View Controller开始，UIKit往根部遍历视图结构(view hierarchy)，直到发现一个View Controller的`definesPresentationContext`属性为`true`，然后用这个View Controller作为`presentingViewController`，它的`view`将会被模态View Controller的`view`替代或覆盖，取决于模态View Controller的`modalPresentationStyle`是`.currentContext`还是`.overCurrentContext`
2. 如果找不到任何`definesPresentationContext`属性为`true`的View Controller，那么这个模态View Controller的`modalPresentationStyle`就会被当作是`.fullScreen`来操作
3. 如果找到`definesPresentationContext`属性为`true`的View Controller，而它的`providesPresentationContextTransitionStyle`属性为`true`，那么这个View Controller的`modalTransitionStyle`会代替模态View Controller的同一属性。  

### 建立视图 / View Creation

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
