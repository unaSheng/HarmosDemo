import { fetchUserInfoList } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';

@Builder
export function UserListPageBuilder() {
  UserListPage();
}

@Component
export struct UserListPage {
  appNavStack: NavPathStack = new NavPathStack();
  @State users: UserInfo[] = [];
  @State isLoading: boolean = true;
  @State isEmpty: boolean = false;

  private async loadUsers(): Promise<void> {
    this.isLoading = true;
    this.isEmpty = false;
    const list = await fetchUserInfoList();
    this.users = list;
    this.isLoading = false;
    this.isEmpty = list.length === 0;
  }

  @Builder
  avatarBuilder(user: UserInfo) {
    if (user.avatarUrl.length > 0) {
      Image(user.avatarUrl)
        .width(48)
        .height(48)
        .borderRadius(24)
        .objectFit(ImageFit.Cover)
    } else {
      Column() {
        Text(user.nickname.length > 0 ? user.nickname.substring(0, 1) : '?')
          .fontSize(18)
          .fontColor('#FFFFFF')
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .backgroundColor('#007DFF')
      .justifyContent(FlexAlign.Center)
    }
  }

  build() {
    NavDestination() {
      Column() {
        if (this.isLoading) {
          Text($r('app.string.loading'))
            .fontSize(14)
            .fontColor('#666666')
            .padding(16)
        } else if (this.isEmpty) {
          Text($r('app.string.user_list_empty'))
            .fontSize(14)
            .fontColor('#666666')
            .padding(16)
        }

        List() {
          ForEach(this.users, (user: UserInfo) => {
            ListItem() {
              Row() {
                this.avatarBuilder(user)

                Column() {
                  Row() {
                    Text(user.nickname)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                      .layoutWeight(1)

                    Text(`${user.age}岁`)
                      .fontSize(13)
                      .fontColor('#999999')
                  }
                  .width('100%')

                  if (user.signature.length > 0) {
                    Text(user.signature)
                      .fontSize(13)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  } else {
                    Text($r('app.string.no_signature'))
                      .fontSize(13)
                      .fontColor('#999999')
                      .margin({ top: 4 })
                  }
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
              }
              .width('100%')
              .padding({
                left: 16,
                right: 16,
                top: 14,
                bottom: 14,
              })
            }
            .onClick(() => {
              this.appNavStack.pushPath({ name: 'UserDetailPage', param: user });
            })
          }, (user: UserInfo) => user.id.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EEEEEE' })
      }
      .width('100%')
      .height('100%')
    }
    .title($r('app.string.user_list_title'))
    .onReady((ctx: NavDestinationContext) => {
      this.appNavStack = ctx.pathStack;
    })
    .onShown(() => {
      this.loadUsers();
    })
  }
}
