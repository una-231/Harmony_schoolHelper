import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct Login {
  @State userName: string = ''
  @State password: string = ''
  @State pwdVisible: boolean = false

  private readonly OK_USER: string = 'student'
  private readonly OK_PWD: string = '123456'

  aboutToAppear() {
    // 如果你想“记住登录态”，这里不要每次都 set false
    AppStorage.setOrCreate('isLogin', false)
    if (AppStorage.get('isLogin') === true) {
      router.replaceUrl({ url: 'pages/Index' })
    }
  }

  private doLogin(): void {
    if (this.userName.trim().length === 0) {
      promptAction.showToast({ message: '请输入用户名' })
      return
    }
    if (this.password.trim().length === 0) {
      promptAction.showToast({ message: '请输入密码' })
      return
    }

    if (this.userName === this.OK_USER && this.password === this.OK_PWD) {
      AppStorage.set('isLogin', true)
      AppStorage.setOrCreate('loginUser', this.userName)
      promptAction.showToast({ message: '登录成功' })
      router.replaceUrl({ url: 'pages/Index' })
    } else {
      promptAction.showToast({ message: '用户名或密码错误' })
    }
  }

  private thirdLogin(type: string): void {
    promptAction.showToast({ message: `${type}（演示）` })
  }

  build() {
    Column() {
      // 标题
      Text('校园生活助手')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 80 })
        .alignSelf(ItemAlign.Center)

      // 表单
      Column() {
        // 用户名标题：靠左 + 大一点
        Text('用户名')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontColor('#333')
          .margin({ bottom: 8 })

        // 用户名输入框
        Row() {
          TextInput({ text: this.userName, placeholder: '请输入用户名（student）' })
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.Transparent)
            .padding({ left: 20, right: 20 })
            .onChange((value: string) => {
              this.userName = value
            })
        }
        .width('100%')
        .height(48)
        .backgroundColor('#F5F6F7')
        .borderRadius(24)

        // 密码标题
        Text('密码')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontColor('#333')
          .margin({ top: 18, bottom: 8})

        // 密码输入 + 眼睛按钮（你截图那套写法）
        Row() {
          TextInput({ text: this.password, placeholder: '请输入密码（123456）' })
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.Transparent)
            .padding({ left: 20 })
            .type(this.pwdVisible ? InputType.Normal : InputType.Password)
            .onChange((value: string) => {
              this.password = value
            })
        }
        .width('100%')
        .height(48)
        .backgroundColor('#F5F6F7')
        .borderRadius(24)

        // 登录按钮
        Button('登录')
          .width('100%')
          .height(48)
          .margin({ top: 26 })
          .backgroundColor('#1677FF')
          .fontColor(Color.White)
          .borderRadius(14)
          .onClick(() => this.doLogin())

        // 微信登录 / 手机号登录（均匀分布：图片 + 文字）
        Row() {
          Column() {
            ThirdLoginItem({ type: 'wechat', text: '微信登录' })
          }
          .onClick(() => this.thirdLogin('微信登录'))

          Column() {
            ThirdLoginItem({ type: 'phone', text: '手机号登录' })
          }
          .onClick(() => this.thirdLogin('手机号登录'))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: 44 })

      }
      .width('86%')
      .margin({ top: 44 })
      .alignSelf(ItemAlign.Center)

      Blank().layoutWeight(1)

      Text('© 2025 校园生活助手（课程实验）')
        .fontSize(10)
        .fontColor('#AAA')
        .margin({ bottom: 18 })
        .alignSelf(ItemAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}

// 第三方登录小组件：图片 + 下方文字（均匀分布用 SpaceAround）
@Component
struct ThirdLoginItem {
  @Prop type: string   // 'wechat' | 'phone'
  @Prop text: string

  private getIcon(): Resource {
    if (this.type === 'wechat') {
      return $r('app.media.wechat_login')
    }
    return $r('app.media.phone_login')
  }

  build() {
    Column() {
      Image(this.getIcon())
        .width(34)
        .height(34)

      Text(this.text)
        .fontSize(12)
        .fontColor('#666')
        .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Center)
  }
}


