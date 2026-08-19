import { DialogAction, DialogHelper } from '@pura/harmony-dialog';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { isNetworkAvailable } from '../common/NetworkHelper';
import { deleteUserInfo, updateUserInfo } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';

const USER_DETAIL_SAVE_MENU_SYMBOL: Resource = $r('sys.symbol.checkmark');

@ComponentV2
export struct UserDetailPage {
  private pathStack?: NavPathStack;
  @Local user: UserInfo = new UserInfo();
  @Local nickname: string = '';
  @Local ageText: string = '';
  @Local signature: string = '';
  @Local isSaving: boolean = false;
  @Local isDeleting: boolean = false;
  private loadingDialogId: string = '';

  private fillForm(user: UserInfo): void {
    this.user = user;
    this.nickname = user.nickname;
    this.ageText = user.age > 0 ? user.age.toString() : '';
    this.signature = user.signature;
  }

  private showSaveLoading(content: string): void {
    this.loadingDialogId = DialogHelper.showLoadingDialog({
      content,
      autoCancel: false,
      backCancel: false,
    });
  }

  private hideSaveLoading(): void {
    if (this.loadingDialogId.length > 0) {
      DialogHelper.closeDialog(this.loadingDialogId);
      this.loadingDialogId = '';
    }
  }

  private showSaveResultToast(success: boolean, message: string | Resource): void {
    if (success) {
      DialogHelper.showToastTip({
        message,
        imageRes: $r('sys.media.ohos_ic_public_ok'),
      });
    } else {
      DialogHelper.showToastTip({
        message,
        imageRes: $r('sys.media.ohos_ic_public_cancel'),
      });
    }
  }

  private async handleSave(): Promise<void> {
    if (this.isSaving) {
      return;
    }
    if (this.nickname.trim().length === 0) {
      DialogHelper.showToast('请输入昵称');
      return;
    }
    if (!isNetworkAvailable()) {
      DialogHelper.showToast('网络不可用，请检查 WiFi 或蜂窝数据');
      return;
    }
    if (this.user.id <= 0) {
      DialogHelper.showToast('用户信息无效，请返回重试');
      return;
    }

    this.isSaving = true;
    this.showSaveLoading('保存中...');

    const parsedAge = Number.parseInt(this.ageText, 10);
    const saveUser = new UserInfo();
    saveUser.id = this.user.id;
    saveUser.avatarUrl = this.user.avatarUrl;
    saveUser.nickname = this.nickname.trim();
    saveUser.age = Number.isNaN(parsedAge) ? 0 : parsedAge;
    saveUser.signature = this.signature.trim();

    const result = await updateUserInfo(saveUser);
    this.hideSaveLoading();
    this.isSaving = false;

    if (!result) {
      this.showSaveResultToast(false, '保存失败，请检查网络');
      return;
    }

    this.showSaveResultToast(true, '保存成功');
    setTimeout(() => {
      this.pathStack?.pop(result);
    }, 800);
  }

  private handleDelete(): void {
    if (this.isSaving || this.isDeleting) {
      return;
    }
    DialogHelper.showConfirmDialog({
      content: $r('app.string.delete_user_confirm'),
      onAction: (action: number) => {
        if (action === DialogAction.SURE) {
          this.performDelete();
        }
      },
      checkTips: '',
      onCheckedChange: undefined
    });
  }

  private async performDelete(): Promise<void> {
    if (this.isDeleting || this.user.id <= 0) {
      return;
    }
    if (!isNetworkAvailable()) {
      DialogHelper.showToast('网络不可用，请检查 WiFi 或蜂窝数据');
      return;
    }

    this.isDeleting = true;
    this.showSaveLoading('删除中...');

    const success = await deleteUserInfo(this.user.id);
    this.hideSaveLoading();
    this.isDeleting = false;

    if (!success) {
      this.showSaveResultToast(false, $r('app.string.delete_failed'));
      return;
    }

    this.showSaveResultToast(true, $r('app.string.delete_success'));
    setTimeout(() => {
      this.pathStack?.pop();
    }, 800);
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
        Text(this.nickname.length > 0 ? this.nickname.substring(0, 1) : '?')
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

  @Builder
  centerTitleBuilder() {
    Row() {
      Text($r('app.string.user_detail_title'))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
    }
    .position({ x: 0 })
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .hitTestBehavior(HitTestMode.None)
  }

  build() {
    NavDestination() {
      Column() {

        this.avatarBuilder()

        Column() {
          Row() {
            Text($r('app.string.nickname'))
              .width(50)
              .fontSize(15)
              .fontColor('#999999')
            TextInput({ placeholder: $r('app.string.nickname_placeholder'), text: this.nickname })
              .layoutWeight(1)
              .onChange((value: string) => {
                this.nickname = value;
              })
          }
          .width('100%')
          .padding({ top: 14, bottom: 14 })

          Divider().color('#EEEEEE')

          Row() {
            Text($r('app.string.age'))
              .width(50)
              .fontSize(15)
              .fontColor('#999999')
            TextInput({
              placeholder: $r('app.string.age_placeholder'),
              text: this.ageText,
            })
              .layoutWeight(1)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.ageText = value;
              })
          }
          .width('100%')
          .padding({ top: 14, bottom: 14 })

          Divider().color('#EEEEEE')

          Row() {
            Text($r('app.string.signature'))
              .width(50)
              .fontSize(15)
              .fontColor('#999999')
              .alignSelf(ItemAlign.Start)
              .margin({ top: 8 })
            TextArea({
              placeholder: $r('app.string.signature_placeholder'),
              text: this.signature,
            })
              .layoutWeight(1)
              .height(80)
              .onChange((value: string) => {
                this.signature = value;
              })
          }
          .width('100%')
          .padding({ top: 14, bottom: 14 })
          .alignItems(VerticalAlign.Top)
        }
        .width('100%')
        .margin({ top: 20 })
        .padding({ left: 16, right: 16 })
        .backgroundColor('#FAFAFA')
        .borderRadius(12)

        Button($r('app.string.delete_user'))
          .width('100%')
          .height(44)
          .margin({ top: 24 })
          .backgroundColor('#FFF0F0')
          .fontColor('#FF3B30')
          .enabled(!this.isSaving && !this.isDeleting)
          .onClick(() => {
            this.handleDelete();
          })
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 8,
        bottom: 24,
      })
      .alignItems(HorizontalAlign.Center)

      .width('100%')
      .backgroundColor('#FFFFFF')
    }
    .title(this.centerTitleBuilder())
    .menus([
      {
        value: 'func',
        symbolIcon: new SymbolGlyphModifier(USER_DETAIL_SAVE_MENU_SYMBOL),
        action: () => {
          this.handleSave();
        },
      },
    ])
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
      const param = ctx.pathInfo.param as UserInfo;
      if (param) {
        this.fillForm(UserInfo.fromPlain(param as ESObject));
      }
    })
  }
}
