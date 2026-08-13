import { openWeChat } from '../common/WeChatLauncher';

@Component
export struct MeTabContent {
  // 由 Index 传入，与 Navigation(this.appNavStack) 为同一实例
  appNavStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      Text($r('app.string.me_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 24 })

      Button($r('app.string.open_wechat'))
        .margin({ bottom: 12 })
        .onClick(() => {
          openWeChat(this.getUIContext());
        })

      Button($r('app.string.open_user_list'))
        .onClick(() => {
          this.appNavStack.pushPath({ name: 'UserListPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
