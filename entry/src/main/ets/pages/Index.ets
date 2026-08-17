import { HomeTabContent } from '../components/HomeTabContent';
import { MeTabContent } from '../components/MeTabContent';
import { UserListPage } from './UserListPage';
import { UserDetailPage } from './UserDetailPage';
import { EditUserInfoPage } from './EditUserInfoPage';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  appNavStack: NavPathStack = new NavPathStack();

  @Builder
  tabBuilder(title: Resource, index: number) {
    Column() {
      Text(title)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#666666')
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
    }
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
    }
  }

  build() {
    Navigation(this.appNavStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomeTabContent()
        }
        .tabBar(this.tabBuilder($r('app.string.tab_home'), 0))

        TabContent() {
          MeTabContent({ appNavStack: this.appNavStack })
        }
        .tabBar(this.tabBuilder($r('app.string.tab_me'), 1))
      }
      .width('100%')
      .height('100%')
      .barHeight(56)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.pageMap)
  }
}
