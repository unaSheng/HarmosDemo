import { Info } from '../model/Info';
import { appNavStack } from '../common/AppNavStack';

@Builder
export function HorizontalListPageBuilder() {
  HorizontalListPage();
}

@ComponentV2
export struct HorizontalListPage {
  private readonly items: string[] = ['列表页 1', '列表页 2', '列表页 3', '列表页 4'];
  @Local info: Info = new Info();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            Button($r('app.string.back'))
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor('#007DFF')
              .onClick(() => {
                appNavStack.pop();
              })

            Text($r('app.string.horizontal_list_title'))
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)

            Blank()
              .width(48)
          }
          .width('100%')
          .padding({
            left: 12,
            right: 12,
            top: 12,
            bottom: 12
          })

          Text(`name: ${this.info.name}, age: ${this.info.age}`)
            .fontSize(16)
            .margin({ bottom: 8 })

          Button('反序列化')
            .margin({ bottom: 8 })
            .onClick(() => {
              appNavStack.pushPath({ name: 'DetailPage', param: this.info });
            })

          Button('age + 1（验证 @Trace 响应式）')
            .margin({ bottom: 16 })
            .onClick(() => {
              this.info.age++;
            })

          Swiper() {
            ForEach(this.items, (item: string, index: number) => {
              Column() {
                Text(item)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)

                Text(`第 ${index + 1} 页 / 共 ${this.items.length} 页`)
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ top: 12 })
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .backgroundColor(index % 2 === 0 ? '#F5F7FA' : '#EEF2F7')
            }, (item: string, index: number) => `${index}_${item}`)
          }
          .width('100%')
          .height(320)
          .indicator(true)
          .loop(false)
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
    }
    .hideTitleBar(true)
  }
}
