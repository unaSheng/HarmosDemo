import { display } from '@kit.ArkUI';
import { isNetworkAvailable } from '../common/NetworkHelper';
import { pickImageUri, uploadImageToSupabase } from '../common/SupabaseStorageService';
import { insertUserInfo, updateUserInfo } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';

const PANEL_HEIGHT_RATIO: number = 0.58;
const PANEL_SHOW_DURATION: number = 300;
const PANEL_HIDE_DURATION: number = 250;
const PANEL_TOP_RADIUS: number = 20;
const MASK_TARGET_OPACITY: number = 1;

@Component
export struct EditUserInfoPage {
  private pathStack?: NavPathStack;
  @State panelTranslateY: number = 0;
  @State maskOpacity: number = 0;
  @State avatarUrl: string = '';
  @State avatarPreviewUri: string = '';
  @State nickname: string = '';
  @State ageText: string = '';
  @State signature: string = '';
  @State saveStatus: string = '';
  @State isSaving: boolean = false;
  private editingUserId: number = 0;

  private fillForm(user: UserInfo): void {
    this.editingUserId = user.id;
    this.avatarUrl = user.avatarUrl;
    this.avatarPreviewUri = '';
    this.nickname = user.nickname;
    this.ageText = user.age > 0 ? user.age.toString() : '';
    this.signature = user.signature;
  }

  private async handlePickAvatar(): Promise<void> {
    const uri = await pickImageUri();
    if (!uri) {
      return;
    }
    this.avatarPreviewUri = uri;
    this.saveStatus = '';
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

    let finalAvatarUrl = this.avatarUrl;
    if (this.avatarPreviewUri.length > 0) {
      this.saveStatus = '上传头像中...';
      const publicUrl = await uploadImageToSupabase(this.avatarPreviewUri);
      if (!publicUrl) {
        this.isSaving = false;
        this.saveStatus = '头像上传失败，请检查网络';
        return;
      }
      finalAvatarUrl = publicUrl;
    }

    const parsedAge = Number.parseInt(this.ageText, 10);
    const user = new UserInfo();
    user.id = this.editingUserId;
    user.avatarUrl = finalAvatarUrl;
    user.nickname = this.nickname.trim();
    user.age = Number.isNaN(parsedAge) ? 0 : parsedAge;
    user.signature = this.signature.trim();

    this.saveStatus = '保存中...';

    let result: UserInfo | undefined = undefined;
    if (this.editingUserId > 0) {
      result = await updateUserInfo(user);
    } else {
      result = await insertUserInfo(user);
    }
    this.isSaving = false;

    if (!result) {
      this.saveStatus = '保存失败，请检查网络';
      return;
    }

    this.saveStatus = '';
    this.closePage(result);
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
          Row()
            .width(40)
            .height(4)
            .backgroundColor('#DDDDDD')
            .borderRadius(2)
            .margin({ top: 8, bottom: 12 })

          Row() {
            Button({ type: ButtonType.Normal }) {
              SymbolGlyph($r('sys.symbol.checkmark'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(40)
            .height(40)
            .onClick(() => {
              this.closePage();
            })
          }
          .width('100%')
          .margin({ bottom: 16 })

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
      const param = ctx.pathInfo.param as UserInfo;
      if (param) {
        this.fillForm(param);
      }
    })
    .onShown(() => {
      this.showPanel();
    })
  }
}
