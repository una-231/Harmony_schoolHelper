import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

interface Feature {
  title: string
  subTitle: string
  bg: string
  type: 'class' | 'notice' | 'guide' | 'mine'
  to: string
}
const FEATURES: Feature[] = [
  { title: '课程表', subTitle: '查看今日课程', bg: '#EAF2FF', type: 'class', to: 'pages/Timetable' },
  { title: '校园公告', subTitle: '最新通知', bg: '#E9FBF1', type: 'notice', to: 'pages/Notices' },
  { title: '校园导览', subTitle: '路线与地点', bg: '#FFF2E7', type: 'guide', to: 'pages/Guide' },
  { title: '个人中心', subTitle: '账号与设置', bg: '#F3E9FF', type: 'mine', to: 'pages/Profile' }
]

@Entry
@Component
struct Index {
  private features: Feature[] = FEATURES
  private searchIcon: Resource = $r('app.media.search')

  aboutToAppear(): void {
    // 登录态拦截（预览器/模拟器可能不支持路由，try 一下更稳）
    try {
      if (AppStorage.get('isLogin') !== true) {
        router.replaceUrl({ url: 'pages/Login' })
      }
    } catch (e) {}
  }

  private go(url: string): void {
    try {
      router.pushUrl({ url })
    } catch (e) {}
  }

  private toast(msg: string): void {
    try {
      promptAction.showToast({ message: msg })
    } catch (e) {}
  }

  build() {
    Column() {
      // ===== 顶部栏：标题严格居中，搜索固定右侧 =====
      Row() {
        // 左侧占位（和右侧按钮同宽），用于让标题真正居中
        Blank()
          .width(36)
          .height(36)

        // 中间标题区域：占满剩余空间，文字居中
        Text('校园生活助手')
          .layoutWeight(1)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .textAlign(TextAlign.Center)

        // 右侧搜索按钮
        Column() {
          Image(this.searchIcon)
            .width(22)
            .height(22)
        }
        .width(36)
        .height(36)
        .backgroundColor(Color.White)
        .borderRadius(18)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => this.toast('搜索（演示）'))
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 18 })
      // ====== 内容区（卡片） ======
      Column() {
        // 今日提醒卡：更现代的层级
        Row() {
          Column() {
            Text('今日提醒')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#111827')

            Text('请及时查看公告与课程变更通知')
              .fontSize(12)
              .fontColor('#6B7280')
              .margin({ top: 6 })
          }
          .margin({ left: 12 })
        }
        .padding(16)
        .backgroundColor('#fffffcfc')
        .borderRadius(18)

        // 功能卡片列表
        Column() {
          ForEach(this.features, (item: Feature) => {
            FeatureCard({
              title: item.title,
              subTitle: item.subTitle,
              bg: item.bg,
              type: item.type,
              to: item.to
            })
              .margin({ top: 12 })
          })
        }
        .margin({ top: 14 })
      }
      .padding({ left: 18, right: 18, top: 16 })
      .layoutWeight(1)

      // ====== 底部导航 ======
      BottomNav({ current: 0 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}

@Component
struct FeatureCard {
  @Prop title: string
  @Prop subTitle: string
  @Prop bg: string
  @Prop type: string
  @Prop to: string

  @State pressed: boolean = false

  private getIcon(): Resource {
    switch (this.type) {
      case 'class':
        return $r('app.media.class')
      case 'notice':
        return $r('app.media.notice')
      case 'guide':
        return $r('app.media.guide')
      case 'mine':
        return $r('app.media.mine')
      default:
        return $r('app.media.class')
    }
  }

  private go(): void {
    try {
      router.pushUrl({ url: this.to })
    } catch (e) {}
  }

  build() {
    Row() {
      // 左侧图标：白底圆角容器（现代）
      Column() {
        Image(this.getIcon())
          .width(24)
          .height(24)
      }
      .width(44)
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(14)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')

        Text(this.subTitle)
          .fontSize(12)
          .fontColor('#6B7280')
          .margin({ top: 6 })
      }
      .margin({ left: 12 })
      .layoutWeight(1)

      Text('›')
        .fontSize(22)
        .fontColor('#9CA3AF')
        .margin({ right: 2 })
    }
    .padding(16)
    .height(80)
    .backgroundColor(this.bg)
    .borderRadius(18)
    .shadow({ radius: 10, color: '#12000000', offsetX: 0, offsetY: 6 })
    .scale({ x: this.pressed ? 0.985 : 1, y: this.pressed ? 0.985 : 1 })
    .onTouch((e) => {
      if (e.type === TouchType.Down) this.pressed = true
      if (e.type === TouchType.Up) {
        this.pressed = false
        this.go()
      }
      if (e.type === TouchType.Cancel) this.pressed = false
    })
  }
}

@Component
struct BottomNav {
  @Prop current: number

  private go(index: number): void {
    if (index === this.current) return
    const map: Record<number, string> = {
      0: 'pages/Index',
      1: 'pages/Timetable',
      2: 'pages/Notices',
      3: 'pages/Guide',
      4: 'pages/Profile'
    }
    try {
      router.replaceUrl({ url: map[index] })
    } catch (e) {}
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
