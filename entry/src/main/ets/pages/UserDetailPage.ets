import { UserInfo } from '../model/UserInfo';

@Builder
export function UserDetailPageBuilder() {
  UserDetailPage();
}

@Component
export struct UserDetailPage {
  private pathStack?: NavPathStack;
  @State user: UserInfo = new UserInfo();

  private openEditPage(): void {
    this.pathStack?.pushPath({
      name: 'EditUserInfoPage',
      param: this.user,
      onPop: (popInfo: PopInfo) => {
        const updatedUser = popInfo.result as UserInfo;
        if (updatedUser) {
          this.user = updatedUser;
        }
      },
    });
  }

  @Builder
  avatarBuilder() {
    if (this.user.avatarUrl.length > 0) {
      Image(this.user.avatarUrl)
        .width(96)
        .height(96)
        .borderRadius(48)
        .objectFit(ImageFit.Cover)
    } else {
      Column() {
        Text(this.user.nickname.length > 0 ? this.user.nickname.substring(0, 1) : '?')
          .fontSize(32)
          .fontColor('#FFFFFF')
      }
      .width(96)
      .height(96)
      .borderRadius(48)
      .backgroundColor('#007DFF')
      .justifyContent(FlexAlign.Center)
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button($r('app.string.back'))
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .fontColor('#007DFF')
            .onClick(() => {
              this.pathStack?.pop();
            })

          Text($r('app.string.user_detail_title'))
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Button($r('app.string.edit'))
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .fontColor('#007DFF')
            .fontSize(14)
            .onClick(() => {
              this.openEditPage();
            })
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 12, bottom: 12 })

        Scroll() {
          Column() {
            this.avatarBuilder()

            Text(this.user.nickname)
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 16, bottom: 24 })

            Column() {
              Row() {
                Text($r('app.string.nickname'))
                  .width(72)
                  .fontSize(15)
                  .fontColor('#999999')
                Text(this.user.nickname)
                  .fontSize(15)
                  .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 14, bottom: 14 })

              Divider().color('#EEEEEE')

              Row() {
                Text($r('app.string.age'))
                  .width(72)
                  .fontSize(15)
                  .fontColor('#999999')
                Text(`${this.user.age}岁`)
                  .fontSize(15)
                  .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 14, bottom: 14 })

              Divider().color('#EEEEEE')

              Row() {
                Text($r('app.string.signature'))
                  .width(72)
                  .fontSize(15)
                  .fontColor('#999999')
                  .alignSelf(ItemAlign.Start)
                if (this.user.signature.length > 0) {
                  Text(this.user.signature)
                    .fontSize(15)
                    .layoutWeight(1)
                } else {
                  Text($r('app.string.no_signature'))
                    .fontSize(15)
                    .fontColor('#999999')
                    .layoutWeight(1)
                }
              }
              .width('100%')
              .padding({ top: 14, bottom: 14 })
              .alignItems(VerticalAlign.Top)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .backgroundColor('#FAFAFA')
            .borderRadius(12)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 24 })
          .alignItems(HorizontalAlign.Center)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
      const param = ctx.pathInfo.param as UserInfo;
      if (param) {
        this.user = param;
      }
    })
  }
}
