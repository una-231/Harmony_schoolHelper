import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct Profile {
  private items: string[] = ['账号信息', '消息通知', '隐私与安全', '关于应用']

  aboutToAppear() {
    if (AppStorage.get('isLogin') !== true) {
      router.replaceUrl({ url: 'pages/Login' })
    }
  }

  private logout() {
    AppStorage.set('isLogin', false)
    promptAction.showToast({ message: '已退出登录' })
    router.replaceUrl({ url: 'pages/Login' })
  }

  build() {
    Column() {
      HeaderBar({ title: '个人中心', subTitle: '演示版（仅前端）' })

      Column() {
        // 顶部卡片
        Row() {
          Text('👤')
            .fontSize(26)
            .width(56)
            .height(56)
            .textAlign(TextAlign.Center)
            .backgroundColor('#E8F0FF')
            .borderRadius(18)

          Column() {
            Text((AppStorage.get('loginUser') as string) ?? '测试用户')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Text('学号：2025xxxxxx')
              .fontSize(12)
              .fontColor('#666')
              .margin({ top: 6 })
          }.margin({ left: 12 })
        }
        .padding(14)
        .backgroundColor('#F7F8FA')
        .borderRadius(16)

        // 设置列表
        Column() {
          ForEach(this.items, (t: string) => {
            Row() {
              Text(t).fontSize(14).layoutWeight(1)
              Text('>').fontSize(14).fontColor('#999')
            }
            .padding({ left: 14, right: 14, top: 14, bottom: 14 })
            .backgroundColor('#FFFFFF')
            .border({ width: { bottom: 1 }, color: '#F2F2F2' })
            .onClick(() => promptAction.showToast({ message: `点击：${t}` }))
          })
        }
        .margin({ top: 12 })
        .borderRadius(14)
        .backgroundColor('#FFFFFF')

        // 退出登录
        Button('退出登录')
          .width('100%')
          .height(48)
          .margin({ top: 14 })
          .backgroundColor('#F25C5C')
          .fontColor(Color.White)
          .borderRadius(14)
          .onClick(() => this.logout())
      }
      .padding({ left: 16, right: 16 })
      .layoutWeight(1)

      BottomNav({ current: 4 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}

@Component
struct HeaderBar {
  @Prop title: string
  subTitle: string = ''

  build() {
    Row() {
      Text('←')
        .fontSize(20)
        .width(36)
        .height(36)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .backgroundColor('#F7F8FA')
        .onClick(() => router.back())

      Column() {
        Text(this.title).fontSize(18).fontWeight(FontWeight.Bold)
        if (this.subTitle.length > 0) {
          Text(this.subTitle).fontSize(12).fontColor('#666').margin({ top: 4 })
        }
      }.margin({ left: 10 })
    }
    .padding({ left: 16, right: 16, top: 16, bottom: 10 })
  }
}

@Component
struct BottomNav {
  @Prop current: number
  private go(index: number):void {
    if (index === this.current) return
    const map: Record<number, string> = {
      0: 'pages/Index',
      1: 'pages/Timetable',
      2: 'pages/Notices',
      3: 'pages/Guide',
      4: 'pages/Profile',
    }
    router.replaceUrl({ url: map[index] })
  }

  build() {
    Row() {
      Column() {
        NavItem({ text: '首页', icon: '🏠', active: this.current === 0 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.go(0))

      Column() {
        NavItem({ text: '课程', icon: '📚', active: this.current === 1 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.go(1))

      Column() {
        NavItem({ text: '公告', icon: '📢', active: this.current === 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.go(2))

      Column() {
        NavItem({ text: '导览', icon: '🧭', active: this.current === 3 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.go(3))

      Column() {
        NavItem({ text: '我的', icon: '👤', active: this.current === 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => this.go(4))
    }
    .width('100%')
    .padding({ top: 8, bottom: 10 })
    .backgroundColor('#FFFFFF')
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }
}


@Component
struct NavItem {
  @Prop text: string
  @Prop icon: string
  @Prop active: boolean

  build() {
    Column() {
      Text(this.icon).fontSize(18)
      Text(this.text)
        .fontSize(12)
        .fontColor(this.active ? '#1677FF' : '#6B7280')
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Center)
  }
}
