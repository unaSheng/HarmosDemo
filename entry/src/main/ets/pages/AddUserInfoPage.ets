import { display } from '@kit.ArkUI';
import { DialogHelper } from '@pura/harmony-dialog';
import { isNetworkAvailable } from '../common/NetworkHelper';
import { pickImageUri, uploadImageToSupabase } from '../common/SupabaseStorageService';
import { insertUserInfo } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';

const PANEL_HEIGHT_RATIO: number = 0.58;
const PANEL_SHOW_DURATION: number = 300;
const PANEL_HIDE_DURATION: number = 250;
const PANEL_TOP_RADIUS: number = 20;
const MASK_TARGET_OPACITY: number = 1;
const DISMISS_DRAG_RATIO: number = 0.25;
const PANEL_SNAP_BACK_DURATION: number = 200;

@ComponentV2
export struct AddUserInfoPage {
  private pathStack?: NavPathStack;
  @Local panelTranslateY: number = 0;
  @Local maskOpacity: number = 0;
  @Local avatarUrl: string = '';
  @Local avatarPreviewUri: string = '';
  @Local nickname: string = '';
  @Local ageText: string = '';
  @Local signature: string = '';
  @Local saveStatus: string = '';
  @Local isSaving: boolean = false;
  private loadingDialogId: string = '';


  private async handlePickAvatar(): Promise<void> {
    const uri = await pickImageUri();
    if (!uri) {
      return;
    }
    this.avatarPreviewUri = uri;
    this.saveStatus = '';
  }

  private showSaveLoading(content: string): void {
    this.loadingDialogId = DialogHelper.showLoadingDialog({
      content,
      autoCancel: false,
      backCancel: false,
    });
  }

  private updateSaveLoading(content: string): void {
    if (this.loadingDialogId.length > 0) {
      DialogHelper.updateLoading(this.loadingDialogId, content);
    }
  }

  private hideSaveLoading(): void {
    if (this.loadingDialogId.length > 0) {
      DialogHelper.closeDialog(this.loadingDialogId);
      this.loadingDialogId = '';
    }
  }

  private showSaveResultToast(success: boolean, message: string): void {
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
      this.saveStatus = '请输入昵称';
      return;
    }
    if (!isNetworkAvailable()) {
      this.saveStatus = '网络不可用，请检查 WiFi 或蜂窝数据';
      return;
    }

    this.isSaving = true;
    this.saveStatus = '';
    this.showSaveLoading('保存中...');

    let finalAvatarUrl = this.avatarUrl;
    if (this.avatarPreviewUri.length > 0) {
      this.updateSaveLoading('上传头像中...');
      const publicUrl = await uploadImageToSupabase(this.avatarPreviewUri);
      if (!publicUrl) {
        this.hideSaveLoading();
        this.isSaving = false;
        this.showSaveResultToast(false, '头像上传失败，请检查网络');
        return;
      }
      finalAvatarUrl = publicUrl;
    }

    const parsedAge = Number.parseInt(this.ageText, 10);
    const user = new UserInfo();
    user.avatarUrl = finalAvatarUrl;
    user.nickname = this.nickname.trim();
    user.age = Number.isNaN(parsedAge) ? 0 : parsedAge;
    user.signature = this.signature.trim();

    this.updateSaveLoading('保存中...');

    let result: UserInfo | undefined = undefined;
    result = await insertUserInfo(user);

    this.hideSaveLoading();
    this.isSaving = false;

    if (!result) {
      this.showSaveResultToast(false, '保存失败，请检查网络');
      return;
    }

