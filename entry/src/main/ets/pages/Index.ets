import { HomeTabContent } from '../components/HomeTabContent';
import { MeTabContent } from '../components/MeTabContent';
import { HorizontalListPage } from './HorizontalListPage';
import { UserListPage } from './UserListPage';
import { DetailPage } from './DetailPage';

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
    if (name === 'HorizontalListPage') {
      HorizontalListPage()
    } else if (name === 'UserListPage') {
      UserListPage()
    } else if (name === 'DetailPage') {
      DetailPage()
    }
  }

  build() {
    Navigation(this.appNavStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomeTabContent({ appNavStack: this.appNavStack })
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
