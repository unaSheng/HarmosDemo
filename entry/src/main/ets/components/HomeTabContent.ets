import { appNavStack } from '../common/AppNavStack';

@Component
export struct HomeTabContent {
  build() {
    Column() {
      Text($r('app.string.home_title'))
        .fontSize(24)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 24 })

      Button($r('app.string.open_horizontal_list'))
        .onClick(() => {
          appNavStack.pushPath({ name: 'HorizontalListPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
