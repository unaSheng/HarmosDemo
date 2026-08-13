import { Info } from '../model/Info';

@Builder
export function DetailPageBuilder() {
  DetailPageBuilder();
}

@ComponentV2
export struct DetailPage {
  @Local params?: Info;

  build() {
    NavDestination() {
      Column() {
        Text(`Detail Page: ${this.params?.name} ${this.params?.age}`)
          .fontSize(20)
          .margin(10)
          .onClick(() => {
            if (this.params) {
              this.params.age = 85;
            }
          })
      }
      .width('100%')
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      const param = ctx.pathInfo.param as Info
      const stack = ctx.pathStack
      if (param) {
        this.params = param;
      }
    })
  }
}
