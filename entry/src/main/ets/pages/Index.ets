import { HomeTabContent } from '../components/HomeTabContent';
import { MeTabContent } from '../components/MeTabContent';
import { UserListPage } from './UserListPage';
import { UserDetailPage } from './UserDetailPage';
import { EditUserInfoPage } from './EditUserInfoPage';
import { TestPage } from './TestPage';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  appNavStack: NavPathStack = new NavPathStack();

  @Builder
  tabBuilder(icon: Resource, selectedIcon: Resource, title: Resource, index: number) {
    Row({space: 2}) {
      SymbolGlyph(this.currentIndex == index ? selectedIcon : icon)
      Text(title)
        .fontSize(14)
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
    }
    .opacity(this.currentIndex == index ? 1 : 0.5)
    .align(Alignment.Center)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  pageMap(name: string) {
    if (name === 'UserListPage') {
      UserListPage()
    } else if (name === 'UserDetailPage') {
      UserDetailPage()
    } else if (name === 'EditUserInfoPage') {
      EditUserInfoPage()
    } else if (name === 'TestPage') {
      TestPage()
    }
  }

  build() {
    Navigation(this.appNavStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomeTabContent()
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
        .tabBar(this.tabBuilder($r('sys.symbol.house'), $r('sys.symbol.house_fill'), $r('app.string.tab_home'), 0))

        TabContent() {
          MeTabContent({ appNavStack: this.appNavStack })
        }
        .tabBar(this.tabBuilder($r('sys.symbol.person_2'), $r('sys.symbol.person_2_fill'), $r('app.string.tab_me'), 1))
      }
      .scrollable(false)
      .width('100%')
      .height('100%')
      .barHeight(56)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .backgroundColor('#FFFFFF')
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .backgroundColor('#FFFFFF')
    .navDestination(this.pageMap)
  }
}
