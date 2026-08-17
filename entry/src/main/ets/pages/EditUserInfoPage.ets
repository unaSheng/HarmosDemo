import { pickImageUri, uploadImageToSupabase } from '../common/SupabaseStorageService';
import { insertUserInfo, updateUserInfo } from '../common/SupabaseUserService';
import { UserInfo } from '../model/UserInfo';

@Builder
export function EditUserInfoPageBuilder() {
  EditUserInfoPage();
}

@Component
export struct EditUserInfoPage {
  private pathStack?: NavPathStack;
  @State avatarUrl: string = '';
  @State avatarPreviewUri: string = '';
  @State avatarStatus: string = '';
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
    this.avatarStatus = '上传中...';

    const publicUrl = await uploadImageToSupabase(uri);
    if (!publicUrl) {
      this.avatarStatus = '上传失败';
      return;
    }

    this.avatarUrl = publicUrl;
    this.avatarStatus = '';
  }

  private async handleSave(): Promise<void> {
    if (this.isSaving) {
      return;
    }
    if (this.nickname.trim().length === 0) {
      this.saveStatus = '请输入昵称';
      return;
    }

    const parsedAge = Number.parseInt(this.ageText, 10);
    const user = new UserInfo();
    user.id = this.editingUserId;
    user.avatarUrl = this.avatarUrl;
    user.nickname = this.nickname.trim();
    user.age = Number.isNaN(parsedAge) ? 0 : parsedAge;
    user.signature = this.signature.trim();

    this.isSaving = true;
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
    this.pathStack?.pop(result);
  }

  build() {
    NavDestination() {
      Column() {
        Blank()
          .layoutWeight(1)
          .width('100%')
          .backgroundColor('#66000000')
          .onClick(() => {
            this.pathStack?.pop();
          })

        Column() {
          Row()
            .width(40)
            .height(4)
            .backgroundColor('#DDDDDD')
            .borderRadius(2)
            .margin({ top: 8, bottom: 12 })

          Row() {
            Text($r('app.string.edit_user_info_title'))
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            Button($r('app.string.close'))
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor('#666666')
              .fontSize(14)
              .onClick(() => {
                this.pathStack?.pop();
              })
          }
          .width('100%')
          .margin({ bottom: 16 })

          Column() {
            if (this.avatarUrl.length > 0) {
              Image(this.avatarUrl)
                .width(72)
                .height(72)
                .borderRadius(36)
                .objectFit(ImageFit.Cover)
            } else if (this.avatarPreviewUri.length > 0) {
              Image(this.avatarPreviewUri)
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

            if (this.avatarStatus.length > 0) {
              Text(this.avatarStatus)
                .fontSize(12)
                .fontColor('#666666')
                .margin({ top: 4 })
            }
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
                this.pathStack?.pop();
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
        .height('58%')
        .padding({ left: 16, right: 16, bottom: 24 })
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: 16, topRight: 16 })
      }
      .width('100%')
      .height('100%')
    }
    .mode(NavDestinationMode.DIALOG)
    .systemTransition(NavigationSystemTransitionType.SLIDE_BOTTOM)
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
      const param = ctx.pathInfo.param as UserInfo;
      if (param) {
        this.fillForm(param);
      }
    })
  }
}
