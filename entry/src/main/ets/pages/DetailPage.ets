import { Info } from '../model/Info';

@Builder
export function DetailPageBuilder() {
  DetailPage();
}

@ComponentV2
export struct DetailPage {
  @Local params?: Info;
  private pathStack?: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Column() {
          Text($r('app.string.detail_title'))
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 16 })

          Text(`name: ${this.params?.name ?? ''}`)
            .fontSize(16)
            .margin({ bottom: 8 })

          Text(`age: ${this.params?.age ?? 0}`)
            .fontSize(16)
            .margin({ bottom: 16 })
            .onClick(() => {
              if (this.params) {
                this.params.age = 85;
              }
            })

          Button($r('app.string.close'))
            .width('100%')
            .onClick(() => {
              this.pathStack?.pop();
            })
        }
        .width('80%')
        .padding(24)
        .backgroundColor(Color.White)
        .borderRadius(16)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#66000000')
    }
    .mode(NavDestinationMode.DIALOG)
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
      const param = ctx.pathInfo.param as Info;
      if (param) {
        this.params = param;
      }
    })
  }
}
