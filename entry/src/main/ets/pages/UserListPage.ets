interface UserInfo {
  id: number;
  name: string;
  desc: string;
}

@Builder
export function UserListPageBuilder() {
  UserListPage();
}

@Component
export struct UserListPage {
  appNavStack: NavPathStack = new NavPathStack()
  private readonly users: UserInfo[] = [
    { id: 1, name: '张三', desc: 'HarmonyOS 开发者' },
    { id: 2, name: '李四', desc: 'UI 设计师' },
    { id: 3, name: '王五', desc: '产品经理' },
    { id: 4, name: '赵六', desc: '测试工程师' },
    { id: 5, name: '钱七', desc: '架构师' },
    { id: 6, name: '孙八', desc: '运维工程师' },
    { id: 7, name: '李硕', desc: 'HarmonyOS 开发者' },
    { id: 8, name: '张飒', desc: 'UI 设计师' },
    { id: 9, name: '王鑫', desc: '产品经理' },
    { id: 10, name: '赵丽', desc: '测试工程师' },
    { id: 11, name: '钱律', desc: '架构师' },
    { id: 12, name: '苏娜', desc: '运维工程师' },
  ];

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button($r('app.string.back'))
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .fontColor('#007DFF')
            .onClick(() => {
              this.appNavStack.pop();
            })

          Text($r('app.string.user_list_title'))
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Blank()
            .width(48)
        }
        .width('100%')
        .padding({
          left: 12,
          right: 12,
          top: 12,
          bottom: 12
        })

        List() {
          ForEach(this.users, (user: UserInfo) => {
            ListItem() {
              Row() {
                Column() {
                  Text(user.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)

                  Text(user.desc)
                    .fontSize(13)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding({
                left: 16,
                right: 16,
                top: 14,
                bottom: 14
              })
            }
          }, (user: UserInfo) => user.id.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EEEEEE' })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onResult((ctx: NavDestinationContext) => {
      this.appNavStack = ctx.pathStack
    })
  }
}
