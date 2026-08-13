
@Component
export struct HomeTabContent {
  // 由 Index 传入，与 Navigation(this.appNavStack) 为同一实例
  appNavStack: NavPathStack = new NavPathStack();
  build() {
    Column() {
      Text($r('app.string.home_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 24 })

      Button($r('app.string.open_horizontal_list'))
        .onClick(() => {
          this.appNavStack.pushPath({ name: 'HorizontalListPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
