import router from '@ohos.router';

@Entry
@Component
struct HorizontalListPage {
  private readonly items: string[] = ['列表页 1', '列表页 2', '列表页 3', '列表页 4'];

  build() {
    Column() {
      Row() {
        Button($r('app.string.back'))
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .fontColor('#007DFF')
          .onClick(() => {
            router.back();
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
      .padding({ left: 12, right: 12, top: 12, bottom: 12 })

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
      .layoutWeight(1)
      .indicator(true)
      .loop(false)
    }
    .width('100%')
    .height('100%')
  }
}
