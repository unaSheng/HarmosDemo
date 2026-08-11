import { Info } from '../model/Info';

@Entry
@ComponentV2
struct Detail {
  @Local params?: Info

  aboutToAppear(): void {
    const str: string = JSON.stringify(this.getUIContext().getRouter().getParams());
    this.params = Info.fromJSON(str)
  }

  build() {
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
}