import { fetchUserInfoPage } from '../common/SupabaseUserService';
import { isUserDetailDeleteResult, UserDetailDeleteResult, UserInfo } from '../model/UserInfo';
import { ListAttr, ListView, LoadMoreFooterAttr, RefreshController } from '@abner/refresh';

const PAGE_SIZE: number = 10;

@ComponentV2
export struct UserListPage {
  @Param appNavStack: NavPathStack = new NavPathStack();
  @Param refreshKey: number = 0;
  @Local users: UserInfo[] = [];
  @Local isEmpty: boolean = false;
  @Local isFirstLoading: boolean = true;
  @Local hasMore: boolean = true;
  @Local isLoadingMore: boolean = false;
  private refreshController: RefreshController = new RefreshController();

  aboutToAppear(): void {
    this.loadFirstPage(false);
  }

  @Monitor('refreshKey')
  onRefreshKeyChange(): void {
    this.loadFirstPage(false);
  }

  private handleRefresh(): void {
    this.loadFirstPage(true);
  }

  private handleLoadMore(): void {
    this.loadMorePage();
  }

  private updateLoadMoreFooter(): void {
    if (this.isFirstLoading || this.isEmpty) {
      return;
    }
    this.refreshController.finishLoadMore(!this.hasMore);
  }

  private resetPaginationState(): void {
    this.hasMore = true;
    this.isLoadingMore = false;
    this.refreshController.finishLoadMore();
  }

  private async loadFirstPage(fromPullRefresh: boolean): Promise<void> {
    this.resetPaginationState();
    const result = await fetchUserInfoPage(0, PAGE_SIZE);
    if (!result) {
      this.isFirstLoading = false;
      if (fromPullRefresh) {
        this.refreshController.finishRefresh();
      }
      return;
    }

    this.users = result.list;
    this.hasMore = result.hasMore;
    this.isEmpty = result.list.length === 0;
    this.isFirstLoading = false;

    if (fromPullRefresh) {
      this.refreshController.finishRefresh();
    }
    this.updateLoadMoreFooter();
  }

  private async loadMorePage(): Promise<void> {
    if (this.isLoadingMore) {
      return;
    }
    if (!this.hasMore) {
      this.updateLoadMoreFooter();
      return;
    }

    this.isLoadingMore = true;
    const result = await fetchUserInfoPage(this.users.length, PAGE_SIZE);
    this.isLoadingMore = false;

    if (!result) {
      this.refreshController.finishLoadMore();
      return;
    }

    const mergedUsers: UserInfo[] = [];
    this.users.forEach((user: UserInfo) => {
      mergedUsers.push(user);
    });
    result.list.forEach((user: UserInfo) => {
      mergedUsers.push(user);
    });
    this.users = mergedUsers;
    this.hasMore = result.hasMore;
    this.refreshController.finishLoadMore(!this.hasMore);
  }

  private updateUserInList(updatedUser: UserInfo): void {
    const nextUsers: UserInfo[] = [];
    let found = false;
    this.users.forEach((user: UserInfo) => {
      if (user.id === updatedUser.id) {
        nextUsers.push(updatedUser);
        found = true;
      } else {
        nextUsers.push(user);
      }
    });
    if (found) {
      this.users = nextUsers;
    }
  }

  private removeUserFromList(userId: number): void {
    const nextUsers: UserInfo[] = [];
    this.users.forEach((user: UserInfo) => {
      if (user.id !== userId) {
        nextUsers.push(user);
      }
    });
    this.users = nextUsers;
    this.isEmpty = this.users.length === 0;
  }

  private handleUserDetailPop(popInfo: PopInfo): void {
    if (!popInfo.result) {
      return;
    }
    const popResult: Object = popInfo.result;
    if (isUserDetailDeleteResult(popResult)) {
      const deleteResult = popResult as UserDetailDeleteResult;
      this.removeUserFromList(deleteResult.userId);
      return;
    }
    const updatedUser = UserInfo.fromPlain(popResult as ESObject);
    if (updatedUser.id > 0) {
      this.updateUserInList(updatedUser);
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
        onPop: (popInfo: PopInfo) => {
          this.handleUserDetailPop(popInfo);
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
      onLoadMore: () => {
        this.handleLoadMore();
      },
      loadMoreFooterAttribute: (attribute: LoadMoreFooterAttr) => {
        attribute.footerPullingText = $r('app.string.list_load_more');
        attribute.footerReleaseText = $r('app.string.list_load_more');
        attribute.footerLoadingText = $r('app.string.loading');
        attribute.footerNothingText = $r('app.string.list_no_more');
        attribute.fontColor = '#999999';
        attribute.fontSize = 14;
      },
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
