ScrollImage-Swift
=================

UIScrollView + UIImageView + AutoLayout by Swift

经常有这样的查看图片的方式，比如weibo之类的，点击一个小图片后看到更大的图片，在这个view里面可以放大，缩小，移动这个图片。

其实原理很简单，即使不用各种手势，只要把 UIImageView 放在一个  UIScrollView 里面就可以了，使用 UIScrollView 的 zoomScale 来控制图片的放大缩小，而通过修改 UIScrollView 的 contentSize 就可以实现图片的移动了。

最重要的是一个更新 UIImageView 尺寸和位置，以及更新 UIScrollView contentSize 的方法。

但是如果在 AutoLayout 下，由于没有绝对的位置了，所有的位置要使用约束来限制，所以变成了更新约束位置。当图片放大时，要更新图片在 UIScrollView 中的 UIImageView 的约束；

## setupImageConstraint

在开始的时候，由于 imageView 中的图片尺寸可能是各种各样的，长宽比例也各不一样，所以开始时需要依据当前的图片尺寸来初始化约束条件。使图片的长的一边正好撑满 UIScrollView 内容，以此来更新各个约束条件，同时也得更新 UIImageView 的长和宽的尺寸。

## updateConstraints

在通过 zoomScale 缩放后，需要来更新各个约束条件。

## Reference
* [ScrollView 与 Autolayout](http://nonomori.farbox.com/post/scrollview-yu-autolayout)