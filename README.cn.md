# UIKit笔记

(English Version: [README.md](./README.md))

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

第五个方法是在开玩笑，然而第四个方法却不是，将一个`view`的alpha设为接近于0使得肉眼看不到这个`view`，在某些情况下是一个解决问题的方法，因为完全被隐藏的`view`（无论是通过`isHidden`还是`alpha`等于0）_通常_不会接收触碰事件，而你又不想用`isHidden`（一个View的`isHidden = true`时会被从Window里移除）并且不想让这个`view`接收触碰事件也不能被用户看到，此外，也可以避免全透明的View会得到一些特别的优化（这点不确定）。

演示：UIView - Alpha & Interaction

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


`UIViewController`的文档[https://developer.apple.com/documentation/uikit/uiviewcontroller](https://developer.apple.com/documentation/uikit/uiviewcontroller)里提到，View Controller有三种途径装载View：

1. 通过Storyboard，并且还可以组织不同的场景(Scene)之间的过渡关系
2. Nib (.xib) 文件
3. 在`loadView()`方法中写代码。实际上，即使没有在`loadView()`方法里给`self.view`赋值，`self.view`也会被赋予一个新创建的`UIView`实例

**注意：**因为View Controller的`view`是在使用到的时候才会被装载，在被装载前使用`UIViewController`的`view`属性可能会导致不可预知的行为，`UIViewController`对此提供了一些解决方法：

- `isViewLoaded`属性可以用来检查`view`是否已被装载
- `viewIfLoaded`是可有可无(Optional)的属性，只有当`view`被装载后才是一个非`nil`的值
- `loadViewIfNeeded`方法可以用来强制装载`view`，这个方法比直接使用`view`安全

View Controller装载自己的`vew`之后，会调用`viewDidLoad`方法，这里面可以做一些初始化的工作，**注意：**这个时候`view`并不一定被显示出来，`view.superview`也许还是`nil`，所以任何依赖于`view`的位置和大小的逻辑都不应该在这里展开。

### 生命圈事件 / Life Cycle Events

`viewDidLoad`

正如其名，View Controller装载了自己的`view`后会调用这个方法，此时，UI的输出口(`@IBOutlet`)已经连接完成，但view的大小和位置还并不确定。

`func willTransition(to newCollection: UITraitCollection, 
           with coordinator: UIViewControllerTransitionCoordinator)`

当前对象的traits改变之前，UIKit会调用任何被影响到的View和View Controller的这个方法，继承这个方法可以根据`newCollection`的值来适当的改变当前的界面，例如一个View Controller的`children`包含了四个子View Controller，竖屏时为2x2（二行二列）分布，横屏时则变成1x4（一行四列）分布，并且可以用参数`coordinator`来实现动画效果。**注意：**不要忘了呼叫`super`方法。

`func viewWillTransition(to size: CGSize, 
           with coordinator: UIViewControllerTransitionCoordinator)`
           
当前对象的大小改变前会调用这个方法。

`traitCollectionDidChange(_:)`

当前的界面环境改变后，这个方法会被调用，如果要实现这个方法，别忘了一开始呼叫对应的`super`方法。

`updateViewConstraints`

当View Controller需要更新constraints时会调用此方法，重写这个方法来做一些constraints的调整。**注意：** 改变constraints的代码一般只需要放在具体事件后，比如按一个按钮会导致一些constraints的改变，那么就可以直接在按钮的Action里改变constraints，只有当constraints复杂时才需要考虑重写这个方法。TODO: 举个例子

`viewWillLayoutSubviews`
`viewDidLayoutSubviews`

这两个方法是当`UIViewController`的`view`重新布局其`subview`之前和之后被调用。

`willMove(toParentViewController:)`
`didMove(toParentViewController:)`

这两个方法是当`UIViewController`被加入到另一个容器View Controller的`children`之前和之后被调用。

包含`children`的容器View Controller常见的事件[https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html)：

`viewWillAppear(_:)`
`viewDidAppear(_:)`
`viewWillDisappear(_:)`
`viewDidDisappear(_:)`

以上的方法在`view`被加入到界面或从界面移除时被分别调用，重写其中任何一个方法都要记得呼叫`super`；下面几个属性可以用来判断`view`出现或移除的具体原因：

`isBeingPresented`
`isBeingDismissed`
`isMovingToParentViewController`
`isMovingFromParentViewController`

此Demo演示app中的Life Cycle Test可以看到UI不同阶段所出发的具体事件。

## 视图布局 / View Layout

View的布局有三种途径：

1. 手工布局
2. 自动缩放 (auto-resizing)
3. 自动布局 (auto-layout)

当一个View大小改变时，它的`layoutSubviews`会被调用，以上三种布局方式的区别在于：

- 手工布局：这种方式一般用不到；你自己来决定`subviews`该如何分布，包括每个View的位置和大小，这是自由度最大的布局方式，你甚至可以创造一个定制的布局系统
- 自动缩放：通过View的`autoresizingMask`来实现，我发现最近几个版本的iOS会先把`autoresizingMask`转换成布局约束(layout constraints)，然后再通过自动布局来决定每个View的位置和大小
- 自动布局：UIKit自带的布局机制，你针对每个View以及不同View之间的位置关系定义一系列布局规则，然后UIKit会根据你定义的规则来计算出每个View实际显示出来的位置和大小

### 布局约束条件 / Layout Constraint

每个约束规则都可以被描述为一个线性表达式：

```
item1.attribute1 (relation to) multiplier x item2.attribute2 + constant
A.属性1 关系于(等于、大于、小于等等) B.属性2 x multiplier增幅倍数 + constant常量
```

它也可以描述一个View的宽或者高，或者两个不同View的某个属性间的关系，两个View的属性可以不是同一个属性，并且两个View得有一个共有的容器View。

TODO: 举个例子

Items:

- `firstItem`, `secondItem` 如果某个布局约束描述的是一个View的宽或者高，则`secondItem`会等于`nil`，`secondAttribute`会等于`.notAnAttribute`

Attributes:

- `.width`, `.height`
- `.top`, `.bottom`, `.left`, `.right`, `.leading`, `.trailing`
- `.firstBaseline`, `.lastBsaeline`

**注意：** `.leanding`和`.trailing`不一定是左和右，取决于系统区域设置，有些文化的文字书写是从右向左的；因此不要认为`.leading`一定是左边，`.trailing`一定是右边。

多说一句：有一些古文字是从上往下写的，这里面的智慧是，看书的人从上到下看完一列字后，再看第二列的文字时必须把目光从第一列的最下面移动到第二列的最上面，这个过程中眼睛会不自觉的眨一下，这样的好处是看书久了可以减轻眼睛的疲劳。

关系：

`.equal`, `.lessThanOrEqual`, `.greaterThanOrEqual`

优先权：

Constraint有一个优先权的属性，从高 (1000) 到低 (1)，用来决定执行约束条件的顺序。一个常见的用途是主要的约束条件无法满足时需要一个候补约束条件（TODO: 举个例子）。从iOS 11开始，`UILayoutPriority`是一个结构而不再是一个简单的数值，具体的优先权数值作为`rawValue`被包含在结构里。

`UIView`有一个`constraints`属性，还有可以用来添加或删除约束条件的方法；约束Constraint应该被添加到与此约束针对的View最接近的父View里：

- 指定一个View的长或宽的约束要加到这个View本身
- 指定一个View与其父View关系的约束要加到父View里
- 指定两个同层次View之间关系的约束要加到这两个View共同的父View里

上面这三条关于约束要加到哪里的规则，不需要思考就可以由系统自动判断，所以从iOS 8开始，`NSLayoutConstraint`有了一个方法叫`activate`，参数是一个包含了约束的数组，这个方法把参数传入的各种约束添加到适当的View里；相对应的还有一个`deactivate(_:)`方法用来移除已经加入到View里的约束；单一的约束可以设置它本身的`isActive`布尔属性来激活和移除。

因为自动布局也只是一个系统自带的，在`layoutSubviews`时执行的布局方式，技术上来讲，在`layoutSubviews`里你仍然可以改变View的`frame`，但是一般不需要这么搞。

### 锚点 / Anchor

`NSLayoutConstraint`类提供了一个普遍适用的创建布局约束的方法，然而正因为普遍适用，所以用起来并不是很方便。就好像一个N合一的多功能机器，每个功能都只是堪用而并没有太好的用户体验。另一个简洁的办法是用UIView的anchor。具体的信息可以参考[Programatically Creating Constraints](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/ProgrammaticallyCreatingConstraints.html).

每个新的iOS SDK都有可能对已有的东西进行更新，时不时的关注这些信息可以让自己不被时代的车轮抛弃。iOS 10新增了以两个Anchor之间距离来创建新Anchor的方法：

```
func anchorWithOffset(to otherAnchor: NSLayoutXAxisAnchor) -> NSLayoutDimension
```

返回的`NSLayoutDimension`对象则是一个新的Anchor，用来表示两个Anchor之间的距离，如果把另外一个View的`widthAnchor`约束为与这个新Anchor相等，那么这个View的宽就始终会等于前两个Anchor之间的距离。

iOS 11增加了根据系统默认间距来创建布局约束的一些方法，创建的约束会根据系统默认间距的改变而改变。

### 可视格式 / Visual format

可视格式的布局可以用一行ASCII文字来表达许多个布局约束，然而可读性却可能会降低，所以实际用的并不多。具体信息参考[Visual Format Language](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html).

### 布局事件 / Layout Events

**`updateConstraints`**

App运行时如果觉得你的View需要设置布局约束，就会从View层次结构中最深层的subview往上传播这个方法，因此你可以改动布局约束，不要忘了呼叫`super`方法，而且不要直接调用这个方法，需要更新布局约束时可以用`setNeedsUpdateConstraints` 和 `updateConstraintsIfNeeded`。

**`traitCollectionDidChange(_:)`**

程序启动时以及traits改变时会调用此方法，**注意：** traits除了会在设备旋转时改变，还有一些情况下也会发生traits的变化，比如iPad上的多任务分屏时。如果你的UI有跟traits的size-class相关的逻辑，则应该放在这个方法里，比如更新布局约束或添加、移除View。

**`layoutSubviews`**

这个方法从View层次结构中最上层往下传播（跟`updateConstraints`相反），调用的原因包括布局约束的改变，View内容的改变（比如一个Label的text发生了变化），以及`superview`的大小变了。这是一个自动缩放(auto-resizing)后手动调整布局的机会，用自动布局(auto-layout)时别忘了呼叫`super`方法。不要直接调用这个方法，而是通过`setNeedsLayout` 和 `layoutIfNeeded`。

重写这个方法来对自动布局的结果进行微调是没问题的，先呼叫`super`方法，然后改变需要调整的View的布局，最后再呼叫`super`方法。**注意：**任何改变必须只针对View的`subviews`，因为这个方法在View层次结构里是从上往下传播的；别想着`setNeedsUpdateConstraints`，那个方法是从下往上传播的，并且此刻应该已经结束。

## 边缘空白，辅助线和安全区域 (Margins, Guides and Safe Area)

UIKit有一个边缘嵌入(edge insets)的概念，用来保证图形界面的用户友好以及防止程序的View跟系统控件重叠，比如屏幕上方的状态条和导航条，下面的标签条。最近几个版本的iOS更新在这些方面改变了许多，以至于理解其中任何一点都得要理解其他许多方面，官方的文档对每个独立的概念进行了解释，却没有更深入的解释各个概念的关联，当你查阅文档想一探究竟时，往往看到的只是这句话：

> Thank you Mario! But our princess is in another castle!  
> （谢谢你马里奥！但是我们的公主在另一个城堡！）

### `UIEdgeInsets`
一个包含四个边缘edge insets的`struct`结构

### `UILayoutGuide`
有时候在View布局时需要用一些起到占位作用而没有实际内容的View，用`UIView`的问题是，虽然只是为了布局占位，却会实际消耗内存，而`UILayoutGuide`就解决了这个问题，它有跟`UIView`一样的各种anchor，却不会像`UIView`视图那样需要消耗内存和处理性能，并且也不会像`UIView`那样阻挡用户的触屏交互

### `topLayoutGuide` 和 `bottomLayoutGuide` (iOS 11开始淘汰)
iOS 9开始有的两个`UILayoutGuide`，代表屏幕最上方和最下方可能会有的各种条（如状态条，导航条，标签条等），依照这两个Guide来约束布局可以确保你的UI不会被系统的UI组件覆盖

### `safeAreaLayoutGuide`
iOS 11开始有的这个，替代了`topLayoutGuide` 和 `bottomLayoutGuide`

### `safeAreaInsets`
和 `safeAreaLayoutGuide` 相同，但类型是边缘inset值

### `safeAreaInsetsDidChange`
`UIView`的一个方法，当这个View的安全区域(safe area)发生改变时会被呼叫

### `viewSafeAreaInsetsDidChange`
`UIViewController`的一个值，当这个View Controller自身的View的安全区域发生改变时被呼叫

### `additionalSafeAreaInsets`
在系统的安全区域基础上再往里深入额外的Insets

### `layoutMargins`
View的`subviews`和View的`bounds`之外的一个视觉缓冲，如果要遵照`layoutMargins`来设置布局，可以在XCode里点选_Constrain to magins_

### `layoutMarginsGuide`
同样的`layoutMargins`，数据类型为`UILayoutGuide`

### `directionalLayoutMargins`
iOS 11开始有的这个，比`layoutMargins`更好，它考虑到了设备当前的语言区域，因为有些语言文字顺序是从右到左，所以`.leading`和`.trailing`不一定是`.left`和`.right`

### `preservesSuperviewLayoutMargins`
一个subview如果覆盖了它的`superview`的margin，可以将覆盖的margin作为自己的最小margin。例如：`containerView`的`directionalLayoutMargins`最顶上有50的inset，作为它的子View，`childView`顶端跟`containerView`顶端有20点的约束距离（覆盖了30点的margin），如果`childView`的`preservesSuperviewLayoutMargins`为`true`，那么`childView`就会有30点的顶部margin

### `insetsLayoutMarginsFromSafeArea`
默认值为`true`，一个View的有效margin会考虑安全区域。例如：`aView`的顶端有12点margin，而它的顶端跟屏幕顶端的状态条重叠，状态条的高度为20点，那么`aView`的子View`sonView`如果按照`aView`顶部margin来约束的话，`sonView`则会被布局在距离`aView`顶部32点的位置，或者说，实际上`sonView`的顶部距离屏幕上面的状态条会有12点距离。

### `systemMinimumLayoutMargins`
iOS 11增加了这个，`UIViewController`的`systemMinimumLayoutMargins`属性定义了View Controller的`view`的最低Margin，如果你也给这个View指定了一个Margin，那么系统会用两个Margin里最大的Margin作为实际Margin。如果你不想用系统最小Margin，可以设置`viewRespectsSystemMinimumLayoutMargins`。默认情况下View Controller的最小Margin是上下为0，左右两边在小设备上为16，大些的设备上为20。

### `viewRespectsSystemMinimumLayoutMargins`
默认值为`true`，设为`false`时View Controller的`systemMinimumLayoutMargins`会被忽略。

## 特性 / Traits

因为屏幕尺寸各异，布局约束有时候不足以管理界面的布局，因此有了Traits。

> All wise men share one __trait__ in common: the ability to listen.  
> 所有聪明人都有一个共同__特征__：懂得倾听。

UIKit里的Traits定义了针对特定对象（如View和View Controller）的当前环境信息。

- `horizontalSizeClass`，`verticalSizeClass`：当前界面的_大小_，可能的值：
 - `compact`，`regular` 以及 `unspecified`
- `displayScale`：当前的显示屏是否是Retina视网膜显示屏，这个可以用来执行像素相关的逻辑，或者用来选择合适的图片
- `userInterfaceIdiom`：设备的类型，iPad或者iPhone

**注意：** 苹果建议尽量要避免使用`userInterfaceIdiom`。最开始的iPhone或iPad只有固定的单一分辨率，可以针对设备类型来设计界面，可现在各种设备分辨率都不一致，所以思维模式应该改变，要问的问题不应该是当前设备是iPhone还是iPad，而应该是这个屏幕的UI在`.regular`宽和/或`.compact`高的时候如何布局？如果宽和高都是`.compact`时是否应该有些调整？_这不仅仅是程序员容易犯的错误，也是设计师常会犯的错。_

### 时间周期 / Event Cycle

一个典型的设备旋转时，Size Class的改变会从主`window`传递到所有视图层次结构里的View Controller：

1. `willTransitionToTraitCollection:withTransitionCoordinator:` - 告诉相关的View Controller，trait collection即将要发生变化
2. `viewWillTransitionToSize:withTransitionCoordinator:` - 告诉相关的View Controller，View的大小要发生变化
3. `traitCollectionDidChange:` - 告诉相关的View Controller，Trait Collection变化已经完成了

## 图层 / Layers

> Life is like an onion: you peel off layer after layer, then you find there is nothing in it.  
> 人生就像是一个洋葱：你一层一层剥开，却发现里面什么都没有。

不少人认为看东西用的是眼睛，严格地说，眼睛只是一个传导光的工具，光通过眼球传到视网膜上，再被转换成某种视神经可以理解的信号，最后**在大脑中成像**；与此类似，每个`UIView`都有一个相应的`CALayer`，他们的关系正如眼球、视网膜和视神经一样，`UIView`只是它Layer的代理，真正渲染显示的是Layer。

- 如果想用自定义的`CALayer`类作为`UIView`的layer，那么可以继承`UIView`，在子类里重写`layerClass`属性并返回你自己的`CALayer`类型
- View的层次结构实际上是Layer的层次结构：如果`viewA`有一个子View `viewB`，那么`viewB.layer`也是`viewA.layer`的子Layer
- 改变一个View的属性实际上改变的是此View的Layer的属性，例如View的`clipsToBounds`对应的是Layer的`masksToBounds`
- 一个Layer可以有多个子Layer
- `sublayers`里layer的顺序不仅仅是它们在`sublayers`里的先后位置，还跟Layer的`zPosition`有关：相同`zPosition`的子Layer会按照它们在`sublayers`里的位置来渲染，并且，`zPosition`小的Layer比`zPosition`大的Layer先被渲染。
- 用代码创建的Layer，其`frame`和`bounds`都为`CGRect.zeo`（不可见）

**注意：**因为Layer的`zPosition`默认值为0.0，所以默认情况下`sublayers`里的Layer的显示顺序就是它们在`sublayers`数组里的先后顺序，而因为View层次结构等同于Layer层次结构，改变一个Layer的`zPosition`会导致View显示顺序的改变。

一个Layer在其父Layer里的位置由它的`position`和`anchorPoint`决定：

`position`：父Layer坐标系统里的一个点
`anchorPoint`：指定`position`在Layer本身的什么位置，从左上角 (0.0, 0.0) 到右下角 (1.0, 1.0)，默认为 (0.5, 0.5)，意味着Layer的`position`表示的是这个Layer中心点的位置
