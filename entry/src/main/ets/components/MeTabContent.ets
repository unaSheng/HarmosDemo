import { UserListPage } from '../pages/UserListPage';

@ComponentV2
export struct MeTabContent {
  @Param appNavStack: NavPathStack = new NavPathStack();
  @Local listRefreshKey: number = 0;

  private refreshUserList(): void {
    this.listRefreshKey++;
  }

  build() {
    Column() {
      Row({ space: 20 }) {
        Blank()
        Button() {
          SymbolGlyph($r('sys.symbol.person_badge_plus'))
            .fontSize(20)
            .fontWeight(500)
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.appNavStack.pushPath({
            name: 'EditUserInfoPage',
            onPop: () => {
              this.refreshUserList();
            },
          });
        })

        Button() {
          SymbolGlyph($r('sys.symbol.gearshape'))
            .fontSize(20)
            .fontWeight(500)
        }
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.appNavStack.pushPath({ name: 'TestPage' });
        })
      }
      .width('100%')
      .height(48)
      .padding({ left: 12, right: 12 })
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.SpaceEvenly)

      Divider().color('#EEEEEE')

      UserListPage({
        appNavStack: this.appNavStack,
        refreshKey: this.listRefreshKey,
      })
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
