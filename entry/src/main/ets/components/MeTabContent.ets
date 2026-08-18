
@Component
export struct MeTabContent {
  appNavStack: NavPathStack = new NavPathStack();

  build() {
    Scroll() {
      Column() {
        Text($r('app.string.me_title'))
          .fontSize(24)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 16 })

        Button($r('app.string.edit_user_info'))
          .margin({ bottom: 12 })
          .onClick(() => {
            this.appNavStack.pushPath({ name: 'EditUserInfoPage' });
          })

        Button($r('app.string.open_user_list'))
          .margin({ bottom: 12 })
          .onClick(() => {
            this.appNavStack.pushPath({ name: 'UserListPage' });
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 24, bottom: 24 })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
