import { openWeChat } from '../common/WeChatLauncher';

@Component
export struct MeTabContent {
  appNavStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      Button($r('app.string.open_wechat'))
        .margin({ bottom: 12 })
        .onClick(() => {
          openWeChat(this.getUIContext());
        })

      Button($r('app.string.open_user_list'))
        .margin({ bottom: 12 })
        .onClick(() => {
          this.appNavStack.pushPath({ name: 'UserListPage' });
        })

      Button($r('app.string.open_horizontal_list'))
        .margin({ bottom: 12 })
        .onClick(() => {
          this.appNavStack.pushPath({ name: 'HorizontalListPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
