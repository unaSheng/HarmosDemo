import { appNavStack } from '../common/AppNavStack';
import { openWeChat } from '../common/WeChatLauncher';

@Component
export struct MeTabContent {
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
          appNavStack.pushPath({ name: 'UserListPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
