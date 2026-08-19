
@Component
export struct MeTabContent {
  appNavStack: NavPathStack = new NavPathStack();

  build() {
    Scroll() {
      Column() {
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

        Button('调试页')
          .onClick(() => {
            this.appNavStack.pushPath({name: 'TestPage'})
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
