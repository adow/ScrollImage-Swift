ScrollImage-Swift
=================

UIScrollView + UIImageView + AutoLayout by Swift

经常有这样的查看图片的方式，比如weibo之类的，点击一个小图片后看到更大的图片，在这个view里面可以放大，缩小，移动这个图片。

其实原理很简单，即使不用各种手势，只要把 UIImageView 放在一个  UIScrollView 里面就可以了，使用 UIScrollView 的 zoomScale 来控制图片的放大缩小，而通过修改 UIScrollView 的 contentSize 就可以实现图片的移动了。

最重要的是一个更新 UIImageView 尺寸和位置，以及更新 UIScrollView contentSize 的方法。

但是如果在 AutoLayout 下，由于没有绝对的位置了，所有的位置要使用约束来限制，所以变成了更新约束位置。当图片放大时，要更新图片在 UIScrollView 中的 UIImageView 的约束；