    this.showSaveResultToast(true, '保存成功');
    setTimeout(() => {
      this.closePage(result);
    }, 800);
  }

  private getPanelOffset(): number {
    return px2vp(display.getDefaultDisplaySync().height) * PANEL_HEIGHT_RATIO;
  }

  private showPanel(): void {
    animateTo({
      duration: PANEL_SHOW_DURATION,
      curve: Curve.EaseOut,
    }, () => {
      this.maskOpacity = MASK_TARGET_OPACITY;
      this.panelTranslateY = 0;
    });
  }

  private closePage(result?: UserInfo): void {
    animateTo({
      duration: PANEL_HIDE_DURATION,
      curve: Curve.EaseIn,
      onFinish: () => {
        if (result) {
          this.pathStack?.pop(result);
        } else {
          this.pathStack?.pop();
        }
      },
    }, () => {
      this.maskOpacity = 0;
      this.panelTranslateY = this.getPanelOffset();
    });
  }

  private updatePanelDrag(offsetY: number): void {
    const panelHeight = this.getPanelOffset();
    const dragOffset = Math.max(0, Math.min(offsetY, panelHeight));
    this.panelTranslateY = dragOffset;
    const progress = 1 - dragOffset / panelHeight;
    this.maskOpacity = MASK_TARGET_OPACITY * progress;
  }

  private handlePanelPanUpdate(event: GestureEvent): void {
    if (this.isSaving) {
      return;
    }
    this.updatePanelDrag(event.offsetY);
  }

  private handlePanelPanEnd(): void {
    if (this.isSaving) {
      return;
    }
    const dismissThreshold = this.getPanelOffset() * DISMISS_DRAG_RATIO;
    if (this.panelTranslateY >= dismissThreshold) {
      this.closePage();
      return;
    }
    animateTo({
      duration: PANEL_SNAP_BACK_DURATION,
      curve: Curve.EaseOut,
    }, () => {
      this.panelTranslateY = 0;
      this.maskOpacity = MASK_TARGET_OPACITY;
    });
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#30000000')
          .opacity(this.maskOpacity)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
          .onClick(() => {
            this.closePage();
          })

        Column() {
          Column() {
            Row()
              .width(40)
              .height(4)
              .backgroundColor('#DDDDDD')
              .borderRadius(2)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 5, bottom: 16 })

          Column() {
            if (this.avatarPreviewUri.length > 0) {
              Image(this.avatarPreviewUri)
                .width(72)
                .height(72)
                .borderRadius(36)
                .objectFit(ImageFit.Cover)
            } else if (this.avatarUrl.length > 0) {
              Image(this.avatarUrl)
                .width(72)
                .height(72)
                .borderRadius(36)
                .objectFit(ImageFit.Cover)
            } else {
              Column() {
                Text('+')
                  .fontSize(28)
                  .fontColor('#999999')
              }
              .width(72)
              .height(72)
              .borderRadius(36)
              .backgroundColor('#F5F5F5')
              .justifyContent(FlexAlign.Center)
            }

            Text($r('app.string.add_avatar'))
              .fontSize(13)
              .fontColor('#007DFF')
              .margin({ top: 8 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ bottom: 20 })
          .onClick(() => {
            this.handlePickAvatar();
          })

          Row() {
            Text($r('app.string.nickname'))
              .width(56)
              .fontSize(15)
            TextInput({ placeholder: $r('app.string.nickname_placeholder'), text: this.nickname })
              .layoutWeight(1)
              .onChange((value: string) => {
                this.nickname = value;
              })
          }
          .width('100%')
          .margin({ bottom: 12 })

          Row() {
            Text($r('app.string.age'))
              .width(56)
              .fontSize(15)
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
          .margin({ bottom: 12 })

          Row() {
            Text($r('app.string.signature'))
              .width(56)
              .fontSize(15)
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
          .alignItems(VerticalAlign.Top)
          .margin({ bottom: 12 })

          if (this.saveStatus.length > 0) {
            Text(this.saveStatus)
              .fontSize(12)
              .fontColor('#666666')
              .width('100%')
              .margin({ bottom: 8 })
          }

          Blank()

          Row() {
            Button($r('app.string.cancel'))
              .layoutWeight(1)
              .backgroundColor('#F0F0F0')
              .fontColor('#333333')
              .margin({ right: 8 })
              .enabled(!this.isSaving)
              .onClick(() => {
                this.closePage();
              })

            Button($r('app.string.save'))
              .layoutWeight(1)
              .enabled(!this.isSaving)
              .onClick(() => {
                this.handleSave();
              })
          }
          .width('100%')
        }
        .width('100%')
        .height(`${PANEL_HEIGHT_RATIO * 100}%`)
        .padding({ left: 16, right: 16, bottom: 24 })
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: PANEL_TOP_RADIUS, topRight: PANEL_TOP_RADIUS })
        .clip(true)
        .translate({ y: this.panelTranslateY })
        .gesture(
          PanGesture({ direction: PanDirection.Vertical, distance: 8 })
            .onActionUpdate((event: GestureEvent) => {
              this.handlePanelPanUpdate(event);
            })
            .onActionEnd(() => {
              this.handlePanelPanEnd();
            })
        )
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    }
    .mode(NavDestinationMode.DIALOG)
    .systemTransition(NavigationSystemTransitionType.NONE)
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
      this.panelTranslateY = this.getPanelOffset();
      this.maskOpacity = 0;
    })
    .onShown(() => {
      this.showPanel();
    })
  }
}
