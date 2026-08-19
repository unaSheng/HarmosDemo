import { fetchUserInfoList } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';
import { ListAttr, ListView, RefreshController } from '@abner/refresh';

@ComponentV2
export struct UserListPage {
  @Param appNavStack: NavPathStack = new NavPathStack();
  @Param refreshKey: number = 0;
  @Local users: UserInfo[] = [];
  @Local isEmpty: boolean = false;
  @Local isFirstLoading: boolean = true;
  private refreshController: RefreshController = new RefreshController();

  aboutToAppear(): void {
    this.loadUsers(false);
  }

  @Monitor('refreshKey')
  onRefreshKeyChange(): void {
    this.loadUsers(false);
  }

  private handleRefresh(): void {
    this.loadUsers(true);
  }

  private async loadUsers(fromPullRefresh: boolean): Promise<void> {
    const list = await fetchUserInfoList();
    this.users = list;
    this.isEmpty = list.length === 0;
    this.isFirstLoading = false;
    if (fromPullRefresh) {
      this.refreshController.finishRefresh();
    }
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

  @Builder
  userItemLayout(item: Object, index: number) {
    Row() {
      this.avatarBuilder(item as UserInfo)

      Column() {
        Row() {
          Text((item as UserInfo).nickname)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)

          Text(`${(item as UserInfo).age}岁`)
            .fontSize(13)
            .fontColor('#999999')
        }
        .width('100%')

        if ((item as UserInfo).signature.length > 0) {
          Text((item as UserInfo).signature)
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
    .onClick(() => {
      this.appNavStack.pushPath({
        name: 'UserDetailPage',
        param: item as UserInfo,
        onPop: () => {
          this.loadUsers(false);
        },
      });
    })
  }

  @Builder
  loadingLayoutBuilder() {
    Column() {
      Text($r('app.string.loading'))
        .fontSize(14)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  emptyLayoutBuilder() {
    Column() {
      Text($r('app.string.user_list_empty'))
        .fontSize(14)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    ListView({
      items: this.users,
      itemLayout: (item: Object, index: number) => {
        this.userItemLayout(item, index);
      },
      controller: this.refreshController,
      onRefresh: () => {
        this.handleRefresh();
      },
      enableLoadMore: false,
      showLoadingLayout: this.isFirstLoading,
      loadingLayout: () => {
        this.loadingLayoutBuilder();
      },
      showEmptyLayout: !this.isFirstLoading && this.isEmpty,
      emptyLayout: () => {
        this.emptyLayoutBuilder();
      },
      listAttribute: (attribute: ListAttr) => {
        attribute.divider = { strokeWidth: 1, color: '#EEEEEE' };
      },
    })
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
  }
}
